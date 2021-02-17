#!/bin/janet

(defn- title [hashes & s] (string/format "<h%d>%s</h%d>" (length hashes) (string/trim (string/join s)) (length hashes)))

(defn- html-wrap [tag] (fn [& s] (string "<" tag ">" (string/join s) "</" tag ">")))
(defn- paragraph [& s] (string/format "<p>%s</p>" (string/join s " ")))
(defn- pre-code [& s] (string/format "<pre><code>%s</code></pre>" (string/join s "\n")))

# TODO maybe precompile a list of PEGs
(defn grammar [target] ~{:nl (+ "\n" "\r" "\r\n")
                         :char (if-not :nl 1)
                         :chars (some :char)

                         # TODO variableize opening/close chars
                         :bold-wrap (choice "*" "==")
                         :italic-wrap (choice "_" "//")
                         :code-wrap (choice "''" "`")
                         :wrapping (choice :bold-wrap :italic-wrap :code-wrap)

                         :normalchar (if-not (choice :nl :wrapping) 1)
                         :normaltext (some :normalchar)
                         :styling (choice :code :italic :bold)
                         :text (some (choice :styling (capture :normaltext)))

                         :in-bold (if (to "==") :text)
                         # TODO replace -> replace for cleaner code
                         :bold (* "==" (replace :in-bold ,(html-wrap "b")) "==")

                         # TODO these are repetitive
                         :in-italic (if (to "//") :text)
                         :italic (* "//" (replace :in-italic ,(html-wrap "i")) "//")

                         :in-code (if (to "`") :text)
                         :code (* :code-wrap (replace :in-code ,(html-wrap "code")) :code-wrap)

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

# TODO: error handling are bad here
(defn translate "Parse and render a typeup string to the specified target" [input target]
  (string/join (or (peg/match (grammar target) (string input "\n")) (error "no match"))))

(defn main [&] (do
                 (def buf @"")
                 (file/read stdin :all buf)
                 (prin (translate buf (get (dyn :args) 0)))))
