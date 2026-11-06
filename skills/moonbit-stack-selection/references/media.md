# 音频 / 视频（`media`）

*Audio / Video*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/media>

音频采集与播放、音频编码、MIDI、麦克风与设备接口。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`moonbit-community/proton_microphone`** v0.7.0 — Microphone capture device and session helpers.
- **`Milky2018/moon_rodio`** v0.3.7 — Native-only MoonBit port of Rust rodio with playback pipeline, source effects, and WAV/MP3/FLAC/Vorbis/MP4A de…
- **`justjavac/microphone`** v0.1.3 — Microphone capture device and session helpers.
- **`mizchi/audio`** v0.1.1 — audio encoder for wav/ogg
- **`moonbit-community/microphone`** v0.1.14 — Microphone capture device and session helpers.
- **`Milky2018/moon_cpal`** v0.11.8 — A MoonBit port (subset) of RustAudio/cpal.
- **`Ridge-Lab/moonwavkit`** v0.1.3 — MoonBit-native WAV parser, PCM decoder, waveform analysis, validation, and audio utility toolkit.
- **`riantr/snn_mbt`** v0.166.2 — Bit-exact MoonBit port of SpikingNeuralNetworks.jl, extended with modern training machinery. NEURONS AND PLAST…
- **`LL728/moonopus`** v0.2.2 — 纯 MoonBit 实现的 Ogg Opus 容器与 CELT 音频解码器，不依赖任何 C 库或系统编解码器
- **`CAIMEOX/midi`** v0.1.0 — A MIDI file parser and writer in MoonBit
- **`Sakuraqwq1/moonflac-encoder`** v0.5.5 — Pure MoonBit FLAC encoder: turn interleaved PCM into a native .flac stream with fixed and LPC prediction, Rice…
- **`Xcsa-ee/moonflac`** v0.3.4 — 纯 MoonBit 实现的 FLAC 无损音频解码器，不依赖任何 C 库或系统编解码器
- **`hyl-star/moonsic`** v0.1.0 — A MoonBit music IR and interoperability library with MIDI, MusicXML, WAV, and browser event export.
- **`cp15695540483/moontag`** v0.2.1 — 纯 MoonBit 实现的音频标签元数据读写库（ID3v2 / Vorbis Comment / APEv2 / MP4 ilst），不依赖任何 C 库
- **`NoahLiu/ffmpeg-mbt`** v0.2.0 — FFmpeg 的 MoonBit 封装：音视频解码/转码/封装的进程内绑定，链接系统 ffmpeg 开发包，为 gui-media 提供媒体解码层
- **`colmugx/ai-passport`** v0.2.6 — MoonBit application SDK and host toolchain for supported embedded devices and the Web host.
- **`moonbit-community/moon_cpal`** v0.11.8 — A MoonBit port (subset) of RustAudio/cpal.
- **`dowdiness/moondsp`** v0.6.0 — MoonBit DSP audio engine
- **`bw448/moon-wav`** v0.3.0 — MoonBit 原生 WAV 音频解码库 | A native MoonBit WAV audio decoding library
- **`Sakuraqwq1/moonaudio`** v0.3.2 — Pure MoonBit audio toolkit: WAV/AIFF/AU/FLAC decoding, PCM conversion, resampling, FFT and spectrograms, with …
- **`enanandesu/mp3`** v0.1.0 — Pure MoonBit MPEG-1/2/2.5 Layer III decoder with whole-file and streaming PCM APIs. Supports native, wasm, was…
- **`NoahLiu/gui-media`** v0.2.0 — native-gui 的媒体扩展（独立模块，媒体因此对主模块消费者保持「模块级可选」）：media/ 是新栈引擎（ffmpeg 解码 + miniaudio 设备直出），src/ 是旧链声明式播放器组件（待示例迁移完成后…
- **`Sakuraqwq1/moonmp3-encoder`** v0.2.1 — Pure MoonBit MPEG-1 Layer III encoder: 44.1 kHz mono/stereo, 128 kbps CBR, polyphase filterbank and MDCT, scal…
- **`CXREN/flac`** v0.1.0 — Pure-MoonBit FLAC lossless audio decoder: parses stream metadata and decodes frames to PCM with no native depe…
- **`matrix486/moonflactag`** v0.4.0 — Pure MoonBit FLAC tags, pictures and lossless metadata rewriting
- **`moonbitstack/moonmedia`** v0.1.1 — Streaming playlists and containers for MoonBit: m3u8, MPD, MPEG-TS, fMP4 and RTMP.
- **`LL728/moonvorbis`** v0.1.4 — 纯 MoonBit 实现的 OGG/Vorbis 音频解码器，不依赖任何 C 库或系统编解码器
- **`gaato/discord_voice`** v0.3.1 — Experimental Discord voice for gaato/discord bots on MoonBit's native backend: voice gateway v8, Opus playback…
- **`trkbt10/isobmff`** v0.1.0 — ISO Base Media File Format parser for extracting duration and track info from MP4, 3GP, 3G2, MJ2, HEIF, F4V, D…
- **`mizchi/kagura_audio`** v0.6.0 — Backend-agnostic audio output contracts for Kagura (AudioOutputHooks injection point over mizchi/audio; extrac…

*其余基础库见 [media-libs.md](media-libs.md) 全量分册。*
