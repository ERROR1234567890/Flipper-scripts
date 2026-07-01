import Foundation
import Observation

/// Single source of truth for the active dictionary language. Driving the
/// active `Trie`, `LetterScoreTable`, and definition-API locale code all
/// from this one value is what makes the language "switchable in Settings."
///
/// Plain manual `UserDefaults` get/set (rather than `@AppStorage`) is used
/// deliberately: `@AppStorage` combined with `@Observable` is a still-
/// evolving pairing, and this project can't be compiled here to catch
/// subtle interaction issues, so the simpler, well-understood mechanism
/// is the safer choice.
@Observable
final class SettingsStore {
    private let defaultsKey = "settings.dictionaryLanguage"
    private let defaults: UserDefaults

    var dictionaryLanguage: DictionaryLanguage {
        didSet {
            defaults.set(dictionaryLanguage.rawValue, forKey: defaultsKey)
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if
            let raw = defaults.string(forKey: defaultsKey),
            let language = DictionaryLanguage(rawValue: raw)
        {
            self.dictionaryLanguage = language
        } else {
            self.dictionaryLanguage = .english
        }
    }
}
