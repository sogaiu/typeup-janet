(use ./grammar)
(import ./html)
(import ./md)
(import ./meta)
(import ./prepare)

(defn parse- [s]
  (def ast (peg/match document (prepare/prepare s)))
  [(meta/find-meta ast) ast])
