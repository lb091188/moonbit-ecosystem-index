# 图像编解码（`img`）

*Image Codecs*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/img>

图像格式的编解码与像素处理：PNG / JPEG / GIF / BMP / QOI / WebP。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`mizchi/pixelmatch`** v0.6.2 — Fast pixel-level image comparison library for MoonBit/WASM
- **`mizchi/image`** v0.4.3 — Image codec primitives for MoonBit with PNG/BMP/JPEG decode+encode, GIF/WebP/ICO/AVIF encode, and resize.
- **`gmlewis/image`** v0.17.18 — MoonBit image: simple image representation.
- **`riantr/moonbit_image`** v0.3.9 — Pure-MoonBit image decoder/encoder covering BMP / QOI / TGA / PNG / GIF / JPEG / ICO / TIFF / FIM with zero ex…
- **`riantr/snn_mbt`** v0.166.2 — Bit-exact MoonBit port of SpikingNeuralNetworks.jl, extended with modern training machinery. NEURONS AND PLAST…
- **`Nanaloveyuki/image`** v0.1.4 — Pure MoonBit image codecs and icon container encoders.
- **`walkzzz/image`** v0.5.0 — MoonBit image library: pure MoonBit backend for native/wasm-gc/js/wasm multi-target support.
- **`trkbt10/jpeg2000`** v0.2.0 — T.800-2015 JPEG 2000 decoder for MoonBit
- **`0717lee/pixelforge`** v0.19.0 — Pure MoonBit image processing library with filters, morphology, color-space operations, affine transforms, dra…
- **`shunge/image`** v0.2.1 — 纯 MoonBit 图像解码库，支持 BMP/QOI/TGA/PNG/GIF/JPEG 六种格式、渐进式 JPEG、Adam7 PNG 和 GIF 动画，内置 DEFLATE/LZW/RLE 解压及资源边界检查。
- **`megemini/millow`** v0.3.1 — A zero-FFI, cross-platform image-processing library for MoonBit.
- **`TryAndRun-TvT/png-moon`** v0.1.2 — PNG encoder/decoder written in MoonBit
- **`Asterless/MoonQOI`** v0.1.3 — QOI (Quite OK Image Format) encoder/decoder library for MoonBit
- **`Milky2018/svgdiff-image-compat`** v0.1.0 — WIP image codec primitives for MoonBit (PNG-first).
- **`Milky2018/svgdiff-pixelmatch`** v0.1.0 — Fast pixel-level image comparison library for MoonBit/WASM
- **`WGYo90/moonbit-gif`** v0.1.0 — A mizchi/image extension for multi-frame GIF89a composition, palette quantization, and streaming LZW.
- **`WENwenZU/moon-webp`** v0.1.2 — Pure MoonBit decoder for lossless WebP (VP8L) images, with container, alpha, and animation support
- **`yuzhiblue/moon-watermark`** v0.1.18 — Image watermark library for MoonBit: visible and invisible traceable watermarks with embed/extract/verify APIs…
- **`moonbitstack/moonimage`** v0.1.2 — Image codecs for MoonBit: PNG, QOI, BMP, TGA, JPEG, GIF and WebP, and the pixel arithmetic between them.
- **`riantr/moonbit_labeler`** v0.2.14 — Image / video labeling backend for the MoonBit Labeler app: 24 async ops over @fs/@json for folder browsing, i…
- **`V1GreenSummer/paddleocr`** v0.1.1 — PaddleOCR glue for MoonBit: JPEG/PNG/BMP decode, DBNet boxes, CTC decode, and native ONNX Runtime inference.
- **`CXREN/moonocr`** v0.1.0 — A pure-MoonBit OCR engine: BMP/PGM/PPM decoding, binarization, segmentation, feature extraction and nearest-ne…
- **`PixelPoet/pixelate`** v0.1.3 — Image pixelation and color quantization core for PixelPoet.
- **`MYmodddd/pixelate`** v0.1.6 — Image pixelation and color quantization core for PixelPoet.
- **`gaato/png`** v0.1.0 — A streaming PNG and APNG decoder for MoonBit: arbitrary input chunks, whole rows into bounded output slices, t…
- **`shencangsheng513/moonmeta`** v0.1.0 — Read, write and redact EXIF metadata in JPEG, PNG and TIFF files, in pure MoonBit.
- **`PingGuoMiaoMiao/MoonVision`** v0.2.5 — MoonBit-native lightweight image processing and basic computer vision algorithms.
- **`mizchi/crater-terminal-image-cache`** v0.19.0 — Terminal image cache entry format and raster normalization helpers for crater
- **`cjyhjy/visionleak`** v0.8.0 — Bounded image fingerprint and cross-split evidence audit
- **`Zzqy-yi/firmware-image-toolkit`** v0.1.0 — Validated Intel HEX and Motorola S-record firmware image toolkit

*其余基础库见 [img-libs.md](img-libs.md) 全量分册。*
