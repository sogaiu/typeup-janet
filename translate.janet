#!/bin/janet

(import ./grammar :prefix "")
(import ./html)
(import ./print-ast)
(import ./tree)
(import ./md)
(import isatty)

(def render-functions {"html" html/render
                       "ast" print-ast/render
                       "tree" (partial tree/render -1)
                       "md" md/render})

(defn main [&] (do
                 (def buf @"")
                 (if (isatty/isatty? stdin)
                   (eprintf "%s: reading from stdin..." (or (dyn :executable) "<unknown executable path>")))
                 (file/read stdin :all buf)
                 (print ((get render-functions (or (get (dyn :args) 1) "html")) (peg/match document (string buf "\n"))))))
