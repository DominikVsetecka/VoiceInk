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
    @AppStorage(CustomUsageCostConfiguration.enhancementInputUSDPerMillionTokensKey)
    private var enhancementInputUSDPerMillionTokens = CustomUsageCostConfiguration.defaultEnhancementInputUSDPerMillionTokens
    @AppStorage(CustomUsageCostConfiguration.enhancementOutputUSDPerMillionTokensKey)
    private var enhancementOutputUSDPerMillionTokens = CustomUsageCostConfiguration.defaultEnhancementOutputUSDPerMillionTokens

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

                LabeledContent("Enhancement input price") {
                    HStack(spacing: 6) {
                        TextField("0.15", value: $enhancementInputUSDPerMillionTokens, format: .number.precision(.fractionLength(3...6)))
                            .multilineTextAlignment(.trailing)
                            .frame(width: 90)
                        Text("USD / 1M tokens")
                            .foregroundStyle(.secondary)
                    }
                }

                LabeledContent("Enhancement output price") {
                    HStack(spacing: 6) {
                        TextField("0.60", value: $enhancementOutputUSDPerMillionTokens, format: .number.precision(.fractionLength(3...6)))
                            .multilineTextAlignment(.trailing)
                            .frame(width: 90)
                        Text("USD / 1M tokens")
                            .foregroundStyle(.secondary)
                    }
                }

            } header: {
                Text("API Usage Costs")
            } footer: {
                Text("Costs are local estimates. Whisper uses audio minutes; API enhancements use estimated input and output tokens. Local models are not charged.")
            }

            if currencyCode == "EUR" {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Exchange rate")
                                .font(.headline)
                            Text("Enter how many euros equal 1 US dollar.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        HStack(spacing: 8) {
                            Text("1 USD")
                                .font(.system(size: 13, weight: .medium))

                            Image(systemName: "equal")
                                .foregroundStyle(.secondary)

                            TextField(
                                "0.92",
                                value: $usdToEURRate,
                                format: .number.precision(.fractionLength(2...4))
                            )
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 90)

                            Text("EUR")
                                .font(.system(size: 13, weight: .medium))

                            Spacer()

                            Button("Reset") {
                                usdToEURRate = CustomUsageCostConfiguration.defaultUSDToEURRate
                            }
                            .buttonStyle(.link)
                        }

                        Divider()

                        HStack {
                            Text("Example for 10 minutes")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(
                                CustomUsageCostConfiguration.formattedCurrency(
                                    10 * openAIWhisperUSDPerMinute * usdToEURRate,
                                    currencyCode: "EUR"
                                )
                            )
                            .fontWeight(.medium)
                        }
                        .font(.system(size: 12))
                    }
                } header: {
                    Text("Currency Conversion")
                } footer: {
                    Text("This fixed rate is only used to display an approximate EUR value. OpenAI bills in USD.")
                }
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
