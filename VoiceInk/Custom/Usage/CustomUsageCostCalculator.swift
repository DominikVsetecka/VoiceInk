import Foundation

struct CustomUsageCostRow: Identifiable {
    let modelName: String
    let minutes: Double
    let costUSD: Double

    var id: String { modelName }
}

struct CustomUsageCostSummary {
    let totalMinutes: Double
    let estimatedCostUSD: Double
    let rows: [CustomUsageCostRow]

    var estimatedCost: Double {
        if CustomUsageCostConfiguration.currencyCode == "EUR" {
            return estimatedCostUSD * CustomUsageCostConfiguration.usdToEURRate
        }
        return estimatedCostUSD
    }

    var currencyCode: String {
        CustomUsageCostConfiguration.currencyCode
    }

    var formattedCost: String {
        CustomUsageCostConfiguration.formattedCurrency(estimatedCost, currencyCode: currencyCode)
    }
}

enum CustomUsageCostCalculator {
    static func summary(for transcriptions: [Transcription]) -> CustomUsageCostSummary {
        guard CustomFeatureConfiguration.apiUsageCostEnabled,
            CustomUsageCostConfiguration.isEnabled
        else {
            return CustomUsageCostSummary(totalMinutes: 0, estimatedCostUSD: 0, rows: [])
        }

        var minutesByModel: [String: Double] = [:]
        var costByModel: [String: Double] = [:]

        for transcription in transcriptions {
            guard isCompleted(transcription),
                let modelName = billableModelName(from: transcription.transcriptionModelName),
                transcription.duration > 0
            else { continue }

            let minutes = transcription.duration / 60
            let costUSD = minutes * ratePerMinute(for: modelName)
            minutesByModel[modelName, default: 0] += minutes
            costByModel[modelName, default: 0] += costUSD
        }

        let rows = minutesByModel.map { modelName, minutes in
            CustomUsageCostRow(
                modelName: modelName,
                minutes: minutes,
                costUSD: costByModel[modelName, default: 0]
            )
        }
        .sorted { $0.minutes > $1.minutes }

        return CustomUsageCostSummary(
            totalMinutes: rows.reduce(0) { $0 + $1.minutes },
            estimatedCostUSD: rows.reduce(0) { $0 + $1.costUSD },
            rows: rows
        )
    }

    static func cost(for transcription: Transcription) -> Double? {
        guard CustomFeatureConfiguration.apiUsageCostEnabled,
            CustomUsageCostConfiguration.isEnabled,
            isCompleted(transcription),
            let modelName = billableModelName(from: transcription.transcriptionModelName),
            transcription.duration > 0
        else { return nil }

        return transcription.duration / 60 * ratePerMinute(for: modelName)
    }

    static func formattedCost(for transcription: Transcription) -> String? {
        guard let costUSD = cost(for: transcription) else { return nil }

        let cost = CustomUsageCostConfiguration.currencyCode == "EUR"
            ? costUSD * CustomUsageCostConfiguration.usdToEURRate
            : costUSD
        return CustomUsageCostConfiguration.formattedCurrency(
            cost,
            currencyCode: CustomUsageCostConfiguration.currencyCode
        )
    }

    private static func ratePerMinute(for modelName: String) -> Double {
        switch modelName {
        case "Whisper v1":
            return CustomUsageCostConfiguration.openAIWhisperUSDPerMinute
        default:
            return 0
        }
    }

    private static func billableModelName(from name: String?) -> String? {
        guard let name else { return nil }
        let normalized = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        switch normalized {
        case "whisper v1", "whisper-1":
            return "Whisper v1"
        default:
            return nil
        }
    }

    private static func isCompleted(_ transcription: Transcription) -> Bool {
        transcription.transcriptionStatus == nil
            || transcription.transcriptionStatus == TranscriptionStatus.completed.rawValue
    }
}
