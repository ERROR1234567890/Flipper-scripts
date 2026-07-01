import Foundation

/// A dictionary word found by `AnagramSolver`, together with its Scrabble-style
/// score and which letter (if any) each blank tile stood in for.
struct ScoredWord: Identifiable, Codable, Hashable {
    var id: String { word }

    let word: String
    let score: Int
    /// Maps a zero-based index in `word` to the letter a blank tile
    /// represented there. Empty when no blanks were used to spell this word.
    let blankAssignments: [Int: Character]

    var length: Int { word.count }
    var usedBlank: Bool { !blankAssignments.isEmpty }
}

extension ScoredWord {
    enum SortOption: String, CaseIterable, Identifiable {
        case scoreDescending
        case alphabetical
        case lengthDescending

        var id: String { rawValue }
    }

    static func sorted(_ words: [ScoredWord], by option: SortOption) -> [ScoredWord] {
        switch option {
        case .scoreDescending:
            return words.sorted { $0.score != $1.score ? $0.score > $1.score : $0.word < $1.word }
        case .alphabetical:
            return words.sorted { $0.word < $1.word }
        case .lengthDescending:
            return words.sorted { $0.length != $1.length ? $0.length > $1.length : $0.word < $1.word }
        }
    }
}

// `Character` isn't directly `Codable`-key-friendly in a `[Int: Character]`
// dictionary the way `Codable` synthesis expects string/int keys, but
// `Dictionary` conforms to `Codable` when `Key: Codable & Hashable` and
// `Value: Codable`; `Character` already conforms to both, and `Int` keys are
// supported natively by `JSONEncoder`/`JSONDecoder` (encoded as string keys),
// so the synthesized conformance on `ScoredWord` above works without any
// extra code here.
