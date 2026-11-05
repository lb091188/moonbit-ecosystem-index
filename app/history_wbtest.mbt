// 采集历史的写入语义测试。趋势图只有一个数据源，同一天出现两个点、日期乱序、
// 或重跑时把整段历史冲掉，都比画错一根线麻烦，所以这几条单独测一遍。

///|
test "history：同日覆盖、跨日追加、日期升序" {
  let root = "/tmp/moonbit-eco-index-history-wbtest"
  let path = join(root, HISTORY_PATH)
  // 每次从干净状态起跑；write_text 会自己建目录
  let _ = @sys.sys_remove_file(path)
  try {
    // 第一条
    let _ = record_history(root, "2026-11-02 12:02", 3520, 10527259.0, 3518)
    assert_eq(read_history(root).length(), 1)

    // 同一天重跑：不新增点，数字以这次为准；「较上次」应为空（还没有别的日期）
    let (prev_same, _) = record_history(
      root, "2026-11-02 18:40", 3521, 10530000.0, 3519,
    )
    match prev_same {
      Some(_) => assert_true(false, msg="同日重跑不该拿到别的日期作为上一次")
      None => ()
    }
    let same = read_history(root)
    assert_eq(same.length(), 1)
    assert_eq(same[0].date, "2026-11-02")
    assert_eq(same[0].at, "2026-11-02 18:40")
    assert_eq(same[0].packages, 3521)
    assert_eq(same[0].with_dl, 3519)

    // 新的一天：追加，并且「较上次」拿的是同日覆盖后的那条
    let (prev, _) = record_history(root, "2026-11-05 03:55", 3556, 10796732.0, 3556)
    match prev {
      Some(p) => {
        assert_eq(p.date, "2026-11-02")
        assert_eq(p.packages, 3521)
      }
      None => assert_true(false, msg="跨日追加应返回上一次采集")
    }
    let two = read_history(root)
    assert_eq(two.length(), 2)
    assert_eq(two[0].date, "2026-11-02")
    assert_eq(two[1].date, "2026-11-05")

    // 回填一个更早的日期，仍要按日期升序落盘（回填历史快照就走这条路）
    let _ = record_history(root, "2026-10-28 09:00", 3400, 10000000.0, 3398)
    let three = read_history(root)
    assert_eq(three.length(), 3)
    assert_eq(three[0].date, "2026-10-28")
    assert_eq(three[1].date, "2026-11-02")
    assert_eq(three[2].date, "2026-11-05")
  } catch {
    e => {
      println("history wbtest 失败：\{e}")
      assert_true(false, msg="history wbtest 抛错")
    }
  }
  let _ = @sys.sys_remove_file(path)
}

///|
test "history：文件损坏时退化为空历史，不抛错" {
  let root = "/tmp/moonbit-eco-index-history-wbtest-bad"
  let path = join(root, HISTORY_PATH)
  try {
    write_text(path, "{ 这不是 JSON")
    assert_eq(read_history(root).length(), 0)
  } catch {
    e => {
      println("history wbtest 失败：\{e}")
      assert_true(false, msg="history wbtest 抛错")
    }
  }
  let _ = @sys.sys_remove_file(path)
}

///|
test "history：数字格式化" {
  assert_eq(fmt_int(10796732), "10,796,732")
  assert_eq(fmt_int(0), "0")
  assert_eq(fmt_signed(269473), "+269,473")
  assert_eq(fmt_signed(-3), "-3")
  assert_eq(fmt_signed(0), "±0")
}
