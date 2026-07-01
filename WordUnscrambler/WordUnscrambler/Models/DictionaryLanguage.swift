import Foundation

/// The active dictionary/scoring language. This is the *word-list* language
/// used for solving, scoring, and definition lookups -- entirely separate
/// from the app's *UI display* language (which follows the system locale via
/// `Localizable.xcstrings`). A user can browse the app in English while
/// unscrambling German words, or vice versa.
enum DictionaryLanguage: String, Codable, CaseIterable, Identifiable {
    case english = "en"
    case german = "de"

    var id: String { rawValue }

    /// Matches the bundled resource file name (`en.txt` / `de.txt`).
    var resourceFileName: String { rawValue }

    /// Matches the `dictionaryapi.dev` locale path segment.
    var apiLocaleCode: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return String(localized: "language.english", defaultValue: "English")
        case .german: return String(localized: "language.german", defaultValue: "German")
        }
    }
}
