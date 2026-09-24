import SwiftData
import SwiftUI

/// Fork-owned all-history overview for transcription and enhancement API usage.
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
    @AppStorage(CustomUsageCostConfiguration.enhancementInputUSDPerMillionTokensKey)
    private var enhancementInputRate = CustomUsageCostConfiguration.defaultEnhancementInputUSDPerMillionTokens
    @AppStorage(CustomUsageCostConfiguration.enhancementOutputUSDPerMillionTokensKey)
    private var enhancementOutputRate = CustomUsageCostConfiguration.defaultEnhancementOutputUSDPerMillionTokens

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
        _ = enhancementInputRate
        _ = enhancementOutputRate
        return CustomUsageCostCalculator.summary(for: allTranscriptions)
    }

    private var accessibilitySummary: String {
        String(
            format: String(localized: "All API costs: %.4f minutes, %d enhancement tokens, %@"),
            summary.totalMinutes,
            summary.enhancementTokens,
            summary.formattedCost
        )
    }

    var body: some View {
        if CustomFeatureConfiguration.apiUsageCostEnabled, isEnabled {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(AppTheme.Text.secondary)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("All API costs")
                            .font(.system(size: 12, weight: .semibold))

                        Text(String(format: String(localized: "Whisper %.4f min · Enhancement %d tokens"), summary.totalMinutes, summary.enhancementTokens))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(AppTheme.Text.secondary)
                    }

                    Spacer(minLength: 8)

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(summary.formattedCost)
                            .font(.system(size: 13, weight: .semibold))

                        Text("Total · \(currencyCode)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(AppTheme.Text.secondary)
                    }
                }

                if !summary.rows.isEmpty {
                    Divider()
                    ForEach(summary.rows) { row in
                        HStack(spacing: 8) {
                            Text(row.displayName)
                                .lineLimit(1)
                            Spacer(minLength: 8)
                            Text(CustomUsageCostCalculator.formattedUSD(row.costUSD))
                                .fontWeight(.medium)
                        }
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(AppTheme.Text.secondary)
                    }
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
