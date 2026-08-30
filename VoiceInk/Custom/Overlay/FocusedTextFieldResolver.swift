import ApplicationServices
import AppKit

/// Resolves only the geometry of the currently focused editable UI element.
///
/// No text, selected range, key events, or control values are read. Accessibility
/// is used because it is the macOS API VoiceInk already relies on for cross-app
/// interaction and pasting.
enum CustomFocusedTextFieldResolver {
    static func resolve() -> CGRect? {
        guard CustomFeatureConfiguration.focusedTextFieldOverlayEnabled,
            CustomOverlayConfiguration.focusedTextFieldPlacementEnabled,
            AXIsProcessTrusted(),
            let frontmostApplication = NSWorkspace.shared.frontmostApplication,
            frontmostApplication.processIdentifier != ProcessInfo.processInfo.processIdentifier
        else {
            return nil
        }

        let applicationElement = AXUIElementCreateApplication(frontmostApplication.processIdentifier)
        guard let focusedElement = copyAXElementAttribute(
            kAXFocusedUIElementAttribute,
            from: applicationElement
        ) else {
            return nil
        }

        guard isEditable(focusedElement),
            let position = copyCGPointAttribute(kAXPositionAttribute, from: focusedElement),
            let size = copyCGSizeAttribute(kAXSizeAttribute, from: focusedElement),
            size.width > 0,
            size.height > 0
        else {
            return nil
        }

        return appKitFrame(fromAccessibilityFrame: CGRect(origin: position, size: size))
    }

    private static func isEditable(_ element: AXUIElement) -> Bool {
        let editableRoles: Set<String> = [
            kAXTextFieldRole as String,
            kAXTextAreaRole as String,
            kAXComboBoxRole as String,
        ]

        let role = copyStringAttribute(kAXRoleAttribute, from: element)
        let subrole = copyStringAttribute(kAXSubroleAttribute, from: element)
        let isEditable = copyBoolAttribute(kAXIsEditableAttribute, from: element) == true

        return editableRoles.contains(role ?? "")
            || subrole == (kAXSearchFieldSubrole as String)
            || isEditable
    }

    /// Accessibility uses a top-left global coordinate system while AppKit
    /// uses a bottom-left global coordinate system.
    private static func appKitFrame(fromAccessibilityFrame frame: CGRect) -> CGRect? {
        guard let globalMaxY = NSScreen.screens.map(\.frame.maxY).max() else {
            return nil
        }

        return CGRect(
            x: frame.origin.x,
            y: globalMaxY - frame.maxY,
            width: frame.width,
            height: frame.height
        )
    }

    private static func copyAXElementAttribute(
        _ attribute: String,
        from element: AXUIElement
    ) -> AXUIElement? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success,
            let value,
            CFGetTypeID(value) == AXUIElementGetTypeID()
        else {
            return nil
        }

        return unsafeBitCast(value, to: AXUIElement.self)
    }

    private static func copyStringAttribute(_ attribute: String, from element: AXUIElement) -> String? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success else {
            return nil
        }

        return value as? String
    }

    private static func copyBoolAttribute(_ attribute: String, from element: AXUIElement) -> Bool? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success else {
            return nil
        }

        return value as? Bool
    }

    private static func copyCGPointAttribute(_ attribute: String, from element: AXUIElement) -> CGPoint? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success,
            let value,
            CFGetTypeID(value) == AXValueGetTypeID(),
            AXValueGetType(value as! AXValue) == .cgPoint
        else {
            return nil
        }

        var point = CGPoint.zero
        guard AXValueGetValue(value as! AXValue, .cgPoint, &point) else {
            return nil
        }

        return point
    }

    private static func copyCGSizeAttribute(_ attribute: String, from element: AXUIElement) -> CGSize? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success,
            let value,
            CFGetTypeID(value) == AXValueGetTypeID(),
            AXValueGetType(value as! AXValue) == .cgSize
        else {
            return nil
        }

        var size = CGSize.zero
        guard AXValueGetValue(value as! AXValue, .cgSize, &size) else {
            return nil
        }

        return size
    }
}
