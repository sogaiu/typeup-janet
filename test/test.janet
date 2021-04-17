(use ./testlib)
(import ../grammar)
(import ../prepare)

(setdyn :on-function-assertv= true)

(defn- p [ast] [[:paragraph ast]])

(on-function |(freeze (peg/match grammar/document (prepare/prepare $0)))
             ["paragraph" [`foo`] [[:paragraph ["foo"]]]
              "multiline paragraph" [`foo
bar`] [[:paragraph ["foo" " " "bar"]]]
              "title" ["=# title"] [[:set "title" "title"]]
              "h1" ["# foo"] [[:header 1 ["foo"]]]
              "h6" ["###### foo"] [[:header 6 ["foo"]]]
              "styled header" ["# *bold*"] [[:header 1 [[:bold ["bold"]]]]]
              "bold" ["*bold*"] (p [[:bold ["bold"]]])
              "italic" ["_italic_"] (p [[:italic ["italic"]]])
              "code" ["`code`"] (p [[:code ["code"]]])
              "nested styling" ["*_foo_*"] (p [[:bold [[:italic ["foo"]]]]])
              "link using spaces" ["[text href]"] (p [[:link "href" "text"]])
              "link using pipe" ["[text|href]"] (p [[:link "href" "text"]])
              "textless link" ["[href]"] (p [[:link "href" "href"]])
              "textless link with pipe" ["[|href]"] (p [[:link "href" "href"]])
              "styled link text" ["[*bold* href]"] (p [[:link "href" [[:bold "bold"]]]])
              "image" ["![alt|src]"] (p [[:image "src" "alt"]])
              "alt-less image" ["![src]"] (p [[:image "src" ""]])
              "quote" ["| quote"] [[:blockquote ["quote"]]]
              "styled quote" ["| *quote*"] [[:blockquote [[:bold ["quote"]]]]]
              ])
