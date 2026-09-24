# Changelog

## Unreleased

- Upstream `v2.20` und die nachfolgenden `upstream/main`-Änderungen bis
  `d7b528a` per nachvollziehbarem Merge integriert.
- Dictionary Auto Learn sowie Import/Export, Quick History, Mouse Shortcuts,
  OpenRouter-Verbesserungen, neue Provider/Modelle und französische
  Lokalisierung übernommen.
- Fork-eigene API-Kosten, OpenAI-Whisper-v1, hybride Vorschau, Hotkey-Recovery,
  Dashboard-Insights, Overlay und Refine/XPC-Lokalbuild erhalten.

- API-Kostentransparenz für Enhancement ergänzt: Transkription und Enhancement
  werden getrennt sowie als Gesamtsumme angezeigt.
- Kostenaufschlüsselung um Provider, Modell sowie geschätzte Input-/Output-Tokens
  erweitert – pro History-Eintrag, in den Details und in beiden History-Übersichten.
- Editierbare Input-/Output-Preise für Enhancement in den API-Costs-Settings ergänzt.
- Lokalen Build-Start mit `scripts/project-start-check`, stabiler lokaler
  Signierung und dokumentiertem `make local-release` abgesichert.

Die Produktversion folgt jetzt dem Upstream-Stand `2.20`; der Fork enthält
zusätzlich spätere `upstream/main`-Commits bis `d7b528a`.
