# PLAN — VoiceInk Fork — Baseline Setup

## Orbit refs

- Project: `voiceink_fork`
- Active tickets: `ORB-0177`, `ORB-0178`
- Completed setup: `ORB-0176`
- Decisions: none

## Goal

Eine updatefähige persönliche Fork-Basis herstellen, ohne bestehende VoiceInk-
Funktionalität oder Streaming-Code zu verändern.

## Confirmed behavior

- `main` bleibt auf dem Upstream-Baseline-Commit.
- Eigene Entwicklung erfolgt auf `custom/live_streaming`.
- Custom-Features sind zentral konfigurierbar und standardmäßig deaktiviert.

## Non-goals

- Kein eigener Streaming-Provider
- Keine Änderung an `StreamingTranscriptionService`
- Keine Änderung bestehender Provider oder Registry
- Kein großes Refactoring, keine kosmetischen Upstream-Änderungen

## Affected paths

- Neue Custom-Datei unter `VoiceInk/Custom/Configuration/`
- Root-Dokumentation für Fork-Regeln und Änderungsinventar
- Bestehende VoiceInk-Laufzeitpfade: nicht geändert

## Verification

- Automated: `make check`, danach `./scripts/check`
- Manual/device: App-Start und Audio bleiben offen
- Regression paths: bestehender Upstream-Build und Standard-Transkriptionspfad

## Risks and rollback

- Risk: künftige Registry-/Protocol-Änderungen können Custom-Integrationspunkte
  berühren.
- Mitigation: Custom-Code isolieren, Integrationspunkte klein halten, Änderungen
  in `CUSTOM_CHANGES.md` dokumentieren.
- Rollback: Custom-Commit(s) auf dem Feature-Branch entfernen; `main` bleibt
  unabhängig und upstream-nah.
