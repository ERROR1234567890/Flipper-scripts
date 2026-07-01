import Foundation
import Observation

/// Loads bundled word-list resources into an in-memory `Trie` per language,
/// on a background thread, and caches the result so switching languages in
/// Settings during the same session doesn't rebuild a `Trie` already built.
@Observable
final class WordListService {
    private var cache: [DictionaryLanguage: Trie] = [:]
    private(set) var loadingLanguages: Set<DictionaryLanguage> = []

    /// Returns the `Trie` for `language`, building and caching it on first
    /// use. Building a 40k-360k word trie is dominated by total character
    /// count, not word count, and comfortably finishes in well under a
    /// second on-device, but this still runs off the calling actor via
    /// `Task.detached` so it never blocks the first frame.
    func trie(for language: DictionaryLanguage) async -> Trie {
        if let cached = cache[language] {
            return cached
        }

        loadingLanguages.insert(language)
        defer { loadingLanguages.remove(language) }

        let words = Self.loadWords(for: language)
        let trie = await Task.detached(priority: .userInitiated) {
            let trie = Trie()
            trie.insert(contentsOf: words)
            return trie
        }.value

        cache[language] = trie
        return trie
    }

    private static func loadWords(for language: DictionaryLanguage) -> [String] {
        guard
            let url = Bundle.main.url(forResource: language.resourceFileName, withExtension: "txt"),
            let contents = try? String(contentsOf: url, encoding: .utf8)
        else {
            assertionFailure("Missing bundled word list for \(language.rawValue)")
            return []
        }
        return contents
            .split(separator: "\n")
            .map(String.init)
            .filter { !$0.isEmpty }
    }
}
