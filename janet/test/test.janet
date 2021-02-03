(import testament :prefix "" :exit true)
(import ../parse :prefix "")

(def cases @{"//foo//" "<i>foo</i>"
             "==foo==" "<b>foo</b>"
             "==//foo//==" "<b><i>foo</i></b>"
             "# foo" "<h1>foo</h1>"
             "#### foo" "<h4>foo</h4>"
             "# foo" "<h1>foo</h1>"})


(deftest all-cases (eachp [k v] cases (assert-equal v (html k))))

(run-tests!)
