(defn render [meta ast]
  (match ast
    [:header n ast] (string (string/repeat "#" n) " " (render ast))
    [:bold ast] (string/format "**%s**" (render ast))
    [:italic ast] (string/format "_%s_" (render ast))
    [:link href ast] (string/format `[%s](%s)` (render ast) href)
    [:paragraph ast] (string/format "\n\n%s\n\n" (render ast))
    [:code ast] (string/format "`%s`" (render ast))
    [:multiline-code ast] (string/format "\n\n```%s```\n\n" (render ast))
    # TODO: nesting
    [:unordered-list items] (string/format "\n\n%s\n\n" (string/join (map (fn [s] (string "+ " (render s) "\n")) items)))
    _ (case (type ast)
        :tuple (string/join (map render ast))
        :array (string/join (map render ast))
        :string (string/trim ast)
        # TODO: nice errors
        (error (string/format "%.10M" ast)))))
