#!/bin/janet

(import ./grammar :prefix "")
(import ./html)
(import ./md)
(import ./meta)
(import isatty)

# Prepares a document, stripping leading and trailing whitespace from lines and adding a trailing newline
(defn prepare [s]
  (string (string/join (map (fn [line] (string/trim line)) (string/split "\n" s)) "\n") "\n"))

(defn parse- [s] (do
                   (def ast (peg/match document (prepare s)))
                   [(meta/find-meta ast) ast]))

(defn main [&] (do
                 (def buf @"")
                 (if (isatty/isatty? stdin)
                   (eprintf "%s: reading from stdin..." (or (dyn :executable) "<unknown executable path>")))
                 (file/read stdin :all buf)
                 (def fun
                   (match (string/split "." (or (get (dyn :args) 1) "html"))
                     ["html"] html/render
                     ["ast"] (fn [meta ast] (string/format "%.50M" ast))

                     ["md"] md/render
                     ["meta"] (fn [meta ast] (string/format "%.50M" meta))
                     ["meta" key] (fn [meta ast] (get meta key))
                     (errorf "Output format not found: %s" (get (dyn :args) 1))))
                 (print (fun ;(parse- buf)))))
