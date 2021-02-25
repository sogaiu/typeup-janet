(def test @[:h1 @[:bold @[:italic "bi"] "sexual"]])

(def html-rules 
  {
      :italic "<i>%s</i>"
      :bold "<b>%s</b>"
      :h1 "<h1>%s</h1>"
})

(defn html [ast]
  (or
    (and (= (type ast) :string) ast)
    (string/format (get html-rules (get ast 0)) (string/join (map html (array/slice ast 1 -1))))
    (error "html: invalid ast")))

(defn ms [ast] 
  (or
    (and (= (type ast) :string) ast)    
    (error "ms: invalid ast")
    ))

(defn term [ast]
  (or
    (and (= (type ast) :string) ast)
    (def rule (get ast 0))
    (def params (array/slice ast 1 -1))
    (pp rule)
    (case rule
      :bold (string "\e[1m" (map term params) "\e[0m")
      :italic (string "\e[3m" (map term params) "\e[0m")
      :h1 (string "===" (map term params) "===")
      (error "term: invalid ast"))))

(defn ms [ast] 
  (or
    (and (= (type ast) :string) ast)    
    (error "ms: invalid ast")
    ))

(pp (html test))
(pp (term test))
# (pp (ms test))
