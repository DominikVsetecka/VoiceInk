import Foundation

/// User-facing settings for the fork-owned recorder overlay placement.
///
/// The setting is kept in UserDefaults so it can be changed without touching
/// VoiceInk's recorder state or SwiftData models.
enum CustomOverlayConfiguration {
    static let focusedTextFieldPlacementKey = "CustomFocusedTextFieldOverlayPlacement"
    static let defaultFocusedTextFieldPlacement = false

    static var focusedTextFieldPlacementEnabled: Bool {
        UserDefaults.standard.object(forKey: focusedTextFieldPlacementKey) as? Bool
            ?? defaultFocusedTextFieldPlacement
    }
}
