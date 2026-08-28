import Foundation
import LLMkit
import SwiftData

/// Fork-owned batch transcription provider for OpenAI's Whisper v1 model.
///
/// This uses VoiceInk's existing `CloudProvider` contract and LLMkit's
/// OpenAI-compatible multipart client. It does not participate in realtime
/// streaming because `whisper-1` is a batch-only endpoint.
struct OpenAIWhisperProvider: CloudProvider {
    let modelProvider: ModelProvider = .openAI
    let providerKey: String = "OpenAI"
    let languageCodes: [String]? = nil
    let includesAutoDetect: Bool = true

    var models: [CloudModel] {
        [
            CloudModel(
                name: "whisper-1",
                displayName: "Whisper v1",
                description: "OpenAI's hosted Whisper model for accurate batch transcription",
                provider: .openAI,
                isMultilingual: true,
                supportedLanguages: LanguageDictionary.all
            )
        ]
    }

    func transcribe(
        audioData: Data, fileName: String, apiKey: String, model: String, language: String?, customVocabulary: [String]
    ) async throws -> String {
        try await OpenAITranscriptionClient.transcribe(
            baseURL: URL(string: "https://api.openai.com")!,
            audioData: audioData,
            fileName: fileName,
            apiKey: apiKey,
            model: model,
            language: language,
            prompt: customVocabulary.isEmpty ? nil : customVocabulary.joined(separator: ", ")
        )
    }

    func makeStreamingProvider(modelContext: ModelContext) -> (any StreamingTranscriptionProvider)? { nil }

    func verifyAPIKey(_ key: String) async -> (isValid: Bool, errorMessage: String?) {
        await OpenAITranscriptionClient.verifyAPIKey(
            baseURL: URL(string: "https://api.openai.com")!,
            apiKey: key
        )
    }
}
