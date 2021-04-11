# XXX: I think there's a better way to do this
(defn map-indexed [f ds]
  (map f (range 0 (length ds)) ds))
