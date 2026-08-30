# Start and Build the VoiceInk Fork

This guide describes how to build and run the personal VoiceInk fork locally
on an Apple Silicon Mac.

Repository: <https://github.com/DominikVsetecka/VoiceInk>

## Requirements

- macOS on an Apple Silicon Mac
- Xcode from the Mac App Store, opened once and accepted
- Git
- Swift and `xcodebuild` (normally included with Xcode)
- CMake, if the Whisper framework needs to be rebuilt locally

CMake can optionally be installed with Homebrew:

```bash
brew install cmake
```

## Clone the repository

```bash
git clone --branch custom/live_streaming \
  https://github.com/DominikVsetecka/VoiceInk.git VoiceInk
cd VoiceInk
git remote add upstream https://github.com/Beingpax/VoiceInk.git
git fetch upstream
```

The remotes have these roles:

- `origin` — your personal fork
- `upstream` — the original VoiceInk repository

Personal development happens on `custom/live_streaming`. The `main` branch is
kept as close as possible to `upstream/main`.

## Build a local release

Run this from the repository directory:

```bash
make local-release
```

This command:

1. checks the build prerequisites,
2. uses or builds the local Whisper framework,
3. builds VoiceInk as an optimized release app,
4. skips the unnecessary `mlx-swift` plugin validation for this local macOS
   build,
5. signs the embedded frameworks and XPC components consistently, and
6. copies the result to `~/Downloads/VoiceInk.app`.

The signing step is important. Without it, macOS may report a Team ID conflict
when loading `whisper.framework` and terminate the app immediately.

## Install the app

After a successful build, copy the app to `/Applications`. If an older version
is already installed, replace it first:

```bash
rm -rf /Applications/VoiceInk.app
ditto "$HOME/Downloads/VoiceInk.app" /Applications/VoiceInk.app
xattr -cr /Applications/VoiceInk.app
```

Then launch it:

```bash
open /Applications/VoiceInk.app
```

Alternatively, drag `VoiceInk.app` from `Downloads` to `Applications` in
Finder and confirm the replacement.

## First launch and macOS permissions

Depending on the features you use, VoiceInk may require:

- Microphone — audio recording
- Accessibility — global hotkeys and app-wide controls
- Automation — interaction with Chrome or other browsers
- Screen Recording — optional context features

You can check and reopen these permissions later from the permissions section
in VoiceInk Settings. You do not need to restart the complete onboarding flow.

## OpenAI and local models

The OpenAI API key is entered at runtime and stored through the macOS Keychain.
It must not be committed to this repository, added to `README.md`, or stored in
an `.env` file.

`whisper-1` is the cloud-based batch transcription model used for the final
transcript. Parakeet V3 can optionally provide a local live preview while you
are speaking. The existing VoiceInk streaming architecture remains in use.

## Update the app after changes

After making changes to the fork, build and install it again:

```bash
make local-release
rm -rf /Applications/VoiceInk.app
ditto "$HOME/Downloads/VoiceInk.app" /Applications/VoiceInk.app
xattr -cr /Applications/VoiceInk.app
open /Applications/VoiceInk.app
```

`make local-release` is the recommended workflow. Copying a raw app bundle
directly from Xcode may omit the local re-signing step required by the embedded
frameworks.

## Bring changes in from the original repository

Fetch the latest upstream state:

```bash
git fetch upstream
```

Update your local `main` branch:

```bash
git switch main
git merge --ff-only upstream/main
git push origin main
```

Then review `custom/live_streaming` against the updated upstream base. Fork
files should preferably live under `VoiceInk/Custom/` so future upstream
updates create as few conflicts as possible.

## Fork documentation

- `CUSTOM_CHANGES.md` — custom features, integration points, and conflict risks
- `AGENTS.md` and `CLAUDE.md` — project working rules
- `TESTING.md` — testing and build notes
- `ROADMAP.md` — planned development
