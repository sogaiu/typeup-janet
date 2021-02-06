(import testament :prefix "" :exit true)
(import ../parse)

(def cases @{"//foo//" "<i>foo</i>"
             "==foo==" "<b>foo</b>"
             "==//foo//==" "<b><i>foo</i></b>"
             "//==foo==//" "<i><b>foo</b></i>"
             "# foo" "<h1>foo</h1>"
             "#### foo" "<h4>foo</h4>"
             "# foo" "<h1>foo</h1>"
             "# //lul//" "<h1><i>lul</i></h1>"
             `
             ` ""
             `paragraph
             one
             
             two` "<p>paragraph one</p><p>two</p>"
             "--" "<hr>"
             "-----" "<hr>"})


(deftest all-cases (eachp [k v] cases (assert-equal v (parse/html k))))

(run-tests!)
