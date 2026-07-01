import SwiftUI

struct ResultsListView: View {
    let results: [ScoredWord]
    let favoritesStore: FavoritesStore
    let onSelect: (ScoredWord) -> Void

    var body: some View {
        if results.isEmpty {
            ContentUnavailableView(
                String(localized: "results.empty", defaultValue: "No words yet"),
                systemImage: "text.magnifyingglass",
                description: Text(String(localized: "results.emptyDescription", defaultValue: "Enter some letters and tap Solve."))
            )
        } else {
            List(results) { word in
                Button {
                    onSelect(word)
                } label: {
                    HStack {
                        wordLabel(for: word)
                        Spacer()
                        Text("\(word.score)")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                        Button {
                            favoritesStore.toggle(word)
                        } label: {
                            Image(systemName: favoritesStore.isFavorite(word.word) ? "star.fill" : "star")
                                .foregroundStyle(favoritesStore.isFavorite(word.word) ? .yellow : .secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .buttonStyle(.plain)
            }
            .listStyle(.plain)
        }
    }

    /// Renders the word with any blank-tile letters underlined, so the user
    /// can see at a glance which letters were "invented" by a wildcard.
    private func wordLabel(for word: ScoredWord) -> some View {
        var result = Text("")
        for (index, character) in word.word.enumerated() {
            let letterText = Text(String(character))
            if word.blankAssignments[index] != nil {
                result = result + letterText.underline()
            } else {
                result = result + letterText
            }
        }
        return result
    }
}
