# typeup-janet

This is an implementation of the [typeup](https://skuz.xyz/typeup/) markup language in [Janet](https://janet-lang.org)

## Installation

[![Packaging status](https://repology.org/badge/vertical-allrepos/janet-lang.svg)](https://repology.org/project/janet-lang/versions)

1. Install Janet (see also [the official guide](https://janet-lang.org/introduction.html))
2. Install typeup: `sudo jpm install 'https://git.sr.ht/~skuzzymiglet/typeup-janet'`

## Usage

```sh
# typeup <output format>
typeup html # reads standard input, writes to standard output
typeup md # GitHub flavored markdown
typeup ast # Internal AST
typeup meta.title # Metadata key "title"
typeup html < document.tup > output.html
```
