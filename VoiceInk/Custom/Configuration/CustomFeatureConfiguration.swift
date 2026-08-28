import Foundation

/// Central switches for features that belong to this personal fork.
///
/// The defaults intentionally keep every custom feature disabled. This file is
/// scaffolding only; it does not alter VoiceInk behavior until a future,
/// explicit integration point reads one of these values.
enum CustomFeatureConfiguration {
    /// Master switch for fork-owned functionality.
    static let customFeaturesEnabled = false

    /// Reserved for a future custom streaming provider experiment.
    static let liveStreamingEnabled = false
}
