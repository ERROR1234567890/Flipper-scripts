import SwiftUI

struct ContentView: View {
    /// Shared across tabs so tapping a History entry can populate and jump
    /// back to the Unscramble tab.
    @State private var pendingRackInput: String?
    @State private var selectedTab = Tab.unscramble

    enum Tab {
        case unscramble, history, favorites, settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            UnscrambleView(pendingRackInput: $pendingRackInput)
                .tabItem { Label(String(localized: "tab.unscramble", defaultValue: "Unscramble"), systemImage: "shuffle") }
                .tag(Tab.unscramble)

            HistoryView(onSelect: { rackInput in
                pendingRackInput = rackInput
                selectedTab = .unscramble
            })
            .tabItem { Label(String(localized: "tab.history", defaultValue: "History"), systemImage: "clock") }
            .tag(Tab.history)

            FavoritesView()
                .tabItem { Label(String(localized: "tab.favorites", defaultValue: "Favorites"), systemImage: "star") }
                .tag(Tab.favorites)

            SettingsView()
                .tabItem { Label(String(localized: "tab.settings", defaultValue: "Settings"), systemImage: "gearshape") }
                .tag(Tab.settings)
        }
    }
}

#Preview {
    ContentView()
        .environment(SettingsStore())
        .environment(HistoryStore())
        .environment(FavoritesStore())
        .environment(WordListService())
}
