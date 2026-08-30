import AVFoundation
import ApplicationServices
import AppKit
import SwiftUI

struct PermissionsSettingsView: View {
    @State private var statuses: [OnboardingPermissionKind: OnboardingPermissionStatus] = [:]
    @State private var isRequestingScreenRecording = false

    var body: some View {
        Form {
            Section {
                Text(
                    "Manage and recheck the macOS permissions VoiceInk needs. Changes made in System Settings are reflected when you return to VoiceInk."
                )
                .settingsDescription()

                ForEach(OnboardingPermissionKind.allCases) { permission in
                    permissionRow(for: permission)
                }
            } header: {
                HStack {
                    Text("VoiceInk Permissions")
                    Spacer()
                    Button {
                        refreshStatuses()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .buttonStyle(.plain)
                    .help("Refresh permission status")
                }
            } footer: {
                Text(
                    "Accessibility is required for the global recording shortcut and for pasting text into other apps. Screen Recording is optional and is only needed for context-aware features."
                )
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .onAppear {
            refreshStatuses()
        }
        .onReceive(
            LifecycleObserver.shared.publisher(for: .applicationDidBecomeActive)
        ) { _ in
            refreshStatuses()
        }
    }

    @ViewBuilder
    private func permissionRow(for permission: OnboardingPermissionKind) -> some View {
        let status = statuses[permission] ?? .unknown

        HStack(spacing: 12) {
            Image(systemName: status.isGranted ? "checkmark.circle.fill" : "exclamationmark.circle")
                .foregroundColor(status.isGranted ? AppTheme.Status.positive : statusColor(for: status))
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(LocalizedStringKey(permission.descriptor.title))
                        .font(.system(size: 13, weight: .semibold))

                    if permission.isRequired {
                        Text("Required")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }

                Text(LocalizedStringKey(status.label))
                    .font(.system(size: 11))
                    .foregroundColor(statusColor(for: status))
            }

            Spacer(minLength: 8)

            Button(actionTitle(for: permission, status: status)) {
                performAction(for: permission)
            }
            .controlSize(.small)
            .disabled(permission == .screenRecording && isRequestingScreenRecording)
        }
    }

    private func actionTitle(
        for permission: OnboardingPermissionKind,
        status: OnboardingPermissionStatus
    ) -> String {
        if status.isGranted {
            return "Open System Settings"
        }

        if permission == .microphone && status == .needsAccess {
            return "Allow"
        }

        return "Open System Settings"
    }

    private func performAction(for permission: OnboardingPermissionKind) {
        switch permission {
        case .microphone:
            if AVCaptureDevice.authorizationStatus(for: .audio) == .notDetermined {
                AVCaptureDevice.requestAccess(for: .audio) { _ in
                    DispatchQueue.main.async {
                        refreshStatuses()
                    }
                }
            } else {
                openSystemSettings(for: permission)
            }

        case .accessibility:
            let options: NSDictionary = [
                kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true
            ]
            AXIsProcessTrustedWithOptions(options)
            openSystemSettings(for: permission)

        case .screenRecording:
            isRequestingScreenRecording = true
            Task { @MainActor in
                let isGranted = await ScreenCaptureService.requestScreenCapturePermissionRegistration()
                isRequestingScreenRecording = false
                refreshStatuses()

                if !isGranted {
                    openSystemSettings(for: permission)
                }
            }
        }
    }

    private func refreshStatuses() {
        statuses = Dictionary(
            uniqueKeysWithValues: OnboardingPermissionKind.allCases.map { permission in
                (permission, diagnose(permission))
            }
        )
    }

    private func diagnose(_ permission: OnboardingPermissionKind) -> OnboardingPermissionStatus {
        switch permission {
        case .microphone:
            switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized:
                return .granted
            case .denied:
                return .denied
            case .restricted:
                return .restricted
            case .notDetermined:
                return .needsAccess
            @unknown default:
                return .unknown
            }

        case .accessibility:
            return AXIsProcessTrusted() ? .granted : .needsAccess

        case .screenRecording:
            return CGPreflightScreenCaptureAccess() ? .granted : .needsAccess
        }
    }

    private func openSystemSettings(for permission: OnboardingPermissionKind) {
        guard let url = URL(string: settingsPane(for: permission).urlString) else { return }
        NSWorkspace.shared.open(url)
    }

    private func settingsPane(for permission: OnboardingPermissionKind) -> PrivacySettingsPane {
        switch permission {
        case .microphone:
            return .microphone
        case .accessibility:
            return .accessibility
        case .screenRecording:
            return .screenRecording
        }
    }

    private func statusColor(for status: OnboardingPermissionStatus) -> Color {
        switch status {
        case .denied, .restricted:
            return AppTheme.Status.error
        case .granted:
            return AppTheme.Status.positive
        case .needsAccess, .unknown:
            return .secondary
        }
    }
}
