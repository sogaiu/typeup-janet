#!/bin/janet

(import ./grammar :prefix "")
(import ./html)
(import ./md)
(import ./meta)
(import ./prepare)
(import isatty)
(import json)

(defn parse- [s]
  (def ast (peg/match document (prepare/prepare s)))
  [(meta/find-meta ast) ast])

(defn main [&]
  (def buf @"")
  (def fun
    (match (string/split "." (or (get (dyn :args) 1) "html"))
      ["html"] html/render
      ["ast"] (fn [meta ast] (string/format "%.50M" ast))

      ["md"] md/render
      ["meta" key] (fn [meta ast] (or (get meta key) (errorf "Metadata key not found: %s" key)))
      ["meta"] (fn [meta ast] (json/encode meta))
      (errorf "Output format not found: %s" (get (dyn :args) 1))))
  (if (isatty/isatty? stdin)
    (eprintf "%s: reading from stdin..." (or (dyn :executable) "<unknown executable path>")))
  (file/read stdin :all buf)
  (print (fun ;(parse- buf))))
