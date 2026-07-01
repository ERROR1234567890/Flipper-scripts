import Foundation

/// Per-letter point values, mirroring the physical tile distributions of
/// standard English and German Scrabble sets.
enum LetterScoreTable {
    static let english: [Character: Int] = [
        "a": 1, "e": 1, "i": 1, "l": 1, "n": 1, "o": 1, "r": 1, "s": 1, "t": 1, "u": 1,
        "d": 2, "g": 2,
        "b": 3, "c": 3, "m": 3, "p": 3,
        "f": 4, "h": 4, "v": 4, "w": 4, "y": 4,
        "k": 5,
        "j": 8, "x": 8,
        "q": 10, "z": 10,
    ]

    // NOTE: the official German Scrabble tile distribution values Ö at 8
    // points (not 6). Ä and Ü are both 6. This deliberately corrects a value
    // that's easy to misremember/mis-group with Ä/Ü -- documented here so a
    // future reader doesn't "fix" it back to 6 by mistake.
    static let german: [Character: Int] = [
        "a": 1, "b": 3, "c": 4, "d": 1, "e": 1, "f": 4, "g": 2, "h": 2, "i": 1,
        "j": 6, "k": 4, "l": 2, "m": 3, "n": 1, "o": 2, "p": 4, "q": 10, "r": 1,
        "s": 1, "t": 1, "u": 1, "v": 6, "w": 3, "x": 8, "y": 10, "z": 3,
        "ä": 6, "ö": 8, "ü": 6,
    ]

    static func table(for language: DictionaryLanguage) -> [Character: Int] {
        switch language {
        case .english: return english
        case .german: return german
        }
    }
}
