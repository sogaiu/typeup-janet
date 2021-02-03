#!/bin/janet

(import "./example")

(defn blockquote [s] (string "<blockquote>" (string/trim s) "</blockquote>"))

(defn title [hashes s] (string/format "<h%d>%s</h%d>" (length hashes) (string/trim s) (length hashes)))

(defn bold [s] (string/format "<b>%s</b>" s))
(defn italic [s] (string/format "<i>%s</i>" s))

(def grammar ~{
               # basic units
               :nl (+ "\n" "\r" "\r\n")
               :chars (some (if-not :nl 1))

               # styling
               :inbold (some (if-not "=" 1))
               :bold (* "==" (cmt (capture :inbold) ,bold) "==")
               :initalic (some (if-not "/" 1))
               :italic (* "//" (cmt (capture :initalic) ,italic) "//")
               :styling (choice :italic :bold)

               # lines
               :hashes (between 1 6 "#")
               :title (cmt (* (capture :hashes) (capture :chars)) ,title)

               :quote (cmt (* "|" (capture :chars)) ,blockquote)
               :normalchar (if-not (choice :nl "=" "/") 1)
               :normaltext (some :normalchar)
               :text (some (choice :styling (capture :normaltext)))

               # main

               :line (* (choice :title :quote :text))
               :main (* (some (* :line (choice :nl -1))))})

(def example-text `# h1, which is cool
## h2
| yay
foo ==bar!==, //baz// and ==0x00==
| a quote
no trailing newline!!`)

(defn html [s] (string/join (peg/match grammar s)))
