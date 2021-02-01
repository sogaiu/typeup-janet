#!/bin/janet

(import "./example")

(defn blockquote [s] (do
                       (string "<blockquote>" (string/trim s) "</blockquote>")))
(defn title [hashes s] (do
                         (string/format "<h%d>%s</h%d>" (length hashes) (string/trim s) (length hashes))))

(defn bold [s] (do
                 (string/format "<b>%s</b>" s)))

(def grammar ~{
               # basic units
               :chars (some (if-not "\n" 1))

               # styling
               :bold (* "==" (cmt (capture :chars) ,bold) "==")

               # lines
               :hashes (between 1 6 "#")
               :title (cmt (* (capture :hashes) (capture :chars)) ,title)

               :quote (cmt (* "|" (capture :chars)) ,blockquote)
               :text (some (choice :bold (capture :chars)))

               # main

               :line (* (choice :title :quote :text) "\n")
               :main (some :line)})

(def example-text `# h1, which is cool
## h2
| yay
==xyz= lol`)

(print (string/join (peg/match grammar example-text) "\n"))
