import AppKit

/// Calculates a stable recorder-panel position near a focused text field.
///
/// The panel is positioned once when it is shown. If the focused element cannot
/// be resolved, or if the setting is disabled, the caller's existing frame is
/// returned unchanged.
enum CustomFocusedOverlayPlacement {
    private static let spacing: CGFloat = 12
    private static let screenInset: CGFloat = 8

    static func frame(
        defaultFrame: NSRect,
        focusedTextFieldFrame: CGRect?
    ) -> NSRect {
        guard CustomFeatureConfiguration.focusedTextFieldOverlayEnabled,
            CustomOverlayConfiguration.focusedTextFieldPlacementEnabled,
            let focusedTextFieldFrame,
            focusedTextFieldFrame.width > 0,
            focusedTextFieldFrame.height > 0,
            let screen = screen(containing: focusedTextFieldFrame)
        else {
            return defaultFrame
        }

        let visibleFrame = screen.visibleFrame.insetBy(dx: screenInset, dy: screenInset)
        let target = NSRect(
            x: focusedTextFieldFrame.origin.x,
            y: focusedTextFieldFrame.origin.y,
            width: focusedTextFieldFrame.width,
            height: focusedTextFieldFrame.height
        )

        let candidates = [
            NSRect(
                x: target.maxX + spacing,
                y: target.midY - defaultFrame.height / 2,
                width: defaultFrame.width,
                height: defaultFrame.height
            ),
            NSRect(
                x: target.minX - defaultFrame.width - spacing,
                y: target.midY - defaultFrame.height / 2,
                width: defaultFrame.width,
                height: defaultFrame.height
            ),
            NSRect(
                x: target.midX - defaultFrame.width / 2,
                y: target.maxY + spacing,
                width: defaultFrame.width,
                height: defaultFrame.height
            ),
            NSRect(
                x: target.midX - defaultFrame.width / 2,
                y: target.minY - defaultFrame.height - spacing,
                width: defaultFrame.width,
                height: defaultFrame.height
            ),
        ]

        let candidate = candidates.first(where: { visibleFrame.contains($0) })
            ?? candidates.first
            ?? defaultFrame

        return clamped(candidate, to: visibleFrame)
    }

    private static func screen(containing frame: CGRect) -> NSScreen? {
        let center = NSPoint(x: frame.midX, y: frame.midY)
        return NSScreen.screens.first(where: { $0.frame.contains(center) })
            ?? NSScreen.screens.first(where: { $0.frame.intersects(frame) })
    }

    private static func clamped(_ frame: NSRect, to bounds: NSRect) -> NSRect {
        let maximumX = max(bounds.minX, bounds.maxX - frame.width)
        let maximumY = max(bounds.minY, bounds.maxY - frame.height)

        return NSRect(
            x: min(max(frame.minX, bounds.minX), maximumX),
            y: min(max(frame.minY, bounds.minY), maximumY),
            width: frame.width,
            height: frame.height
        )
    }
}
