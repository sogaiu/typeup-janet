(import testament :prefix "" :exit true)
(import ../translate :prefix "")
(import ../grammar)

(def html-cases {# Styling
                 "//foo//" "<p><i>foo</i></p>"
                 "==foo==" "<p><b>foo</b></p>"
                 "==//foo//==" "<p><b><i>foo</i></b></p>"
                 "//==foo==//" "<p><i><b>foo</b></i></p>"
                 "//==foo== bar//bed wire" "<p><i><b>foo</b> bar</i>bed wire</p>"
                 # Titles
                 "# foo" "<h1>foo</h1>"
                 "#### foo" "<h4>foo</h4>"
                 "# foo" "<h1>foo</h1>"
                 "# //lul//" "<h1><i>lul</i></h1>"
                 # Empty lines
                 `
` ""
                 # <hr>
                 "--" "<hr>"
                 "-----" "<hr>"
                 # paragraphs
                 `paragraph
one

//two//

three` "<p>paragraph one</p><p><i>two</i></p><p>three</p>"
                 # lists
                 `[
x is cool
y

z
]` "<ul><li>x is cool</li><li>y</li><li>z</li></ul>"
                 `[
//italic//

==//bold and italic//==
]
` "<ul><li><i>italic</i></li><li><b><i>bold and italic</i></b></li></ul>"
                 `{
foo
bar

baz
==one //two// three==
}` "<ol><li>foo</li><li>bar</li><li>baz</li><li><b>one <i>two</i> three</b></li></ol>"
                 `[
this
is
cool and
{
x
y
z
[
a
b
c
]
}
]`
                 `<ul><li>this</li><li>is</li><li>cool and</li><ol><li>x</li><li>y</li><li>z</li><ul><li>a</li><li>b</li><li>c</li></ul></ol></ul>`
                 "`xyz`" "<p><code>xyz</code></p>"
                 "''xyz''" "<p><code>xyz</code></p>"
                 "```\nhello\nxyz\n```" "<pre><code>hello\nxyz</code></pre>"
                 "`==lol==`" "<p><code>==lol==</code></p>"
                 "this = normal text and should/must stay as is" "<p>this = normal text and should/must stay as is</p>"
                 `[x y]` `<p><a href="y">x</a></p>`
                 # only single spaces are considered whitespace delimiters right now
                 # `[x  y]` `<p><a href="y">x</a></p>`
                 `[x|y]` `<p><a href="y">x</a></p>`
                 # no styled text for now
                 # `[==x== ==y==]` `<p><a href="==y=="><b>x</b></a></p>`
                 `[skuzzymiglet's blog|https://skuz.xyz]'s load times are very good!` `<p><a href="https://skuz.xyz">skuzzymiglet's blog</a>'s load times are very good!</p>`
                 `[skuzzymiglet's blog https://skuz.xyz]'s load times are very good!` `<p><a href="https://skuz.xyz">skuzzymiglet's blog</a>'s load times are very good!</p>`
                 `img[this is a cool caption https://thispersondoesnotexist.com/image]` `<p><img src="https://thispersondoesnotexist.com/image" alt="this is a cool caption"></p>`
                 `![this is a cool caption https://thispersondoesnotexist.com/image]` `<p><img src="https://thispersondoesnotexist.com/image" alt="this is a cool caption"></p>`
                 # `#|{
                 # a|b|c|d
                 # e|f|g|h
                 # }` 
})

(def cases @{# TODO: make html look nice
             "html" html-cases})

(deftest all
  (eachp [target tcases] cases
    (eachp [k v] tcases
      (try (assert-equal v (translate k target)) ([err] (printf "error parsing %M: %s" k err))))))

(run-tests!)
