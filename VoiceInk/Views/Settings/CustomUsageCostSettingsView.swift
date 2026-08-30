import SwiftUI

struct CustomUsageCostSettingsView: View {
    @AppStorage(CustomUsageCostConfiguration.isEnabledKey)
    private var isEnabled = CustomUsageCostConfiguration.defaultIsEnabled
    @AppStorage(CustomUsageCostConfiguration.currencyCodeKey)
    private var currencyCode = CustomUsageCostConfiguration.defaultCurrencyCode
    @AppStorage(CustomUsageCostConfiguration.openAIWhisperUSDPerMinuteKey)
    private var openAIWhisperUSDPerMinute = CustomUsageCostConfiguration.defaultOpenAIWhisperUSDPerMinute
    @AppStorage(CustomUsageCostConfiguration.usdToEURRateKey)
    private var usdToEURRate = CustomUsageCostConfiguration.defaultUSDToEURRate

    var body: some View {
        Form {
            Section {
                Toggle("Show estimated API costs", isOn: $isEnabled)

                Picker("Display Currency", selection: $currencyCode) {
                    Text("USD").tag("USD")
                    Text("EUR").tag("EUR")
                }

                LabeledContent("Whisper v1 price") {
                    HStack(spacing: 6) {
                        TextField(
                            "0.006",
                            value: $openAIWhisperUSDPerMinute,
                            format: .number.precision(.fractionLength(3...6))
                        )
                        .multilineTextAlignment(.trailing)
                        .frame(width: 90)
                        Text("USD / min")
                            .foregroundStyle(.secondary)
                    }
                }

                if currencyCode == "EUR" {
                    LabeledContent("USD to EUR rate") {
                        TextField(
                            "0.92",
                            value: $usdToEURRate,
                            format: .number.precision(.fractionLength(2...4))
                        )
                        .multilineTextAlignment(.trailing)
                        .frame(width: 90)
                    }
                }
            } header: {
                Text("API Usage Costs")
            } footer: {
                Text("Costs are local estimates based on the recorded audio duration. Local transcription models are not charged.")
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
