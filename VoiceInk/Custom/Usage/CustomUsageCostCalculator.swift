import Foundation

enum CustomUsageCostKind: String {
    case transcription = "Transcription"
    case enhancement = "Enhancement"
}

struct CustomUsageCostRow: Identifiable {
    let kind: CustomUsageCostKind
    let providerName: String?
    let modelName: String
    let minutes: Double
    let tokens: Int
    let costUSD: Double

    var id: String {
        "\(kind.rawValue)-\(providerName ?? "")-\(modelName)"
    }

    var displayName: String {
        if let providerName, !providerName.isEmpty {
            return "\(providerName) / \(modelName)"
        }
        return modelName
    }
}

struct CustomUsageCostBreakdown {
    let transcriptionCostUSD: Double
    let enhancementCostUSD: Double

    var totalCostUSD: Double { transcriptionCostUSD + enhancementCostUSD }
}

struct CustomUsageCostSummary {
    let totalMinutes: Double
    let enhancementTokens: Int
    let transcriptionCostUSD: Double
    let enhancementCostUSD: Double
    let rows: [CustomUsageCostRow]

    var estimatedCostUSD: Double { transcriptionCostUSD + enhancementCostUSD }

    var estimatedCost: Double {
        CustomUsageCostCalculator.convertToDisplayCurrency(estimatedCostUSD)
    }

    var currencyCode: String {
        CustomUsageCostConfiguration.currencyCode
    }

    var formattedCost: String {
        CustomUsageCostConfiguration.formattedCurrency(estimatedCost, currencyCode: currencyCode)
    }

    var formattedTranscriptionCost: String {
        CustomUsageCostCalculator.formattedUSD(transcriptionCostUSD)
    }

    var formattedEnhancementCost: String {
        CustomUsageCostCalculator.formattedUSD(enhancementCostUSD)
    }
}

enum CustomUsageCostCalculator {
    static func summary(for transcriptions: [Transcription]) -> CustomUsageCostSummary {
        guard CustomFeatureConfiguration.apiUsageCostEnabled,
            CustomUsageCostConfiguration.isEnabled
        else {
            return emptySummary
        }

        var minutesByModel: [String: Double] = [:]
        var transcriptionCostByModel: [String: Double] = [:]
        var enhancementTokensByModel: [String: Int] = [:]
        var enhancementCostByModel: [String: Double] = [:]
        var enhancementProviderByModel: [String: String] = [:]

        for transcription in transcriptions {
            guard isCompleted(transcription) else { continue }

            if let modelName = billableModelName(from: transcription.transcriptionModelName),
                transcription.duration > 0
            {
                let minutes = transcription.duration / 60
                let costUSD = minutes * CustomUsageCostConfiguration.openAIWhisperUSDPerMinute
                minutesByModel[modelName, default: 0] += minutes
                transcriptionCostByModel[modelName, default: 0] += costUSD
            }

            if let usage = enhancementUsage(for: transcription) {
                let key = usage.groupingKey
                enhancementProviderByModel[key] = usage.providerName
                enhancementTokensByModel[key, default: 0] += usage.totalTokens
                enhancementCostByModel[key, default: 0] += usage.costUSD
            }
        }

        var rows: [CustomUsageCostRow] = minutesByModel.map { modelName, minutes in
            CustomUsageCostRow(
                kind: .transcription,
                providerName: "OpenAI",
                modelName: modelName,
                minutes: minutes,
                tokens: 0,
                costUSD: transcriptionCostByModel[modelName, default: 0]
            )
        }

        rows.append(contentsOf: enhancementTokensByModel.map { modelName, tokens in
            CustomUsageCostRow(
                kind: .enhancement,
                providerName: enhancementProviderByModel[modelName],
                modelName: modelName,
                minutes: 0,
                tokens: tokens,
                costUSD: enhancementCostByModel[modelName, default: 0]
            )
        })

        rows.sort { $0.costUSD > $1.costUSD }

        return CustomUsageCostSummary(
            totalMinutes: minutesByModel.values.reduce(0, +),
            enhancementTokens: enhancementTokensByModel.values.reduce(0, +),
            transcriptionCostUSD: transcriptionCostByModel.values.reduce(0, +),
            enhancementCostUSD: enhancementCostByModel.values.reduce(0, +),
            rows: rows
        )
    }

    static func breakdown(for transcription: Transcription) -> CustomUsageCostBreakdown? {
        guard CustomFeatureConfiguration.apiUsageCostEnabled,
            CustomUsageCostConfiguration.isEnabled,
            isCompleted(transcription)
        else { return nil }

        let transcriptionCost: Double
        if billableModelName(from: transcription.transcriptionModelName) != nil,
            transcription.duration > 0
        {
            transcriptionCost = transcription.duration / 60
                * CustomUsageCostConfiguration.openAIWhisperUSDPerMinute
        } else {
            transcriptionCost = 0
        }

        let enhancementCost = enhancementUsage(for: transcription)?.costUSD ?? 0
        guard transcriptionCost > 0 || enhancementCost > 0 else { return nil }
        return CustomUsageCostBreakdown(
            transcriptionCostUSD: transcriptionCost,
            enhancementCostUSD: enhancementCost
        )
    }

    static func cost(for transcription: Transcription) -> Double? {
        breakdown(for: transcription)?.totalCostUSD
    }

    static func formattedCost(for transcription: Transcription) -> String? {
        guard let costUSD = cost(for: transcription) else { return nil }
        return formattedUSD(costUSD)
    }

    static func formattedBreakdown(for transcription: Transcription) -> (
        transcription: String?, enhancement: String?, total: String
    )? {
        guard let breakdown = breakdown(for: transcription) else { return nil }
        let transcription = breakdown.transcriptionCostUSD > 0 ? formattedUSD(breakdown.transcriptionCostUSD) : nil
        let enhancement = breakdown.enhancementCostUSD > 0 ? formattedUSD(breakdown.enhancementCostUSD) : nil
        return (transcription, enhancement, formattedUSD(breakdown.totalCostUSD))
    }

    static func formattedUSD(_ amount: Double) -> String {
        let displayAmount = convertToDisplayCurrency(amount)
        return CustomUsageCostConfiguration.formattedCurrency(
            displayAmount,
            currencyCode: CustomUsageCostConfiguration.currencyCode
        )
    }

    static func convertToDisplayCurrency(_ amountUSD: Double) -> Double {
        CustomUsageCostConfiguration.currencyCode == "EUR"
            ? amountUSD * CustomUsageCostConfiguration.usdToEURRate
            : amountUSD
    }

    private static let emptySummary = CustomUsageCostSummary(
        totalMinutes: 0,
        enhancementTokens: 0,
        transcriptionCostUSD: 0,
        enhancementCostUSD: 0,
        rows: []
    )

    private struct EnhancementUsage {
        let providerName: String
        let modelName: String
        let totalTokens: Int
        let costUSD: Double

        var groupingKey: String { "\(providerName)\u{1F}\(modelName)" }
    }

    private static func enhancementUsage(for transcription: Transcription) -> EnhancementUsage? {
        guard let modelName = transcription.aiEnhancementModelName?.trimmingCharacters(in: .whitespacesAndNewlines),
            !modelName.isEmpty,
            let providerName = enhancementProviderName(for: transcription),
            isBillableEnhancementProvider(providerName)
        else { return nil }

        let inputTokens = EstimatedTokenCounter.count(
            in: [transcription.aiRequestSystemMessage, transcription.aiRequestUserMessage]
        ) ?? 0
        let outputTokens = EstimatedTokenCounter.count(in: transcription.enhancedText) ?? 0
        let totalTokens = inputTokens + outputTokens
        guard totalTokens > 0 else { return nil }

        let costUSD = Double(inputTokens) / 1_000_000
            * CustomUsageCostConfiguration.enhancementInputUSDPerMillionTokens
            + Double(outputTokens) / 1_000_000
            * CustomUsageCostConfiguration.enhancementOutputUSDPerMillionTokens

        return EnhancementUsage(
            providerName: providerName,
            modelName: modelName,
            totalTokens: totalTokens,
            costUSD: costUSD
        )
    }

    private static func enhancementModelName(from groupingKey: String) -> String {
        guard let separator = groupingKey.range(of: "\u{1F}") else { return groupingKey }
        return String(groupingKey[separator.upperBound...])
    }

    private static func enhancementProviderName(for transcription: Transcription) -> String? {
        if let provider = transcription.aiEnhancementProviderName?.trimmingCharacters(in: .whitespacesAndNewlines),
            !provider.isEmpty
        {
            return provider
        }

        guard let modelName = transcription.aiEnhancementModelName?.lowercased() else { return nil }
        if modelName.contains("voiceink refine") || modelName.contains("ollama") || modelName.contains("local") {
            return nil
        }
        if modelName.hasPrefix("gpt-") || modelName.hasPrefix("o1") || modelName.hasPrefix("o3") {
            return "OpenAI"
        }
        if modelName.hasPrefix("gemini-") { return "Gemini" }
        if modelName.hasPrefix("claude-") { return "Anthropic" }
        if modelName.hasPrefix("mistral-") { return "Mistral" }
        if modelName.hasPrefix("openai/") { return "OpenRouter / Groq" }
        return "Custom API"
    }

    private static func isBillableEnhancementProvider(_ providerName: String) -> Bool {
        let normalized = providerName.lowercased()
        return !["voiceink refine", "ollama", "local cli", "local"].contains(normalized)
    }

    private static func billableModelName(from name: String?) -> String? {
        guard let name else { return nil }
        switch name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
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
