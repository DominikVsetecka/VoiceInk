# Custom Changes

This fork is based on [Beingpax/VoiceInk](https://github.com/Beingpax/VoiceInk).
The upstream repository is configured as `upstream`; the personal fork is
configured as `origin`.

## Current custom features

- OpenAI Whisper v1 is available as a cloud batch transcription model.
- When enabled, local Parakeet V3 provides the live preview and OpenAI remains
  authoritative for the final transcript after recording stops.
- It uses the existing `CloudProvider` contract and LLMkit's
  `OpenAITranscriptionClient`.
- It can be disabled through `CustomFeatureConfiguration.openAIWhisperEnabled`.
- Realtime streaming remains unchanged; `whisper-1` is batch-only.

## Fork-owned files

- `VoiceInk/Custom/Configuration/CustomFeatureConfiguration.swift` — central
  feature switches for fork-owned functionality.
- `VoiceInk/Custom/Providers/OpenAIWhisperProvider.swift` — OpenAI Whisper v1
  provider implementation.
- `VoiceInk/Custom/Streaming/OpenAIWhisperLocalPreviewProvider.swift` — local
  Parakeet V3 preview with OpenAI batch fallback.
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
- `VoiceInk/Models/TranscriptionModel.swift` — adds the `OpenAI` provider enum
  case required by the new cloud model.
- `VoiceInk/Transcription/Cloud/CloudProvider.swift` — adds the provider
  registry integration point and feature-flag boundary.
- `VoiceInk/Views/Onboarding/OnboardingCoordinator.swift` — places OpenAI in
  the cloud-provider selection order.
- `VoiceInk/Models/TranscriptionRealtimeSupport.swift` — exposes the hybrid
  preview as the existing per-mode realtime option.
- `VoiceInk/Shortcuts/RecordingShortcutManager.swift` — retries global shortcut
  registration after permission changes, app activation, wake, and display wake
  so a temporarily unavailable macOS event tap does not leave shortcuts inactive.

Existing VoiceInk services and providers remain unchanged. The listed files
contain only the minimal integration points required for the new provider.

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
- An upstream change to `ModelProvider`, `CloudProviderRegistry`, or the
  onboarding provider order may conflict with the corresponding small
  integrations above.
- An upstream change to realtime availability or session fallback behavior may
  affect the hybrid preview integration.
- An upstream change to shortcut lifecycle handling or `LifecycleObserver` may
  conflict with the small event-tap recovery integration above.

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
