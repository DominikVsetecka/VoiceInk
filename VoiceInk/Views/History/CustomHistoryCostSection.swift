import SwiftUI

struct CustomHistoryCostSection: View {
    let summary: CustomUsageCostSummary

    var body: some View {
        if CustomFeatureConfiguration.apiUsageCostEnabled,
            CustomUsageCostConfiguration.isEnabled,
            !summary.rows.isEmpty
        {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Estimated API Cost")
                        .font(.headline.weight(.semibold))

                    Spacer()

                    Text(summary.formattedCost)
                        .font(.headline.weight(.semibold))
                }

                HStack(spacing: 12) {
                    Label(
                        String(format: String(localized: "%.1f minutes"), summary.totalMinutes),
                        systemImage: "waveform"
                    )
                    .foregroundStyle(AppTheme.Text.secondary)

                    Text("Estimated")
                        .foregroundStyle(AppTheme.Text.secondary)
                }
                .font(.system(size: 12, weight: .medium))

                HStack(spacing: 12) {
                    Text("Whisper: \(summary.formattedTranscriptionCost)")
                    Text("Enhancement: \(summary.formattedEnhancementCost)")
                    Spacer()
                    Text("\(summary.enhancementTokens.formatted()) tokens")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(AppTheme.Text.secondary)

                VStack(spacing: 8) {
                    ForEach(summary.rows) { row in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(row.displayName)
                                Text(row.kind == .transcription ? "Transcription API" : "Enhancement API")
                                    .font(.system(size: 10, weight: .regular))
                                    .foregroundStyle(AppTheme.Text.secondary)
                            }
                            Spacer()
                            if row.kind == .transcription {
                                Text(String(format: String(localized: "%.1f min"), row.minutes))
                                    .foregroundStyle(AppTheme.Text.secondary)
                            } else {
                                Text("\(row.tokens.formatted()) tokens")
                                    .foregroundStyle(AppTheme.Text.secondary)
                            }
                            Text(
                                CustomUsageCostCalculator.formattedUSD(row.costUSD)
                            )
                            .frame(minWidth: 58, alignment: .trailing)
                        }
                        .font(.system(size: 12, weight: .medium))
                    }
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                    .fill(AppTheme.Surface.subtle)
                    .overlay {
                        RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                            .strokeBorder(AppTheme.Border.tint, lineWidth: 1)
                    }
            )
        }
    }
}
