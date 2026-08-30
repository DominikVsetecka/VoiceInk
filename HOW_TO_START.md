# VoiceInk Fork starten und selbst bauen

Diese Anleitung beschreibt den lokalen Build des persönlichen VoiceInk-Forks
für Apple-Silicon-Macs.

Repository: <https://github.com/DominikVsetecka/VoiceInk>

## Voraussetzungen

- macOS auf einem Apple-Silicon-Mac
- Xcode aus dem Mac App Store, einmal geöffnet und akzeptiert
- Git
- Swift und `xcodebuild` (normalerweise mit Xcode vorhanden)
- CMake, falls das Whisper-Framework lokal neu gebaut werden muss

Optional kann CMake mit Homebrew installiert werden:

```bash
brew install cmake
```

## Repository klonen

```bash
git clone --branch custom/live_streaming \
  https://github.com/DominikVsetecka/VoiceInk.git VoiceInk
cd VoiceInk
git remote add upstream https://github.com/Beingpax/VoiceInk.git
git fetch upstream
```

Die Remotes haben diese Bedeutung:

- `origin` — dein persönlicher Fork
- `upstream` — das originale VoiceInk-Repository

Die eigene Entwicklung findet auf `custom/live_streaming` statt. `main` bleibt
möglichst nah an `upstream/main`.

## Release-Build für die lokale Nutzung

Im Repository ausführen:

```bash
make local-release
```

Der Befehl:

1. prüft die Build-Voraussetzungen,
2. verwendet oder baut das lokale Whisper-Framework,
3. baut VoiceInk als optimierte Release-App,
4. überspringt die nicht benötigte `mlx-swift`-Pluginvalidierung für diesen
   lokalen macOS-Build,
5. signiert die eingebetteten Frameworks und XPC-Komponenten konsistent,
6. kopiert das Ergebnis nach `~/Downloads/VoiceInk.app`.

Der Signaturschritt ist wichtig: Ohne ihn kann macOS beim Start von
`whisper.framework` einen Team-ID-Konflikt melden und die App direkt wieder
beenden.

## App installieren

Nach einem erfolgreichen Build die App nach `/Applications` kopieren. Wenn dort
bereits eine alte Version liegt, muss sie zuerst ersetzt werden:

```bash
rm -rf /Applications/VoiceInk.app
ditto "$HOME/Downloads/VoiceInk.app" /Applications/VoiceInk.app
xattr -cr /Applications/VoiceInk.app
```

Danach starten:

```bash
open /Applications/VoiceInk.app
```

Alternativ kann `VoiceInk.app` im Finder aus `Downloads` nach `Applications`
gezogen und dort ersetzt werden.

## Erster Start und macOS-Rechte

Je nach verwendeten Funktionen können diese Rechte erforderlich sein:

- Mikrofon — Audioaufnahme
- Bedienungshilfen — globaler Hotkey und App-Steuerung
- Automation — Interaktion mit Chrome oder anderen Browsern
- Bildschirmaufnahme — optionale Kontextfunktionen

Die Rechte können später in den VoiceInk-Einstellungen über den
Berechtigungsbereich geprüft und erneut geöffnet werden. Der komplette
Onboarding-Prozess muss dafür nicht erneut gestartet werden.

## OpenAI und lokale Modelle

Der OpenAI-API-Key wird in VoiceInk zur Laufzeit eingegeben und über den
macOS-Schlüsselbund verwaltet. Er gehört nicht in dieses Repository, in eine
`README.md` oder in eine `.env`-Datei.

`whisper-1` ist die cloudbasierte Batch-Transkription für das endgültige
Ergebnis. Für eine optionale Live-Vorschau kann lokal Parakeet V3 verwendet
werden. Die bestehende VoiceInk-Streaming-Architektur bleibt dabei erhalten.

## App aktualisieren

Nach Änderungen am Fork erneut bauen und installieren:

```bash
make local-release
rm -rf /Applications/VoiceInk.app
ditto "$HOME/Downloads/VoiceInk.app" /Applications/VoiceInk.app
xattr -cr /Applications/VoiceInk.app
open /Applications/VoiceInk.app
```

`make local-release` ist der empfohlene Weg. Ein direkt aus Xcode kopiertes
Bundle kann bei den eingebetteten Frameworks die notwendige lokale
Nachsignierung nicht enthalten.

## Änderungen aus dem Original übernehmen

Upstream abrufen:

```bash
git fetch upstream
```

Den eigenen `main`-Branch aktualisieren:

```bash
git switch main
git merge --ff-only upstream/main
git push origin main
```

Danach kann die eigene Entwicklung auf `custom/live_streaming` gegen den neuen
Stand geprüft und bei Bedarf aktualisiert werden. Eigene Dateien liegen
bevorzugt unter `VoiceInk/Custom/`, damit zukünftige Upstream-Updates möglichst
wenige Konflikte erzeugen.

## Dokumentation im Fork

- `CUSTOM_CHANGES.md` — eigene Features, Integrationspunkte und Konfliktrisiken
- `AGENTS.md` und `CLAUDE.md` — Arbeitsregeln für dieses Projekt
- `TESTING.md` — Test- und Build-Hinweise
- `ROADMAP.md` — geplante Weiterentwicklung
