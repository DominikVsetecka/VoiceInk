# ROADMAP — VoiceInk Personal Fork

## Orbit refs

- Project: `voiceink_fork`
- Current tickets: `ORB-0177`, `ORB-0178`
- Decisions: none

## Product direction

Langfristig soll der Fork eigene Transkriptions- und Kontextfunktionen erhalten,
während Updates aus `upstream/main` mit möglichst wenigen Konflikten übernommen
werden können.

## Current horizon

Ziel: stabile, dokumentierte Fork-Basis.

- Upstream-/Origin-Remotes und Branch-Policy
- Isolierter `VoiceInk/Custom/`-Bereich
- Zentrale, deaktivierte Feature-Konfiguration
- Reproduzierbarer Baseline-Build
- Optimierter lokaler Release-Build mit erhaltenem VoiceInk Refine
- Lokale API-Kostenschätzung für OpenAI Whisper in der History

Exit criteria:

- `main` zeigt auf einen Upstream-Baseline-Stand.
- Eigene Setup-Änderungen sind auf `custom/live_streaming` nachvollziehbar.
- Upstream-Funktion bleibt unverändert.

## Next horizon

Ziel: Kostenanzeige und Provider-Erweiterungen weiter belastbar machen.

- Historische Preis-Snapshots pro API-Nutzung untersuchen
- Danach eigenen Streaming-Provider als getrennten, kleinen Implementierungsblock
  über bestehende Protocols integrieren

## Later / explore

- Kontext-Injektion über bestehende Request-/Mode-Abstraktionen
- Provider-spezifische Konfiguration und Tests

## Explicit non-goals

- Keine parallele Streaming-Architektur
- Keine Änderung bestehender Provider ohne technische Notwendigkeit
- Keine automatische Übernahme oder Vermischung von Upstream-Commits
