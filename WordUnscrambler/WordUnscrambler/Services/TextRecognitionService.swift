import Foundation
import UIKit
import Vision

/// On-device OCR of a photographed set of letter tiles, feeding straight
/// into the same rack-input pipeline as manual typing.
///
/// `usesLanguageCorrection` is deliberately `false`: we're reading scrambled,
/// non-word letter sequences, and Vision's language autocorrection would try
/// to "fix" them into real words -- exactly wrong for an unscrambler, where
/// the whole point is that the input isn't a real word yet.
enum TextRecognitionService {
    static func recognizeLetters(in image: UIImage, language: DictionaryLanguage) async -> String {
        guard let cgImage = image.cgImage else { return "" }

        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, _ in
                let observations = (request.results as? [VNRecognizedTextObservation]) ?? []
                let recognizedText = observations
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: " ")
                continuation.resume(returning: sanitize(recognizedText))
            }
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = false
            request.recognitionLanguages = [language == .german ? "de-DE" : "en-US"]

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(returning: "")
            }
        }
    }

    /// Keeps only alphabetic characters (including German umlauts/ß),
    /// lowercased, with everything else (whitespace, digits, punctuation
    /// Vision may pick up from tile borders/shadows) stripped out.
    private static func sanitize(_ text: String) -> String {
        String(text.lowercased().filter { $0.isLetter })
    }
}
