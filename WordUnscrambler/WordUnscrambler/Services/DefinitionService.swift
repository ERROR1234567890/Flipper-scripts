import Foundation

/// Fetches word definitions from the free, keyless dictionaryapi.dev
/// service. Must never crash or leave the UI hanging: a single attempt with
/// a short timeout, explicit HTTP-status-based not-found detection (the API
/// returns a 404 with a body that won't decode as `[DictionaryEntry]`, so
/// checking status first is more correct than treating any decode failure
/// as "not found"), and defensive optional decoding throughout `Definition.swift`.
final class DefinitionService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchDefinition(word: String, language: DictionaryLanguage) async -> DefinitionResult {
        guard
            let encodedWord = word.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/\(language.apiLocaleCode)/\(encodedWord)")
        else {
            return .networkError
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 8

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .networkError
            }
            if httpResponse.statusCode == 404 {
                return .notFound
            }
            guard httpResponse.statusCode == 200 else {
                return .networkError
            }
            let entries = try JSONDecoder().decode([DictionaryEntry].self, from: data)
            return entries.isEmpty ? .notFound : .success(entries)
        } catch {
            return .networkError
        }
    }
}
