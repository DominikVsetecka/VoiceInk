# Custom Changes

This fork is based on [Beingpax/VoiceInk](https://github.com/Beingpax/VoiceInk).
The upstream repository is configured as `upstream`; the personal fork is
configured as `origin`.

## Current custom features

- No runtime feature has been implemented yet.
- A central, disabled feature configuration exists as scaffolding for future
  fork-owned work.
- The first planned feature area is a custom streaming provider, using the
  existing `StreamingTranscriptionProvider` contract and shared streaming
  service.

## Fork-owned files

- `VoiceInk/Custom/Configuration/CustomFeatureConfiguration.swift` — central
  feature switches. Both switches default to `false` and are not integrated
  into runtime behavior yet.
- `Makefile` remains the local build entry point; its local target contains the
  minimal Xcode/package settings needed for this Apple-Silicon checkout.
- `scripts/check` — runs the prerequisite check and the normal VoiceInk build.
- `CUSTOM_CHANGES.md` — inventory and compatibility notes for this fork.
- Project-start operational documentation: `AGENTS.md`, `CLAUDE.md`,
  `TESTING.md`, `PROGRESS.md`, `PLAN.md`, and `ROADMAP.md`.

## Original VoiceInk files changed

- `Makefile` — adds the local Xcode package/macro validation switches and
  preserves `CRYPTO_IN_SWIFTPM` when enabling the local build condition. This
  is required because the current Xcode/SwiftPM combination otherwise tries to
  resolve unused `swift-crypto` BoringSSL modules on macOS.

The upstream VoiceInk source, project file, and existing providers remain
unchanged.

## Possible future conflict points

- Adding a custom provider to the runtime will likely require one small
  registration/injection point. That point must be documented here and kept
  separate from provider implementation code.
- If upstream changes `StreamingTranscriptionProvider`,
  `StreamingTranscriptionService`, `CloudProvider`, or
  `TranscriptionServiceRegistry`, the future custom integration must be
  reviewed against those protocol and registry changes.
- `VoiceInk/Custom/` is intentionally isolated so that upstream source updates
  can be merged with minimal conflict risk.
- An upstream change to the `Makefile` local build target may conflict with the
  small local build integration described above.

## Recommended future streaming architecture

1. Implement a new provider under `VoiceInk/Custom/Streaming/` conforming to
   `StreamingTranscriptionProvider`.
2. Reuse `StreamingTranscriptionService` for audio buffering, lifecycle,
   partial/committed events, finalization, cancellation, and batch fallback.
3. If provider metadata is needed, add a fork-owned adapter or dependency
   injection seam rather than changing existing providers.
4. Use `CloudProvider` only when the custom provider is a normal cloud model
   that fits the existing model registry. Otherwise, prefer a narrowly scoped
   provider factory/registry integration.
5. Keep `CustomFeatureConfiguration` as the single enable/disable boundary and
   preserve the existing path when it is disabled.

## Initial upstream baseline

- Upstream branch: `main`
- Initial upstream commit: `68b871e` (`Update appcast for VoiceInk 2.13`)
- Initial setup branch: `custom/live_streaming`
