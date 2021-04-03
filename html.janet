(defn render [meta ast]
  (def- renderm (partial render meta)) # shortcut for rendering with metadata
  (match ast
    [:header n ast] (string/format "<h%d>%s</h%d>" n (renderm ast) n)
    [:bold ast] (string/format "<b>%s</b>" (renderm ast))
    [:italic ast] (string/format "<i>%s</i>" (renderm ast))
    [:break] "<br />"
    [:link href ast] (if
                       # Empty link -> link text = href
                       (= ast "")
                       (string/format `<a href="%s">%s</a>` href href)
                       (string/format `<a href="%s">%s</a>` href (renderm ast)))
    [:image src alt] (string/format `<img src="%s" alt="%s">` src alt)
    # TODO join paragraphs with spaces
    [:paragraph ast] (string/format "<p>%s</p>" (renderm ast))
    [:code ast] (string/format "<code>%s</code>" (renderm ast))
    [:blockquote ast] (string/format "<blockquote>%s</blockquote>" (renderm ast))
    [:multiline-code ast] (string/format "<pre><code>%s</code></pre>" (renderm ast))
    [:unordered-list items] (string/format "<ul>%s</ul>" (string/join (map (fn [s] (string "<li>" (renderm s) "</li>")) items)))
    [:ordered-list items] (string/format "<ol>%s</ol>" (string/join (map (fn [s] (string "<li>" (renderm s) "</li>")) items)))
    # TODO: Separate this into a function
    [:table rows] (string/format "<table><tr>%s</tr>%s</table>"
                                 (string/join (map (fn [hcell] (string "<th>" (renderm hcell) "</th>")) (get rows 0)))
                                 (string/join (map (fn [row]
                                                     (string "<tr>" (string/join (map (fn [cell] (string "<td>" (renderm cell) "</td>")) row)) "</tr>")) (array/slice rows 1 -1))))
    [:set k v] ""
    _ (case (type ast)
        :tuple (string/join (map renderm ast))
        :array (string/join (map renderm ast))
        :string ast
        # TODO: nice errors
        (error (string/format "%.10M" ast)))))
