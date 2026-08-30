# Claude Project Context

Lies vor größerer Arbeit zuerst `AGENTS.md`. Die Fork-spezifischen Änderungen
und Konfliktstellen stehen in `CUSTOM_CHANGES.md`.

## Projektkontext

- Project ID: not configured
- Purpose: Persönlicher, updatefähiger VoiceInk-Fork
- Stack: Swift/macOS/Xcode/SwiftData/SwiftPM
- Repository root: `/Users/dominikvsetecka/Documents/Projekte/voiceink_fork`
- Default branch: `main`
- Current working branch: `custom/live_streaming`

## Einstiegspunkte

- Application entry: `VoiceInk/AppDelegate.swift`
- Transcription registry: `VoiceInk/Transcription/Engine/TranscriptionServiceRegistry.swift`
- Streaming lifecycle: `VoiceInk/Transcription/Streaming/StreamingTranscriptionService.swift`
- Streaming contract: `VoiceInk/Transcription/Streaming/StreamingTranscriptionProvider.swift`
- Tests: `VoiceInkTests/`, `VoiceInkUITests/`
- Build: `Makefile`, `BUILDING.md`, `VoiceInk.xcodeproj`
- Fork-owned area: `VoiceInk/Custom/`

## Kritische Invarianten

- `main` bleibt möglichst nah an `upstream/main`.
- Custom-Features sind standardmäßig deaktiviert.
- Keine parallele Streaming-Architektur neben dem bestehenden Service.
- Upstream-Dateien nur an kleinen, begründeten Integrationspunkten ändern.

## Lokale Kommandos

- Setup: `make setup` (bereitet das Whisper-Framework vor)
- Prerequisite check: `make check`
- Build: `make build`, `make local` (Debug) oder `make local-release` (Release)
- Full check: `./scripts/check`
- Run: `make run` nach vorhandenem Build
- Deploy: not configured
