# Prepares a document, stripping leading and trailing whitespace from lines and adding a trailing newline
(defn prepare [s]
  (string (string/join (map (fn [line] (string/trim line)) (string/split "\n" s)) "\n") "\n"))
