(defn- vpp [& v] (pp v))

(defn- title [hashes & s] (string/format "<h%d>%s</h%d>" (length hashes) (string/trim (string/join s)) (length hashes)))
(defn- html-wrap [tag] (fn [& s] (string "<" tag ">" (string/join s) "</" tag ">")))
(defn- paragraph [& s] (string/format "<p>%s</p>" (string/join s " ")))
(defn- pre-code [& s] (string/format "<pre><code>%s</code></pre>" (string/join s "\n")))

# vim killed my link code. RIP
# anyways, there's a circular dependency between link and styling. needs to be fixed. also I need to sleep

(def styling ~{:text (some (choice :styling (capture :normaltext)))

               :main :text
               :nl (+ "\n" "\r" "\r\n")
               # The basics
               :char (if-not :nl 1)
               :chars (some :char)
               :wrapping (choice :bold-wrap :italic-wrap :code-wrap)

               :normalchar (if-not (choice :nl :wrapping) 1)
               :normaltext (some :normalchar)

               # Styling
               :styling (choice :link :code :italic :bold)

               :bold-wrap (choice "*" "==")
               :in-bold (if (to :bold-wrap) :text)
               :bold (* :bold-wrap (replace :in-bold ,(html-wrap "b")) :bold-wrap)

               :italic-wrap (choice "_" "//")
               :in-italic (if (to :italic-wrap) :text)
               :italic (* :italic-wrap (replace :in-italic ,(html-wrap "i")) :italic-wrap)

               :code-wrap (choice "''" "`")
               :in-code (capture (some (if-not :code-wrap 1)))
               :code (* :code-wrap (replace :in-code ,(html-wrap "code")) :code-wrap)

                :link (replace (* "[" (capture (to "]")) "]") ,link)})

(def document ~{# Structural

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
                :main (some :element)

                # Code copied from styling. We need to find a way to merge styling and document. For now, copy-pasting will have to do
                # Except :main :)
                # ===================================================================================
                :text (some (choice :styling (capture :normaltext)))

                :nl (+ "\n" "\r" "\r\n")
                # The basics
                :char (if-not :nl 1)
                :chars (some :char)
                :wrapping (choice :bold-wrap :italic-wrap :code-wrap)

                :normalchar (if-not (choice :nl :wrapping) 1)
                :normaltext (some :normalchar)

                # Styling
                :styling (choice :link :code :italic :bold)

                :bold-wrap (choice "*" "==")
                :in-bold (if (to :bold-wrap) :text)
                :bold (* :bold-wrap (replace :in-bold ,(html-wrap "b")) :bold-wrap)

                :italic-wrap (choice "_" "//")
                :in-italic (if (to :italic-wrap) :text)
                :italic (* :italic-wrap (replace :in-italic ,(html-wrap "i")) :italic-wrap)
                # :main :text

                :code-wrap (choice "''" "`")
                :in-code (capture (some (if-not :code-wrap 1)))
                :code (* :code-wrap (replace :in-code ,(html-wrap "code")) :code-wrap)

                :link (replace (* "[" (capture (to "]")) "]") ,link)
                # ===================================================================================
})
