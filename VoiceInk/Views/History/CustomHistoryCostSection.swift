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

                VStack(spacing: 8) {
                    ForEach(summary.rows) { row in
                        HStack {
                            Text(row.modelName)
                            Spacer()
                            Text(String(format: String(localized: "%.1f min"), row.minutes))
                                .foregroundStyle(AppTheme.Text.secondary)
                            Text(
                                CustomUsageCostConfiguration.formattedCurrency(
                                    row.costUSD * (summary.currencyCode == "EUR" ? CustomUsageCostConfiguration.usdToEURRate : 1),
                                    currencyCode: summary.currencyCode
                                )
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
