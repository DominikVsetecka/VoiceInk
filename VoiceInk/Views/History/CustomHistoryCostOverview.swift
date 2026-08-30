import SwiftData
import SwiftUI

/// Fork-owned all-history overview for OpenAI Whisper v1 usage.
///
/// The view queries the complete history independently from the paginated list,
/// so the total is not limited by the currently loaded page or search filter.
struct CustomHistoryCostOverview: View {
    @Query(Self.allTranscriptionsDescriptor()) private var allTranscriptions: [Transcription]

    @AppStorage(CustomUsageCostConfiguration.isEnabledKey)
    private var isEnabled = CustomUsageCostConfiguration.defaultIsEnabled
    @AppStorage(CustomUsageCostConfiguration.currencyCodeKey)
    private var currencyCode = CustomUsageCostConfiguration.defaultCurrencyCode
    @AppStorage(CustomUsageCostConfiguration.usdToEURRateKey)
    private var usdToEURRate = CustomUsageCostConfiguration.defaultUSDToEURRate
    @AppStorage(CustomUsageCostConfiguration.openAIWhisperUSDPerMinuteKey)
    private var whisperRate = CustomUsageCostConfiguration.defaultOpenAIWhisperUSDPerMinute

    private static func allTranscriptionsDescriptor() -> FetchDescriptor<Transcription> {
        FetchDescriptor<Transcription>(
            sortBy: [SortDescriptor(\Transcription.timestamp, order: .reverse)]
        )
    }

    private var summary: CustomUsageCostSummary {
        // Keep the summary reactive when the user changes pricing settings.
        _ = currencyCode
        _ = usdToEURRate
        _ = whisperRate
        return CustomUsageCostCalculator.summary(for: allTranscriptions)
    }

    private var accessibilitySummary: String {
        String(
            format: String(localized: "Whisper v1 total: %.4f minutes, %@"),
            summary.totalMinutes,
            summary.formattedCost
        )
    }

    var body: some View {
        if CustomFeatureConfiguration.apiUsageCostEnabled, isEnabled {
            HStack(spacing: 10) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppTheme.Text.secondary)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Whisper v1 total")
                        .font(.system(size: 12, weight: .semibold))

                    Text(String(format: String(localized: "%.4f minutes processed"), summary.totalMinutes))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(AppTheme.Text.secondary)
                }

                Spacer(minLength: 8)

                VStack(alignment: .trailing, spacing: 2) {
                    Text(summary.formattedCost)
                        .font(.system(size: 13, weight: .semibold))

                    Text(currencyCode)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(AppTheme.Text.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                    .fill(AppTheme.Surface.subtle)
                    .overlay {
                        RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                            .strokeBorder(AppTheme.Border.tint, lineWidth: 1)
                    }
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilitySummary)
        }
    }
}
