import Foundation

enum ScoreCalculator {
    /// Sums per-letter values for `word`, except letters at a blank-assigned
    /// index, which always score 0 -- standard Scrabble rule: a blank tile
    /// is worth zero points regardless of which letter it represents. This
    /// is the single easiest correctness bug to introduce silently, so it's
    /// handled as an explicit exclusion here rather than folded into the sum.
    static func score(word: String, blankIndices: Set<Int>, table: [Character: Int]) -> Int {
        var total = 0
        for (index, letter) in word.enumerated() where !blankIndices.contains(index) {
            total += table[letter] ?? 0
        }
        return total
    }
}
