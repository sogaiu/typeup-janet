(defn map-indexed [f ds]
  (map f (range 0 (length ds)) ds))
