(defn render [level ast]
  (case (type ast)
    :tuple (string/join (map (partial render (+ level 1)) ast) "\n")
    :array (string/join (map (partial render (+ level 1)) ast) "\n")
    :string (string (string/repeat "|" level) ast)
    :keyword (string (string/repeat "|" level) "<" ast ">")))
