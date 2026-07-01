# Word Unscrambler

A native iOS word unscrambler / anagram solver, built with SwiftUI. Enter a
handful of letters (optionally including `?` for a blank/wildcard tile) and
it finds every valid dictionary word that can be made from them.

## Features

- **Bilingual dictionaries** — switch between English and German word lists
  (and matching Scrabble-style scoring tables) in Settings. Everything runs
  fully offline; the word lists ship inside the app.
- **Scrabble/Words-with-Friends scoring** — each result shows its point
  value using the correct per-language letter values, sortable by score,
  alphabetically, or by length.
- **Wildcard tiles** — use `?` in your input for an unknown letter; results
  spelled with a blank show which letter it stood in for.
- **Filters** — narrow results by exact/min/max length, "starts with",
  "contains", or a Wordle-style position pattern (e.g. `_a__e`).
- **Camera scan** — photograph physical letter tiles and have them
  recognized on-device (Vision framework OCR) straight into the input field,
  no typing required. Falls back to a photo-library picker when no camera is
  available (e.g. in the iOS Simulator).
- **Word definitions** — tap any result to look up its definition via the
  free [dictionaryapi.dev](https://dictionaryapi.dev) service, with a
  friendly offline/not-found fallback.
- **History & favorites** — recent searches and starred words are saved
  locally and persist across launches.
- **Share** — send your results to another app via the native iOS share
  sheet.

## Requirements

- Xcode 15 or later
- iOS 17.0+ deployment target
- No external dependencies or package manager — pure SwiftUI + Foundation +
  Vision/VisionKit/PhotosUI (all built-in Apple frameworks).

## Getting started

```sh
open WordUnscrambler/WordUnscrambler.xcodeproj
```

Before running on a real device, open the target's **Signing & Capabilities**
tab in Xcode and set your own Team; the bundle identifier
(`com.example.wordunscrambler`) is a placeholder and should be changed to
your own reverse-DNS identifier.

This project was authored and reviewed without access to Xcode/macOS, so the
very first build you run will be its first-ever compilation — see
`NOTICE.md` for word-list sourcing/licensing details, and please file an
issue if Xcode surfaces anything unexpected.

## Project layout

```
WordUnscrambler/
├── WordUnscrambler.xcodeproj/
└── WordUnscrambler/
    ├── App/            App entry point
    ├── Models/         Trie, LetterRack, ScoredWord, filters, etc.
    ├── Services/       Solver, scoring, definitions, OCR, persistence
    ├── Views/          SwiftUI screens
    ├── Resources/       Bundled en.txt / de.txt word lists
    └── Assets.xcassets
```

## Notes

- The previous `Android`/`IOS` placeholder files from this repo's original,
  unrelated "Flipper Zero scripts" description have been removed.
- See `NOTICE.md` for the licenses and sources of the bundled word lists.
