# PROGRESS — VoiceInk Fork

## Orbit refs

- Project: `voiceink_fork`
- Active tickets: `ORB-0177`, `ORB-0178`
- Decisions: none

## Current state

### Working

- Upstream `main` ist als lokaler Ausgangsstand ausgecheckt.
- `upstream` und `origin` sind konfiguriert.
- Branch `custom/live_streaming` ist von `upstream/main` abgezweigt.
- `VoiceInk/Custom/Configuration/CustomFeatureConfiguration.swift` ist mit
  deaktivierten Schaltern angelegt.

### Open

- Baseline-Build muss noch ausgeführt beziehungsweise abgeschlossen werden.
- Erster eigener Streaming-Provider ist ausdrücklich nicht Teil dieses Blocks.

### Blocked

- none

## Last verified

- Date: 2026-08-28
- Commit: `b1834ae` (`Document baseline check workflow`)
- Branch: `custom/live_streaming`
- Environment: local macOS repository setup
- Automated: `make check` passed; Custom-Datei syntaktisch geprüft
- Manual: none
- Not verified: Xcode compilation, app launch, audio, permissions, device/user acceptance
- Git status: committed and pushed to `origin/custom/live_streaming`

## Log

### 2026-08-28 — Prepare personal fork baseline

- Changed: GitHub-Fork angelegt, Remotes eingerichtet, Custom-Bereich und
  deaktivierte Konfiguration vorbereitet.
- Decisions: Upstream-Dateien bleiben unverändert; zukünftige Streaming-Arbeit
  verwendet `StreamingTranscriptionProvider` und `StreamingTranscriptionService`.
- Verified: GitHub-Zugriff, `upstream/main`, Remote-/Branch-Zustand und relevante
  Protocol-/Registry-Dateien geprüft.
- Not verified: Full Xcode app build; Whisper-XCFramework built successfully,
  but Xcode stopped at `CudaBuild` package-plugin validation; manuelle
  App-Abnahme.
- Git: `dbccf83`, `aa4e427`, `c116c00`, `b1834ae`, pushed to `origin/custom/live_streaming`
- Orbit: `ORB-0176` done, `ORB-0177` und `ORB-0178` ready
- Next: `ORB-0177` bearbeiten, danach `ORB-0178`.

### 2026-08-29 — Orbit-Projekt und Folge-Tickets angelegt

- Changed: Orbit-Projekt `voiceink_fork` angelegt und die Fork-Basis, das
  CudaBuild-/Dependency-Thema sowie die Streaming-Architektur als Tickets erfasst.
- Decisions: Keine neue Architekturentscheidung; das CudaBuild-Thema bleibt
  zunächst ein separates Wartungs-/Recherche-Ticket.
- Verified: Orbit-JSON und Events validiert.
- Not verified: CudaBuild-Workaround und Dependency-Update noch offen.
- Git: keine Repository-Änderung in diesem Schritt.
- Orbit: `ORB-0176` done, `ORB-0177` und `ORB-0178` ready
- Next: `ORB-0177` bearbeiten, danach `ORB-0178`.
