#!/bin/janet

(defn- blockquote [s] (string "<blockquote>" (string/trim s) "</blockquote>"))

(defn- title [hashes & s] (string/format "<h%d>%s</h%d>" (length hashes) (string/trim (string/join s)) (length hashes)))

(defn- bold [& s] (string/format "<b>%s</b>" (string/join s)))
(defn- italic [& s] (string/format "<i>%s</i>" (string/join s)))
(defn- paragraph [& s] (string/format "<p>%s</p>" (string/join s " ")))
(defn- ul [& s] (string/format "<ul>%s</ul>" (string/join s)))
(defn- ol [& s] (string/format "<ol>%s</ol>" (string/join s)))
(defn- li [& s] (string/format "<li>%s</li>" (string/join s)))
(defn- code [& s] (string/format "<code>%s</code>" (string/join s)))
(defn- pre-code [& s] (string/format "<pre><code>%s</code></pre>" (string/join s "\n")))

(def- grammar ~{:nl (+ "\n" "\r" "\r\n")
                :char (if-not :nl 1)
                :chars (some :char)

                # BUG: this causes matching to stop on encontering these chars
                :normalchar (if-not (choice :nl "=" "/" "`") 1)
                :normaltext (some :normalchar)
                :styling (choice :code :italic :bold)
                :text (some (choice :styling (capture :normaltext)))

                :in-bold (if (some (if-not "=" 1)) :text)
                :bold (* "==" (cmt :in-bold ,bold) "==")

                :in-italic (if (some (if-not "/" 1)) :text)
                :italic (* "//" (cmt :in-italic ,italic) "//")

                :in-code (if (some (if-not "`" 1)) :text)
                :code (* "`" (cmt :in-code ,code) "`")

                :pre-code (* "```\n" (cmt (some (* (capture :normaltext) "\n")) ,pre-code) "```")

                :hashes (between 1 6 "#")
                :title (cmt (* (capture :hashes) :text) ,title)

                :quote (cmt (* "|" (capture :chars)) ,blockquote)
                :hr (replace (at-least 2 "-") "<hr>")

                :paragraph (cmt (some (* (cmt :text ,string) "\n")) ,paragraph)

                :li (* (choice :list (cmt (some (if-not (choice :nl (set "[]{}")) :text)) ,li) "") :nl)
                :ul (* "[" (? "\n") (cmt (some :li) ,ul) "]")
                :ol (* "{" (? "\n") (cmt (some :li) ,ol) "}")
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
