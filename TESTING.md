# TESTING — VoiceInk Fork

Diese Datei trennt automatisierte Build-Prüfung von manueller und geräteabhängiger
Abnahme. Im ersten Setup wurden keine Laufzeitfeatures verändert.

## Environments

- Local development: macOS 14.4+, Xcode, Swift und lokale Whisper-Abhängigkeit
- CI: not configured
- Browser/simulator: not applicable
- Physical device: not applicable; Ziel ist eine macOS-App
- Staging: not configured
- Production: not configured

## Commands

- Setup: `make setup`
- Prerequisites: `make check`
- Format check: not configured
- Lint: not configured
- Typecheck: durch den Swift/Xcode-Build
- Unit tests: Xcode test target vorhanden; separater Testlauf nicht konfiguriert
- Integration tests: not configured
- End-to-end tests: not configured
- Build: `make build`
- Local Apple-Silicon build: `make local`
- OpenAI Whisper v1: configure an OpenAI API key, select `OpenAI / Whisper v1`,
  record a short sample, stop recording, and verify the returned transcript.
- Hybrid preview: enable `Real-time` in the selected mode, keep `Live Text
  Display` enabled, and verify that Parakeet V3 text appears while speaking;
  after stopping, verify that the final saved text comes from OpenAI.
- Hotkey recovery: after launching VoiceInk, granting Accessibility, waking the
  Mac, or reconnecting a display, verify that the global recording shortcut
  still starts and stops recording.
- Permissions settings: open Settings → Permissions, verify the three current
  status values, use Refresh, and open each corresponding macOS settings pane.
- Onboarding skip: reset onboarding, select Skip Setup, confirm, and verify that
  the app opens normally and permissions remain manageable from Settings.
- Fast check: `make check`
- Full check: `./scripts/check`

`./scripts/check` führt `make check` und anschließend `make build` aus. Der
Build kann beim ersten Lauf das Whisper-XCFramework aus dem Netzwerk laden und
kompilieren.

## Verification levels

### Fast check

- `make check`
- Diff und geänderte Custom-Dateien prüfen

### Full automated check

- `./scripts/check`
- Build-Ausgabe auf echte Fehler und Warnungen prüfen

### Manual acceptance

- App nach erfolgreichem Build mit `make run` starten
- Bestehendes VoiceInk-Aufnahme-/Transkriptionsverhalten stichprobenartig
  prüfen; für diesen Basisschritt ist keine Custom-Funktion zu erwarten

## Automated coverage

- Unit: `VoiceInkTests/`; Verhalten und Umfang des Upstream-Testtargets wurden
  in diesem Basisschritt nicht separat ausgeführt.
- Integration: not configured
- End-to-end: not configured

## Manual acceptance scenarios

### Scenario 1 — Upstream baseline build

- Environment: macOS mit Xcode und Whisper-Abhängigkeit
- Given: Branch `custom/live_streaming`, Custom-Features deaktiviert
- When: `./scripts/check`
- Expected: Upstream-App kompiliert ohne Custom-Laufzeitänderung
- Evidence: Xcodebuild-Log

### Scenario 2 — OpenAI Whisper v1 cloud transcription

- Environment: gebaute macOS-App mit OpenAI API-Key und aktivierter Abrechnung
- Given: `OpenAI / Whisper v1` ausgewählt
- When: kurze Aufnahme starten und anschließend stoppen
- Expected: Die Aufnahme wird nach dem Stoppen über OpenAI transkribiert; es
  gibt keine Live-Partial-Transkription.
- Evidence: Transkript und ggf. Fehlermeldung prüfen

### Scenario 3 — Existing behavior remains the default

- Environment: gebaute macOS-App
- Given: `CustomFeatureConfiguration` bleibt deaktiviert
- When: bestehende Aufnahme-/Transkriptionsfunktion verwenden
- Expected: Verhalten entspricht dem unveränderten Upstream-Stand
- Evidence: manuelle Prüfung, derzeit offen

## Warnings and limitations

- Erster Build kann externe Netzwerk- und Toolchain-Voraussetzungen benötigen.
- Signierung, tatsächlicher App-Start, Audio-Berechtigungen und Transkription
  wurden in diesem Setup noch nicht verifiziert.
