import FluidAudio
import Foundation

/// Provides a local Parakeet V3 preview for an OpenAI Whisper v1 session.
///
/// The recorded file remains authoritative: `StreamingTranscriptionSession`
/// uses its configured OpenAI cloud service as the batch fallback when this
/// provider requests fallback on stop.
final class OpenAIWhisperLocalPreviewProvider: StreamingTranscriptionProvider {
    private static let previewModel = FluidAudioModel(
        name: "parakeet-tdt-0.6b-v3",
        displayName: "Parakeet V3 (local preview)",
        description: "Local live preview used while OpenAI Whisper v1 prepares the final transcript",
        size: "494 MB",
        speed: 0.99,
        accuracy: 0.94,
        ramUsage: 0.8,
        supportsStreaming: true,
        supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .fluidAudio)
    )

    private let provider: FluidAudioStreamingProvider

    var transcriptionEvents: AsyncStream<StreamingTranscriptionEvent>

    /// Always use the configured OpenAI model for the authoritative final text.
    var stopDisposition: StreamingStopDisposition { .useBatchFallback }

    init() {
        let provider = FluidAudioStreamingProvider(fluidAudioService: FluidAudioTranscriptionService())
        self.provider = provider
        self.transcriptionEvents = provider.transcriptionEvents
    }

    func connect(model: any TranscriptionModel, language: String?) async throws {
        try await provider.connect(model: Self.previewModel, language: language)
    }

    func sendAudioChunk(_ data: Data) async throws {
        try await provider.sendAudioChunk(data)
    }

    func commit() async throws {
        try await provider.commit()
    }

    func disconnect() async {
        await provider.disconnect()
    }
}
