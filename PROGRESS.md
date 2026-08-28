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
- Der lokale Apple-Silicon-Build funktioniert mit `make local` und kopiert die
  signierte App nach `~/Downloads/VoiceInk.app`.

### Open

- Die App muss noch manuell gestartet und hinsichtlich Mikrofon-, Audio- und
  Berechtigungsverhalten abgenommen werden.
- Erster eigener Streaming-Provider ist ausdrücklich nicht Teil dieses Blocks.

### Blocked

- none

## Last verified

- Date: 2026-08-29
- Commit: pending (`Make local Apple-Silicon build reproducible`)
- Branch: `custom/live_streaming`
- Environment: local Apple-Silicon macOS, Xcode 26.6, Swift 6.3.3
- Automated: `make check` passed; `make local` passed; App-Bundle erzeugt und
  nach `~/Downloads/VoiceInk.app` kopiert
- Manual: none
- Not verified: App launch, audio, permissions, device/user acceptance
- Git status: changes ready for commit

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

### 2026-08-29 — Reproducible local Apple-Silicon build

- Changed: `make local` erhält die notwendige `CRYPTO_IN_SWIFTPM`-Bedingung
  und die lokalen Xcode-Validierungsoptionen.
- Verified: `make local` erfolgreich; `CudaBuild` meldet auf macOS weiterhin
  korrekt `CUDA is disabled`; App wurde nach `~/Downloads/VoiceInk.app` kopiert.
- Not changed: Keine VoiceInk-App-Quelldatei, kein Provider und keine
  Streaming-Implementierung.

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
