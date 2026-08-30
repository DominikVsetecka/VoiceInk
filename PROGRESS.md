# PROGRESS — VoiceInk Fork

## Orbit refs

- Project: `voiceink_fork`
- Active tickets: `ORB-0177`, `ORB-0178`, `ORB-0180`
- Decisions: none

## Current state

### Working

- Upstream `main` ist als lokaler Ausgangsstand ausgecheckt.
- `upstream` und `origin` sind konfiguriert.
- Branch `custom/live_streaming` ist von `upstream/main` abgezweigt.
- `VoiceInk/Custom/Configuration/CustomFeatureConfiguration.swift` enthält
  zentrale Schalter; OpenAI Whisper v1 ist aktiviert, Live-Streaming bleibt
  deaktiviert.
- OpenAI Whisper v1 ist als eigener CloudProvider unter `VoiceInk/Custom/`
  integriert.
- Die Hybrid-Vorschau verwendet lokal installiertes Parakeet V3 während der
  Aufnahme und OpenAI Whisper v1 für das finale Ergebnis.
- Der lokale Apple-Silicon-Build funktioniert mit `make local` und kopiert die
  signierte App nach `~/Downloads/VoiceInk.app`.
- `make local-release` erzeugt zusätzlich einen optimierten lokalen Release-
  Build; VoiceInk Refine bleibt dabei vollständig enthalten.
- Die globale Shortcut-Registrierung versucht sich nach Berechtigungs- und
  macOS-Lifecycle-Ereignissen automatisch erneut zu verbinden.
- Berechtigungen können nun in einem eigenen Settings-Tab geprüft und erneut in
  den macOS-Systemeinstellungen geöffnet werden; das Onboarding kann übersprungen
  werden.
- Die lokale API-Kostenschätzung zeigt OpenAI-Whisper-Kosten pro History-Eintrag,
  in den Details und aggregiert für ausgewählte Einträge; Preis und Währung sind
  in Settings → API Costs konfigurierbar.

### Open

- Die App muss noch manuell gestartet und hinsichtlich Mikrofon-, Audio- und
  Berechtigungsverhalten abgenommen werden.
- Eigener Streaming-Provider ist ausdrücklich nicht Teil dieses Blocks.

### Blocked

- none

## Last verified

- Date: 2026-08-30
- Commit: `cd09036` (`Retry global shortcuts after permission and wake events`)
- Branch: `custom/live_streaming`
- Environment: local Apple-Silicon macOS, Xcode 26.6, Swift 6.3.3
- Automated: `make check` passed; `make local` passed; App-Bundle erzeugt und
  nach `~/Downloads/VoiceInk.app` kopiert
- Manual: none
- Not verified: App launch, audio, permissions, device/user acceptance
- Git status: clean after the hotkey-recovery commit

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

### 2026-08-30 — Hotkey-Recovery ergänzt

- Changed: `RecordingShortcutManager` registriert den globalen Event-Tap nach
  Aktivierung, Aufwachen und Display-Ereignissen erneut und wiederholt die
  Registrierung kurzzeitig, falls macOS noch nicht bereit ist.
- Verified: Lokaler Apple-Silicon-Xcode-Build erfolgreich; manuelle Hotkey- und
  Overlay-Abnahme sowie die neue Berechtigungsansicht stehen noch aus.
- Git: `cd09036` (Hotkey-Recovery).

### 2026-08-30 — Optimierten lokalen Release-Build ergänzt

- Changed: `Makefile` parametrisiert die lokale Konfiguration und bietet den
  neuen Befehl `make local-release` an.
- Decision: VoiceInk Refine bleibt im Bundle, auch wenn es aktuell nicht
  aktiviert ist; der Debug-Build wird für die normale Nutzung durch Release
  ersetzt.
- Verified: Separater Release-Vergleich erfolgreich; Bundle-Größe ca. 146 MB
  statt ca. 205 MB im installierten Debug-Build.

### 2026-08-30 — Lokale API-Kostenschätzung ergänzt

- Changed: Fork-eigene Kostenkonfiguration und Berechnung unter
  `VoiceInk/Custom/Usage/` ergänzt; bestehende Transcription-SwiftData-Struktur
  bleibt unverändert.
- Changed: Kostenbadge für einzelne OpenAI-Whisper-Einträge sowie aggregierte
  Anzeige im bestehenden History-Analysepanel und ein eigener Settings-Tab.
- Decision: Erste Version bleibt bewusst eine lokale Schätzung. Historische
  Preis-Snapshots und ein direkter OpenAI-Usage-Abgleich bleiben spätere Schritte.
- Verified: `make local-release` erfolgreich; App aktualisiert und signiert nach
  `/Applications/VoiceInk.app`.
- Orbit: `ORB-0180` erledigt.

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
