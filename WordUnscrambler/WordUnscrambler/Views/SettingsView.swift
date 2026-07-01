import SwiftUI

struct SettingsView: View {
    @Environment(SettingsStore.self) private var settingsStore

    var body: some View {
        @Bindable var settingsStore = settingsStore

        NavigationStack {
            Form {
                Section {
                    Picker(String(localized: "settings.dictionaryLanguage", defaultValue: "Dictionary language"), selection: $settingsStore.dictionaryLanguage) {
                        ForEach(DictionaryLanguage.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .pickerStyle(.segmented)
                } footer: {
                    Text(String(localized: "settings.dictionaryLanguageHelp", defaultValue: "Changes which word list, scoring table, and definition lookups are used for solving. This is separate from the app's display language."))
                }

                Section(String(localized: "settings.about", defaultValue: "About")) {
                    LabeledContent(String(localized: "settings.wordLists", defaultValue: "Word list sources"), value: "NOTICE.md")
                }
            }
            .navigationTitle(String(localized: "tab.settings", defaultValue: "Settings"))
        }
    }
}

#Preview {
    SettingsView()
        .environment(SettingsStore())
}
