# Third-party word list attribution

The app bundles two word lists (`WordUnscrambler/WordUnscrambler/Resources/en.txt`
and `de.txt`), derived from the following public sources.

## English — `en.txt`

- **Source**: [dwyl/english-words](https://github.com/dwyl/english-words),
  `words_alpha.txt`
- **License**: [Unlicense](https://github.com/dwyl/english-words/blob/master/LICENSE.md)
  (public domain)
- **Fetched**: 2026-07-01
- **Cleaning applied**: lowercased, restricted to purely alphabetic entries
  (`a-z`), length 2–15, deduplicated, sorted.

## German — `de.txt`

- **Source**: [hermitdave/FrequencyWords](https://github.com/hermitdave/FrequencyWords),
  `content/2018/de/de_50k.txt`
- **License**: MIT for the repository's code; **CC BY-SA 4.0** for the word
  frequency data itself (per the source repository's README), which is in
  turn derived from the [OpenSubtitles2018](http://opus.nlpl.eu/OpenSubtitles2018.php)
  corpus.
- **Fetched**: 2026-07-01
- **Cleaning applied**: the frequency-count column was dropped (only the
  word itself is kept), lowercased, restricted to `a-z` plus `ä/ö/ü/ß`,
  length 2–15, deduplicated, sorted.

Per CC BY-SA 4.0, this file is a derivative of hermitdave/FrequencyWords'
German frequency list and is distributed under the same license; the
original project and OpenSubtitles corpus are credited above.
