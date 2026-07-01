import Foundation

/// An immutable multiset of letters plus a count of wildcard/blank tiles.
///
/// Immutable-with-copies is chosen deliberately over a mutable class with
/// manual increment/decrement backtracking: it makes `AnagramSolver`'s
/// recursion trivial to reason about (no "did I remember to undo this?"
/// bugs), at the cost of one dictionary copy per recursive call. That's an
/// acceptable trade-off at these word-list sizes; if profiling on a real
/// device ever shows this is a bottleneck, switching to a mutable rack with
/// explicit undo is the natural follow-up optimization.
struct LetterRack {
    private var counts: [Character: Int]
    private(set) var blankCount: Int

    init(rawInput: String) {
        var counts: [Character: Int] = [:]
        var blanks = 0
        for character in rawInput.lowercased() {
            if character == "?" {
                blanks += 1
            } else if character.isLetter {
                counts[character, default: 0] += 1
            }
            // Whitespace/digits/punctuation are silently ignored so pasted
            // or OCR-recognized input doesn't need to be pre-sanitized by
            // the caller.
        }
        self.counts = counts
        self.blankCount = blanks
    }

    private init(counts: [Character: Int], blankCount: Int) {
        self.counts = counts
        self.blankCount = blankCount
    }

    /// Every letter currently available with a positive count.
    var availableLetters: [Character] {
        counts.compactMap { $0.value > 0 ? $0.key : nil }
    }

    var totalLetters: Int {
        counts.values.reduce(0, +) + blankCount
    }

    var isEmpty: Bool {
        totalLetters == 0
    }

    /// Returns a new rack with one fewer of `letter`, or `nil` if none are available.
    func consuming(_ letter: Character) -> LetterRack? {
        guard let current = counts[letter], current > 0 else { return nil }
        var newCounts = counts
        newCounts[letter] = current - 1
        return LetterRack(counts: newCounts, blankCount: blankCount)
    }

    /// Returns a new rack with one fewer blank, or `nil` if none remain.
    func consumingBlank() -> LetterRack? {
        guard blankCount > 0 else { return nil }
        return LetterRack(counts: counts, blankCount: blankCount - 1)
    }
}
