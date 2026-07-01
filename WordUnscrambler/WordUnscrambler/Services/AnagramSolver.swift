import Foundation

/// Finds every dictionary word reachable from a rack of letters (an
/// anagram/subset solver, the same technique real Scrabble word-finders use):
/// a recursive DFS that simultaneously walks a `Trie` and consumes a
/// `LetterRack`. At each Trie node that marks the end of a word, the current
/// path is a valid find. Blank tiles descend into *every* Trie child rather
/// than just letters physically in the rack, which is what makes wildcards
/// fall out naturally instead of needing special-case logic.
///
/// This was validated against hand-picked test cases (repeated letters,
/// blank-only-reachable words, dedup across multiple derivation paths) in a
/// throwaway Python prototype before being transcribed here.
struct AnagramSolver {
    let trie: Trie
    let scoreTable: [Character: Int]

    /// Words shorter than this are not useful unscrambler results and are
    /// dropped during collection rather than via a later filter pass.
    private let minimumWordLength = 2

    func solve(rack: LetterRack) -> [ScoredWord] {
        var results: [String: [Int: Character]] = [:]
        dfs(node: trie.rootNode, rack: rack, path: [], blankMap: [:], results: &results)

        return results.map { word, blankMap in
            ScoredWord(
                word: word,
                score: ScoreCalculator.score(word: word, blankIndices: Set(blankMap.keys), table: scoreTable),
                blankAssignments: blankMap
            )
        }
    }

    private func dfs(
        node: TrieNode,
        rack: LetterRack,
        path: [Character],
        blankMap: [Int: Character],
        results: inout [String: [Int: Character]]
    ) {
        if node.isEndOfWord, path.count >= minimumWordLength {
            let word = String(path)
            if let existing = results[word] {
                // Prefer a no-blank derivation if the same word is also
                // reachable without using a blank -- it's strictly a
                // "better" find (scores higher, since blanks are worth 0).
                if !existing.isEmpty && blankMap.isEmpty {
                    results[word] = blankMap
                }
            } else {
                results[word] = blankMap
            }
        }

        for letter in rack.availableLetters {
            guard let child = node.children[letter], let nextRack = rack.consuming(letter) else { continue }
            dfs(node: child, rack: nextRack, path: path + [letter], blankMap: blankMap, results: &results)
        }

        if rack.blankCount > 0, let nextRack = rack.consumingBlank() {
            for (letter, child) in node.children {
                var nextBlankMap = blankMap
                nextBlankMap[path.count] = letter
                dfs(node: child, rack: nextRack, path: path + [letter], blankMap: nextBlankMap, results: &results)
            }
        }
    }
}
