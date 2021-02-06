#!/bin/janet

(defn- blockquote [s] (string "<blockquote>" (string/trim s) "</blockquote>"))

(defn- title [hashes & s] (string/format "<h%d>%s</h%d>" (length hashes) (string/trim (string/join s)) (length hashes)))

(defn- bold [& s] (string/format "<b>%s</b>" (string/join s)))
(defn- italic [& s] (string/format "<i>%s</i>" (string/join s)))
(defn- paragraph [& s] (string/format "<p>%s</p>" (string/join s " ")))
(defn- ul [& s] (string/format "<ul>%s</ul>" 
                               (string/join (map (fn [s] (string/format "<li>%s</li>" s)) s))))

(def- grammar ~{
               :nl (+ "\n" "\r" "\r\n")
               :char (if-not :nl 1)
               :chars (some :char)

               :normalchar (if-not (choice :nl "=" "/") 1)
               :normaltext (some :normalchar)
               :styling (choice :italic :bold)
               :text (some (choice :styling (capture :normaltext)))

               :inbold (if (some (if-not "=" 1)) :text)
               :bold (* "==" (cmt :inbold ,bold) "==")

               :initalic (if (some (if-not "/" 1)) :text)
               :italic (* "//" (cmt :initalic ,italic) "//")

               :hashes (between 1 6 "#")
               :title (cmt (* (capture :hashes) :text) ,title)

               :quote (cmt (* "|" (capture :chars)) ,blockquote)
               :hr (replace (at-least 2 "-") "<hr>")

               :paragraph (cmt (some (* :text "\n")) ,paragraph)

               :li (* (choice (some (if-not (choice :nl "]") :text)) "") :nl)
               :ul (* "[" (? "\n") (cmt (some :li) ,ul) "]")
               :list :ul

               :line (choice :title :quote :hr "")
               :element (choice :list (* :line "\n") :paragraph)
               :main (some :element)})

# TODO: errors are bad here
(defn html "Parse and render a typeup string to HTML" [s] 
  (string/join (or (peg/match grammar (string s "\n")) (error "no match"))))
