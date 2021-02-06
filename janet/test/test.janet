(import testament :prefix "" :exit true)
(import ../parse)

(def cases @{"//foo//" "<p><i>foo</i></p>"
             "==foo==" "<p><b>foo</b></p>"
             "==//foo//==" "<p><b><i>foo</i></b></p>"
             "//==foo==//" "<p><i><b>foo</b></i></p>"
             "# foo" "<h1>foo</h1>"
             "#### foo" "<h4>foo</h4>"
             "# foo" "<h1>foo</h1>"
             "# //lul//" "<h1><i>lul</i></h1>"
             `
             ` ""
             `paragraph
             one

             //two//
             
             three` "<p>paragraph one</p><p><i>two</i></p><p>three</p>"
             `[
             x is cool
             y

             z
             ]` "<ul><li>x is cool</li><li>y</li><li>z</li></ul>"
             `[
             //italic//

             ==bold==
             ]
             ` "<ul><li><i>italic</i></li><li><b>bold</b></li></ul>"
             "--" "<hr>"
             "-----" "<hr>"})


(deftest all-cases (eachp [k v] cases (assert-equal v (parse/html k))))

(run-tests!)
