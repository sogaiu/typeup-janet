(defn- vpp [& v] (pp v))

(defn- title [hashes & s] (string/format "<h%d>%s</h%d>" (length hashes) (string/trim (string/join s)) (length hashes)))
(defn- html-wrap [tag] (fn [& s] (string "<" tag ">" (string/join s) "</" tag ">")))
(defn- paragraph [& s] (string/format "<p>%s</p>" (string/join s " ")))
(defn- pre-code [& s] (string/format "<pre><code>%s</code></pre>" (string/join s "\n")))

(defn link [inside]
  (var html "")
  # this could be airier and less duplicated
  (cond
    (string/find "|" inside) (do
                               (def parts (string/split "|" inside))
                               (set html (string/format `<a href="%s">%s</a>` (get (array/slice parts -2 -1) 0) (string/join (array/slice parts 0 -2)))))
    (do
      (def parts (string/split " " inside))
      (set html (string/format `<a href="%s">%s</a>` (get (array/slice parts -2 -1) 0) (string/join (array/slice parts 0 -2) " ")))))
  html)

(defn image [inside]
  (var html "")
  (cond
    (string/find "|" inside) (do
                               (def parts (string/split "|" inside))
                               (set html (string/format `<img src="%s" alt="%s">` (get (array/slice parts -2 -1) 0) (string/join (array/slice parts 0 -2)))))
    (do
      (def parts (string/split " " inside))
      (set html (string/format `<img src="%s" alt="%s">` (get (array/slice parts -2 -1) 0) (string/join (array/slice parts 0 -2) " ")))))
  html)

(def document ~{:nl (+ "\n" "\r" "\r\n")
                # The basics
                :char (if-not :nl 1)
                :chars (some :char)
                :wrapping (choice :bold-wrap :italic-wrap :code-wrap)

                :normalchar (if-not (choice :nl :wrapping) 1)
                :normaltext (some :normalchar)

                # Styling
                :styling (choice :image :link :code :italic :bold)

                :bold-wrap (choice "*" "==")
                :in-bold (if (to :bold-wrap) :text)
                :bold (* :bold-wrap (replace :in-bold ,(html-wrap "b")) :bold-wrap)

                :italic-wrap (choice "_" "//")
                :in-italic (if (to :italic-wrap) :text)
                :italic (* :italic-wrap (replace :in-italic ,(html-wrap "i")) :italic-wrap)

                :code-wrap (choice "''" "`")
                :in-code (capture (some (if-not :code-wrap 1)))
                :code (* :code-wrap (replace :in-code ,(html-wrap "code")) :code-wrap)

                :link (replace (* "[" (capture (to "]")) "]") ,link)
                :image (replace (* (choice "image" "img" "!") "[" (capture (to "]")) "]") ,image)

                :text (some (choice :styling (capture :normaltext)))

                # Structural

                :pre-code (* "```\n" (replace (some (* (capture :normaltext) "\n")) ,pre-code) "```")

                :hashes (between 1 6 "#")
                :title (replace (* (capture :hashes) :text) ,title)

                :quote (replace (* "|" (capture :chars)) ,(html-wrap "blockquote"))
                :hr (replace (at-least 2 "-") "<hr>")

                :paragraph (replace (some (* (replace :text ,string) "\n")) ,paragraph)

                :li (* (choice :list (replace (some (if-not (choice :nl (set "[]{}")) :text)) ,(html-wrap "li")) "") :nl)
                :ul (* "[" (? "\n") (replace (some :li) ,(html-wrap "ul")) "]")
                :ol (* "{" (? "\n") (replace (some :li) ,(html-wrap "ol")) "}")
                :list (choice :ol :ul)

                :line (choice :title :quote :hr "")
                :element (choice :pre-code :list (* :line "\n") :paragraph)
                :main (some :element)})
