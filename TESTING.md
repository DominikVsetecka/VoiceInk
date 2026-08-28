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

### Scenario 2 — Existing behavior remains the default

- Environment: gebaute macOS-App
- Given: `CustomFeatureConfiguration` bleibt deaktiviert
- When: bestehende Aufnahme-/Transkriptionsfunktion verwenden
- Expected: Verhalten entspricht dem unveränderten Upstream-Stand
- Evidence: manuelle Prüfung, derzeit offen

## Warnings and limitations

- Erster Build kann externe Netzwerk- und Toolchain-Voraussetzungen benötigen.
- Signierung, tatsächlicher App-Start, Audio-Berechtigungen und Transkription
  wurden in diesem Setup noch nicht verifiziert.
