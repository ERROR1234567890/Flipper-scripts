import Foundation
import Observation

@Observable
final class FavoritesStore {
    /// Stores the full `ScoredWord` (not just the string) so the Favorites
    /// tab can show score without recomputation -- score depends on which
    /// dictionary/table was active at find-time.
    private(set) var favorites: [ScoredWord] = []

    private let defaultsKey = "favorites.v1"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func isFavorite(_ word: String) -> Bool {
        favorites.contains { $0.word == word }
    }

    func toggle(_ word: ScoredWord) {
        if let index = favorites.firstIndex(where: { $0.word == word.word }) {
            favorites.remove(at: index)
        } else {
            favorites.append(word)
        }
        save()
    }

    func remove(_ word: ScoredWord) {
        favorites.removeAll { $0.word == word.word }
        save()
    }

    private func load() {
        guard
            let data = defaults.data(forKey: defaultsKey),
            let decoded = try? JSONDecoder().decode([ScoredWord].self, from: data)
        else { return }
        favorites = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        defaults.set(data, forKey: defaultsKey)
    }
}
