# typeup

A markdown-like document format designed with the keyboard in mind. No tabs, no line prefixes, extensible and super easy to type

shift + top row is hard, unfortunately a lot hides there (fug you, whoever made this shit)

newlines =are= reflected in the final html! also customizable with custom blocks

# goals

+ use easy-to-type chars where possible
+ avoid tabs and significant whitespace
+ never have line prefixes
+ allow external customization (custom blocks, templates)
+ be unambigous
+ provide some metadata that would otherwise be scraped (published, title? maybe we don't need this)

## toplevel stuff

+ unordered lists
+ styling
+ links and images
+ code blocks
+ comments (maybe we don't need these)

## styling priority list

+ bold and italic - essential
+ bold and underline are semantically equivalent
+ inline code blocks - important
+ quotes - important
+ strikethrough is redundant

# lists

unordered: `[]`, `,` can be used as delimiter
ordered: `{}`, `,`
nestable

# what i wanna do this week

[
bake bread
{knead, proof, bake}
make fresh pasta
learn french
{vocab, grammar, {tenses, moods}, pronunciation}
] 

you can make these look pretty if you want

# text styling

=bold text= and -italic text-

this means that = must be spaced.

5+6=8 -> error unclosed
5+6 = 8 -> fine
5 + 6 = =8= -> boldened

==hello== guys, this //is// important!
Doubling reduces ambiguity.

or /italic/?

# quotes

// this is a crazy cool cooc caahc quote // calvin coolij //

// This...
is
multiline
and
newlines are meaningful //

// quiuq lol
ass // dikekike //

Author not required, of course

close bracket, author and author close bracket must be on the same line

Nested quotes are not supported, lol. tone down your recursive flamebait

# titles

+ hash is good, just as in markdown!

# code

plain code/code pre blocks:

''
code lol
''

the ''sh'' command is ballsy

''s must be together. single ' inside is fine
multiline: ''s must be on their own lines

no reaching for the awkward \`

# links

[[my website: https://skuz.xyz]] is very cool

# media

video[[]]
image[[]]

if you don't specify the alt text here, and `extractTitle` is set, the file metadata will be used to determine it

You can also set an option `automedia`, which turns links into media based on their mimetype

# tables

tables? I don't like tables but they're nice sometimes. They should look like a list

```
#[
Name, Age, Color
Rafik, 3, gray
John, 565, orange
]
```


format:

```
#[
header,row,items
items,etc,  etc
]
```

# custom blocks

go:[
    func main(){}
]

toc:[*] gets the full document (doesn't change it tho). this does a table of contents
gruvbox:[*] you could use it for styling

note: x:[*] is disabled in stream-parsing mode

you can pass through 2 custom blocks by nesting them

## some ideas

[
toc: generate a table of contents
anki: save x:y or x=y pairs as anki flashcards
raw: raw output, no escaping
{go,sh,zig,rust}: syntax highlighting
gofmt: need i say
annotate: annotations
]

annotate:[
    gofmt:[
        ''
        func main(){ // <1>
            println(oof)
        }
        ''
    ]
    1: entry point
]

## implementing these

implemented as `func(body []byte, outputFormat string) []byte`

# misc

@{automedia} rendering parameters

# writing shortcuts

' -> "
[ -> (
] -> )

these are bad lol. Ambiguity af
