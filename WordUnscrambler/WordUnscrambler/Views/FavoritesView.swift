import SwiftUI

struct FavoritesView: View {
    @Environment(FavoritesStore.self) private var favoritesStore
    @Environment(SettingsStore.self) private var settingsStore
    @State private var selectedWord: ScoredWord?

    var body: some View {
        NavigationStack {
            Group {
                if favoritesStore.favorites.isEmpty {
                    ContentUnavailableView(
                        String(localized: "favorites.empty", defaultValue: "No favorites yet"),
                        systemImage: "star"
                    )
                } else {
                    List {
                        ForEach(favoritesStore.favorites) { word in
                            Button {
                                selectedWord = word
                            } label: {
                                HStack {
                                    Text(word.word)
                                    Spacer()
                                    Text("\(word.score)")
                                        .foregroundStyle(.secondary)
                                        .monospacedDigit()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete { offsets in
                            offsets.map { favoritesStore.favorites[$0] }.forEach(favoritesStore.remove)
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "tab.favorites", defaultValue: "Favorites"))
            .sheet(item: $selectedWord) { word in
                DefinitionSheetView(word: word.word, language: settingsStore.dictionaryLanguage)
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environment(FavoritesStore())
        .environment(SettingsStore())
}
