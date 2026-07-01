import Foundation

/// Prefix tree used by `AnagramSolver` to find every dictionary word
/// reachable from a rack of letters.
final class Trie {
    private let root = TrieNode()

    /// Root accessor for `AnagramSolver`, which walks node references
    /// directly rather than re-implementing traversal here.
    var rootNode: TrieNode { root }

    func insert(_ word: String) {
        var node = root
        for character in word {
            if let existing = node.children[character] {
                node = existing
            } else {
                let newNode = TrieNode()
                node.children[character] = newNode
                node = newNode
            }
        }
        node.isEndOfWord = true
    }

    /// Bulk-load convenience used by `WordListService`.
    func insert(contentsOf words: some Sequence<String>) {
        for word in words {
            insert(word)
        }
    }
}
