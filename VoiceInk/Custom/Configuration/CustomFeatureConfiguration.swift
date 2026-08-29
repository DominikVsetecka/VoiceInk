import Foundation

/// Central switches for features that belong to this personal fork.
///
/// Custom features are enabled explicitly here and remain isolated from the
/// existing VoiceInk providers and services.
enum CustomFeatureConfiguration {
    /// Master switch for fork-owned functionality.
    static let customFeaturesEnabled = true

    /// Enables the OpenAI Whisper v1 cloud model.
    static let openAIWhisperEnabled = true

    /// Uses local Parakeet V3 for the live preview while OpenAI remains final.
    static let openAIWhisperLocalPreviewEnabled = true

    /// Reserved for a future custom streaming provider experiment.
    static let liveStreamingEnabled = false
}
