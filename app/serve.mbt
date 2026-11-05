// 本地预览用的静态服务器。站点是纯前端 SPA，数据靠 fetch('data/scenarios.json')
// 加载，用 file:// 直接打开会被浏览器同源策略拦住，所以必须走 HTTP。
// 这一步以前要另借系统里的静态服务器，现在直接用 @async/http 自带的 Server：
// 从采集、构建到「打开站点」，整条链路都只需要 moon，不再依赖仓库外的运行时。

///|
/// 扩展名 → MIME。dist/ 下只有这几种产物；未知的一律按二进制给。
/// 带 charset 的几项会让浏览器按 UTF-8 解码中文，不必靠猜。
fn mime_of(path : String) -> String {
  if path.has_suffix(".html") {
    "text/html; charset=utf-8"
  } else if path.has_suffix(".js") {
    "text/javascript; charset=utf-8"
  } else if path.has_suffix(".css") {
    "text/css; charset=utf-8"
  } else if path.has_suffix(".json") {
    "application/json; charset=utf-8"
  } else if path.has_suffix(".svg") {
    "image/svg+xml"
  } else if path.has_suffix(".png") {
    "image/png"
  } else if path.has_suffix(".ico") {
    "image/x-icon"
  } else if path.has_suffix(".md") {
    "text/markdown; charset=utf-8"
  } else {
    "application/octet-stream"
  }
}

///|
/// 把请求路径变成 dist/ 下的相对路径。顺手挡掉 query、目录穿越和奇怪字符：
/// 只是本地预览，也不该把 dist/ 之外的文件递出去。
fn static_path(req : String) -> String? {
  let p = match req.find("?") {
    Some(i) => req[:i].to_owned()
    None => req
  }
  if !p.has_prefix("/") ||
    p.contains("..") ||
    p.contains("\\") ||
    p.contains("%") {
    return None
  }
  for c in p {
    let ok = (c >= 'a' && c <= 'z') ||
      (c >= 'A' && c <= 'Z') ||
      (c >= '0' && c <= '9') ||
      c == '/' ||
      c == '.' ||
      c == '-' ||
      c == '_'
    if !ok {
      return None
    }
  }
  Some(if p == "/" { "/index.html" } else { p })
}

///|
/// 起一个只服务 dist/ 的 HTTP 服务，Ctrl+C（全局取消信号）即可退出。
/// 请求之间不共享状态，每个连接由 run_forever 自己派协程；allow_failure 让
/// 单个连接出错（比如浏览器提前断开）不至于把整个服务带下线。
pub async fn serve_dist(root : String, port : Int) -> Unit {
  let dist = join(root, "dist")
  if !@sys.sys_path_exists(join(dist, "index.html")) {
    println("找不到 \{dist}/index.html，请先执行 moon run . -- --build")
    return
  }
  let addr = @socket.Addr::parse("127.0.0.1:\{port}")
  // reuse_addr：Ctrl+C 后立刻重启时，端口可能还在 TIME_WAIT，不加会报
  // "Address already in use"，得等一分钟才能再开。
  let server = @http.Server(addr, reuse_addr=true)
  println("本地预览已启动： http://127.0.0.1:\{port}/")
  println("服务目录：\{dist}   Ctrl+C 停止")
  server.run_forever(allow_failure=true) <| ((req, _body, conn) => {
    // 错误页一律用 ASCII：Content-Length 按字符数算，中文会让长度对不上。
    let bad = (code : Int32, reason : String, text : String) => {
      conn.send_response(code, reason, extra_headers={
        "Content-Type": "text/plain; charset=utf-8",
        "Content-Length": text.length().to_string(),
        "Cache-Control": "no-cache",
      })
      conn.write_string(text)
    }
    match static_path(req.path) {
      None => bad(400, "Bad Request", "400 Bad Request\n")
      Some(p) => {
        // 目录、无扩展名的路径都不是站点产物，直接当 404。
        let file = dist + p
        if !p.contains(".") || !@sys.sys_path_exists(file) {
          bad(404, "Not Found", "404 Not Found: " + p + "\n")
        } else {
          // 同步读即可：dist/ 最大的文件是 1MB 量级的 JSON，本地磁盘一瞬的事。
          // 读不到就是 None，正好当 404，不必让单个连接的异常惊动服务。
          let payload : Bytes? = @sys.sys_read_bytes_file(file)
          match payload {
            None => bad(404, "Not Found", "404 Not Found: " + p + "\n")
            Some(bytes) => {
              conn.send_response(200, "OK", extra_headers={
                "Content-Type": mime_of(p),
                "Content-Length": bytes.length().to_string(),
                "Cache-Control": "no-cache",
              })
              // HEAD 只给头，不写 body（curl -I / 浏览器预检会用到）
              if req.meth != @http.RequestMethod::Head {
                conn.write(bytes)
              }
            }
          }
        }
      }
    }
  })
}
