# Project Agent Instructions

Diese Datei ist die kanonische Arbeits- und Dokumentationsregel für den
persönlichen VoiceInk-Fork.

## Projektkontext

- Project ID: not configured (kein Orbit-Projekt angelegt)
- Project root: `/Users/dominikvsetecka/Documents/Projekte/voiceink_fork`
- Purpose: Persönlicher, langfristig wartbarer VoiceInk-Fork mit isolierten eigenen Erweiterungen.
- Stack: native macOS-App, Swift, Xcode, SwiftData, Swift Package Manager
- Active Orbit tickets: none
- Decisions: none
- Default branch: `main`
- Remote: `origin=https://github.com/DominikVsetecka/VoiceInk.git`, `upstream=https://github.com/Beingpax/VoiceInk.git`
- Working branch policy: eigene Features auf `custom/*`; `main` bleibt möglichst nah an `upstream/main`.
- Push policy: nach erfolgreicher Prüfung und explizitem Auftrag beziehungsweise im Rahmen des Fork-Setups.
- Deploy policy: not configured; kein Deployment in diesem Arbeitsschritt.
- Protected paths/projects: Upstream-Implementierung und bestehende Provider möglichst unverändert lassen.

## Scope und Invarianten

- Fork-eigene Funktionalität lebt bevorzugt unter `VoiceInk/Custom/`.
- Bestehende VoiceInk-Protocols, Services und Registry-Mechanismen werden
  wiederverwendet.
- Bestehendes Verhalten bleibt bei deaktivierten Custom-Features unverändert.
- Keine kosmetischen Änderungen, großen Refactorings oder Provider-Umbauten.
- Vor jeder größeren Implementierung werden neue Dateien und notwendige
  Änderungen an bestehenden VoiceInk-Dateien ausgewiesen.

## Vor jeder Änderung

1. Branch und `git status` prüfen.
2. Vorhandene uncommittete Änderungen als User-Arbeit behandeln.
3. Betroffene Implementierung und Tests lesen.
4. Prüfen, ob eine neue Datei, Extension, Protocol-Implementierung oder
   Dependency-Injection-Stelle genügt.
5. Nach der Änderung den vollständigen Diff und die Build-Warnungen prüfen.

## Git-Workflow

- `main` ist der Upstream-nahe Integrationsstand.
- Eigene Entwicklung erfolgt auf `custom/live_streaming` oder späteren
  `custom/*`-Branches.
- Commits bleiben klein und logisch getrennt; kein Mischcommit mehrerer großer
  Features.
- Keine destruktiven Git-Befehle ohne ausdrückliche Freigabe.
- `Committed`, `Pushed`, `Merged`, `Build passed` und reale Abnahme werden im
  Bericht getrennt ausgewiesen.

## Dokumentation

- `README.md`: Upstream-Projektbeschreibung und Build-Einstieg
- `CUSTOM_CHANGES.md`: Fork-eigene Dateien, Integrationspunkte und Konfliktrisiken
- `TESTING.md`: tatsächliche Prüfkommandos und offene manuelle Abnahme
- `PROGRESS.md`: verifizierter Iststand und Chronologie
- `PLAN.md`: aktiver Setup-/Architekturblock
- `ROADMAP.md`: langfristige Richtung

Keine Secrets, lokalen Schlüssel, produktiven Daten oder Build-Artefakte
committen. Orbit ist für diesen Fork derzeit `not configured` und wird nicht
ohne bestätigte Projektidentität angelegt.
