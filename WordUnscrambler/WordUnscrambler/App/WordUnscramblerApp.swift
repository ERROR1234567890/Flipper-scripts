import SwiftUI

@main
struct WordUnscramblerApp: App {
    @State private var settingsStore = SettingsStore()
    @State private var historyStore = HistoryStore()
    @State private var favoritesStore = FavoritesStore()
    @State private var wordListService = WordListService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settingsStore)
                .environment(historyStore)
                .environment(favoritesStore)
                .environment(wordListService)
        }
    }
}
