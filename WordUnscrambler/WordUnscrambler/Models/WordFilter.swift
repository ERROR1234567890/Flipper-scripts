import Foundation

/// A set of optional, cumulative constraints applied to already-solved
/// results. Kept fully decoupled from `AnagramSolver` -- filtering happens
/// as a cheap pass over completed words, not during the DFS, so the solver
/// stays simple and this stays trivially testable on its own.
struct WordFilter: Equatable {
    var exactLength: Int?
    var minLength: Int?
    var maxLength: Int?
    var startsWith: String = ""
    var contains: String = ""
    /// Wordle-style positional pattern, e.g. "_a__e" (underscore = any letter).
    var pattern: String = ""

    var isActive: Bool {
        exactLength != nil || minLength != nil || maxLength != nil ||
            !startsWith.isEmpty || !contains.isEmpty || !pattern.isEmpty
    }

    func matches(_ word: String) -> Bool {
        let lower = word.lowercased()

        if let exactLength, lower.count != exactLength { return false }
        if let minLength, lower.count < minLength { return false }
        if let maxLength, lower.count > maxLength { return false }

        if !startsWith.isEmpty, !lower.hasPrefix(startsWith.lowercased()) { return false }
        if !contains.isEmpty, !lower.contains(contains.lowercased()) { return false }

        if !pattern.isEmpty {
            let patternLower = Array(pattern.lowercased())
            let letters = Array(lower)
            guard letters.count == patternLower.count else { return false }
            for (patternChar, letter) in zip(patternLower, letters) {
                if patternChar != "_" && patternChar != letter { return false }
            }
        }

        return true
    }

    func apply(to words: [ScoredWord]) -> [ScoredWord] {
        guard isActive else { return words }
        return words.filter { matches($0.word) }
    }
}
