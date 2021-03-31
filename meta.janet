(defn find-meta [ast] (merge ;(filter (fn [x] (not= x nil)) (flatten (map
                        (fn [x]
                          (or (match x
                                [:set k v] {k v})
                              (if (= (type x) :tuple) (find-meta x)))) ast)))))
