#!/bin/janet

(defn- title [hashes & s] (string/format "<h%d>%s</h%d>" (length hashes) (string/trim (string/join s)) (length hashes)))

# TODO these functions can all become a function that returns a function

(defn- html-wrap [tag] (fn [& s] (string "<" tag ">" (string/join s) "</" tag ">")))
(defn- paragraph [& s] (string/format "<p>%s</p>" (string/join s " ")))
(defn- pre-code [& s] (string/format "<pre><code>%s</code></pre>" (string/join s "\n")))

(def- grammar ~{:nl (+ "\n" "\r" "\r\n")
                :char (if-not :nl 1)
                :chars (some :char)

                # TODO variableize opening/close chars
                :normalchar (if-not (choice :nl "==" "//" "`") 1)
                :normaltext (some :normalchar)
                :styling (choice :code :italic :bold)
                :text (some (choice :styling (capture :normaltext)))

                :in-bold (if (some (if-not "==" 1)) :text)
                # TODO cmt -> replace for cleaner code
                :bold (* "==" (cmt :in-bold ,(html-wrap "b")) "==")

                # TODO these are repetitive
                :in-italic (if (some (if-not "//" 1)) :text)
                :italic (* "//" (cmt :in-italic ,(html-wrap "i")) "//")

                :in-code (if (some (if-not "``" 1)) :text)
                :code (* "`" (cmt :in-code ,(html-wrap "code")) "`")

                :pre-code (* "```\n" (cmt (some (* (capture :normaltext) "\n")) ,pre-code) "```")

                :hashes (between 1 6 "#")
                :title (cmt (* (capture :hashes) :text) ,title)

                :quote (cmt (* "|" (capture :chars)) ,(html-wrap "blockquote"))
                :hr (replace (at-least 2 "-") "<hr>")

                :paragraph (cmt (some (* (cmt :text ,string) "\n")) ,paragraph)

                :li (* (choice :list (cmt (some (if-not (choice :nl (set "[]{}")) :text)) ,(html-wrap "li")) "") :nl)
                :ul (* "[" (? "\n") (cmt (some :li) ,(html-wrap "ul")) "]")
                :ol (* "{" (? "\n") (cmt (some :li) ,(html-wrap "ol")) "}")
                :list (choice :ol :ul)

                :line (choice :title :quote :hr "")
                :element (choice :pre-code :list (* :line "\n") :paragraph)
                :main (some :element)})

# TODO: error handling are bad here
(defn html "Parse and render a typeup string to HTML" [s]
  (string/join (or (peg/match grammar (string s "\n")) (error "no match"))))

(defn main [&] (do 
                 (def buf @"")
                 (file/read stdin :all buf)
                 (prin (html buf))))
