(import ./testament :prefix "" :exit true)
(import ../grammar)
(import ../html)

# TODO: tests are lagging behind example-document.tup. Make a system to sync these
(def ast-tests
  {"# title\n" [[:header 1 ["title"]]]
   "# title *bold*\n" [[:header 1 ["title " [:bold ["bold"]]]]]
   `
   [
   foo
   bar*bed*
   ]
   `
   [[:unordered-list [["foo"] ["bar" [:bold ["bed"]]]]]]
   `=# hello` [[:title ["hello"]]]
   `#||{
   header||cells
   foo||bar
   }
   ` 
   [[:table [[["header"] ["cells"]] [["foo"] ["bar"]]]]]
   `#||{
   header||cells
   foo||bar
   }
   ` 
   [[:table [[["header"] ["cells"]] [["foo"] ["bar"]]]]]
   `#||{
   header||
   foo||
   }
   ` 
   [[:table [[["header"]] [["foo"]]]]]
   })

(deftest ast
  (eachp [k v] ast-tests
    (eprintf "Input: %.10M" (string/trim k))
    (assert-equal v (freeze (peg/match grammar/document (string k "\n"))))))

# TODO: use janet-html to construct html (prettier)
(def html-tests
  {[[:title ["hello"]]] `<title>hello</title><h1>hello</h1>`
   [[:header 1 ["title"]]] "<h1>title</h1>"
   [[:header 6 ["title"]]] "<h6>title</h6>"
   [[:header 1 ["a" "b" "c"]]] "<h1>abc</h1>"
   [[:header 1 ["a" [:bold "b"]]]] "<h1>a<b>b</b></h1>"
   [[:link "href" "text"]] `<a href="href">text</a>`
   [[:paragraph "text"]] `<p>text</p>`
   [[:unordered-list [["foo"] ["bar" [:bold "bed"]]]]] `<ul><li>foo</li><li>bar<b>bed</b></li></ul>`
   [[:table [[["header"] ["cells"]] [["foo"] ["bar"]]]]] "<table><tr><th>header</th><th>cells</th></tr><tr><td>foo</td><td>bar</td></tr></table>"
   [:title ["xyz"]] "<title>xyz</title><h1>xyz</h1>"})

(deftest html
  (eachp [k v] html-tests
    (eprintf "Input: %.10M" k)
    (assert-equal v (html/render k))))

(run-tests!)
