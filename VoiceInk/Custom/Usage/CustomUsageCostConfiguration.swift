import Foundation

/// User-configurable pricing for fork-owned API usage estimates.
///
/// Values are deliberately kept outside VoiceInk's transcription model so that
/// pricing changes do not require changes to the upstream SwiftData schema.
enum CustomUsageCostConfiguration {
    static let isEnabledKey = "CustomUsageCostEnabled"
    static let currencyCodeKey = "CustomUsageCostCurrencyCode"
    static let usdToEURRateKey = "CustomUsageCostUSDToEURRate"
    static let openAIWhisperUSDPerMinuteKey = "CustomUsageCostOpenAIWhisperUSDPerMinute"

    static let defaultIsEnabled = true
    static let defaultCurrencyCode = "USD"
    static let defaultUSDToEURRate = 0.92
    static let defaultOpenAIWhisperUSDPerMinute = 0.006

    static var isEnabled: Bool {
        UserDefaults.standard.object(forKey: isEnabledKey) as? Bool ?? defaultIsEnabled
    }

    static var currencyCode: String {
        let value = UserDefaults.standard.string(forKey: currencyCodeKey) ?? defaultCurrencyCode
        return value == "EUR" ? "EUR" : "USD"
    }

    static var usdToEURRate: Double {
        let value = UserDefaults.standard.double(forKey: usdToEURRateKey)
        return value > 0 ? value : defaultUSDToEURRate
    }

    static var openAIWhisperUSDPerMinute: Double {
        let value = UserDefaults.standard.double(forKey: openAIWhisperUSDPerMinuteKey)
        return value > 0 ? value : defaultOpenAIWhisperUSDPerMinute
    }

    static func formattedCurrency(
        _ amount: Double,
        currencyCode: String = CustomUsageCostConfiguration.currencyCode
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = .current
        return formatter.string(from: NSNumber(value: amount)) ?? "\(currencyCode) \(amount)"
    }
}
