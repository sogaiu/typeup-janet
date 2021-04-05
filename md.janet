(use ./util)

(defn render [meta ast]
  (def- renderm (partial render meta)) # shortcut for rendering with metadata

  (def render-table (fn [rows] (do
                                 (def maxr (max ;(map length rows)))
                                 (string
                                   (string/join (map renderm (rows 0)) "|")
                                   "\n"
                                   (string/repeat "---|" maxr)
                                   "\n"
                                   (string/join (map (fn [row] (string/join (map renderm row) "|")) (array/slice rows 1 -1)) "\n")))))

  (if (and (or (array? ast) (tuple? ast)) (> (length ast) 0) (keyword? (ast 0)))
    (match ast
      [:header n ast] (string/format "%s %s\n" (string/repeat "#" n) (renderm ast))
      [:bold ast] (string/format "**%s**" (renderm ast))
      [:italic ast] (string/format "_%s_" (renderm ast))
      [:link href ast]
      (if
        # Empty link -> link text = href
        (= ast "")
        (string/format `[%s](%s)` href href)
        (string/format `[%s](%s)` (renderm ast) href))
      [:image src alt] (do
                         (assert (= (type alt) :string))
                         (string/format `![%s](%s)` alt src))
      [:blockquote ast] (string (string/join (map (fn [line] (string/format "> %s" line)) (string/split "\n" (string/trim (renderm ast)))) "\n") "\n\n")
      [:break] "---"
      [:paragraph ast] (string/format "\n\n%s\n\n" (renderm ast))
      [:code ast] (string/format "`%s`" (renderm ast))
      [:multiline-code ast] (string/format "\n\n```\n%s```\n\n" (renderm ast))
      # TODO: nesting
      [:unordered-list items] (string/format "\n\n%s\n\n" (string/join (map (fn [s] (string "+ " (renderm s) "\n")) items)))
      [:ordered-list items] (string/format "\n\n%s\n\n" (string/join (map-indexed (fn [i s] (string/format "%d. %s\n" (+ 1 i) (renderm s) "\n")) items)))
      [:table rows] (render-table rows)
      [:set k v] ""
      (error (pp ast)))
    (case (type ast)
      :tuple
      (string/join (map renderm ast))

      :array
      (string/join (map renderm ast))
      :string ast
      # TODO: nice errors
      (error (string/format "%.10M" ast)))))
