(defn render [ast]
  (match ast
    [:header n ast] (string/format "<h%d>%s</h%d>" n (render ast) n)
    # TODO: don't style the html in <title>
    [:title ast] (string/format "<title>%s</title><h1>%s</h1>" (render ast) (render ast))
    [:bold ast] (string/format "<b>%s</b>" (render ast))
    [:italic ast] (string/format "<i>%s</i>" (render ast))
    [:break] "<br />"
    [:link href ast] (if
                       # Empty link -> link text = href
                       (= ast "")
                       (string/format `<a href="%s">%s</a>` href href)
                       (string/format `<a href="%s">%s</a>` href (render ast)))
    [:image src alt] (string/format `<img src="%s" alt="%s">` src alt)
    # TODO join paragraphs with spaces
    [:paragraph ast] (string/format "<p>%s</p>" (render ast))
    [:code ast] (string/format "<code>%s</code>" (render ast))
    [:blockquote ast] (string/format "<blockquote>%s</blockquote>" (render ast))
    [:multiline-code ast] (string/format "<pre><code>%s</code></pre>" (render ast))
    [:unordered-list items] (string/format "<ul>%s</ul>" (string/join (map (fn [s] (string "<li>" (render s) "</li>")) items)))
    [:ordered-list items] (string/format "<ol>%s</ol>" (string/join (map (fn [s] (string "<li>" (render s) "</li>")) items)))
    [:table rows] (string/format "<table><tr>%s</tr>%s</table>" (string/join (map (fn [hcell] (string "<th>" (render hcell) "</th>")) (get rows 0))) (string/join (map (fn [row] (string "<tr>" (string/join (map (fn [cell] (string "<td>" (render cell) "</td>")) row)) "</tr>")) (array/slice rows 1 -1))))
    _ (case (type ast)
        :tuple (string/join (map render ast))
        :array (string/join (map render ast))
        :string ast
        # TODO: nice errors
        (error (string/format "%.10M" ast)))))
