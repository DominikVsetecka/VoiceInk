import SwiftUI

struct FocusedOverlaySettingsView: View {
    @AppStorage(CustomOverlayConfiguration.focusedTextFieldPlacementKey)
    private var focusedTextFieldPlacementEnabled = CustomOverlayConfiguration.defaultFocusedTextFieldPlacement

    var body: some View {
        Form {
            Section {
                Toggle(
                    "Place recorder overlay near focused text field",
                    isOn: $focusedTextFieldPlacementEnabled
                )

                Text(
                    "When recording starts, VoiceInk places the existing recorder overlay near the focused input field. If an app does not expose its field position, the normal overlay position is used."
                )
                .settingsDescription()
            } header: {
                Text("Recorder Overlay")
            } footer: {
                Text(
                    "VoiceInk reads only the focused field's position and size through macOS Accessibility. It does not read the field's text or keyboard input."
                )
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
    }
}
