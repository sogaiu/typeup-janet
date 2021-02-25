#!/bin/janet

(import ./grammar :prefix "")

# TODO: error handling are bad here
(defn translate "Parse and render a typeup string to the specified target" [input target]
  (string/join (or (peg/match document (string input "\n")) (error "no match"))))

(defn main [&] (do
                 (def buf @"")
                 (file/read stdin :all buf)
                 (prin (translate buf (get (dyn :args) 0)))))
