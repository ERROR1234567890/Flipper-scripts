import Foundation

/// A single node in a `Trie`. Reference type on purpose: a value-type node
/// graph would need copy-on-write gymnastics for what is otherwise a simple
/// parent/child pointer structure.
final class TrieNode {
    var children: [Character: TrieNode] = [:]
    var isEndOfWord = false
}
