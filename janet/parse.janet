#!/bin/janet

(defn- blockquote [s] (string "<blockquote>" (string/trim s) "</blockquote>"))

(defn- title [hashes & s] (string/format "<h%d>%s</h%d>" (length hashes) (string/trim (string/join s)) (length hashes)))

(defn- bold [& s] (string/format "<b>%s</b>" (string/join s)))
(defn- italic [& s] (string/format "<i>%s</i>" (string/join s)))

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

               :line (choice :title :quote :hr :text "")
               :main (choice (* (some (* :line "\n")) :line) :line)})

(defn html [s] (string/join (or (peg/match grammar s) (error "no match"))))
