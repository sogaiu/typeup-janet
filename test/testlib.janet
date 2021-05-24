# TODO: passed/failed reporting

(defmacro test [desc & body]
  ~(do (printf "== %s ==" ,desc)
     ,;body))

(defmacro testv [desc & body]
  ~(do (printf "== %s: %j ==" ,desc '(do ,;body))
     ,;body))

(defmacro assertv= [x y]
  ~(do
     (if (deep= ,x ,y)
       (printf "✅  %j == %j" ',x ',y)
       (do
         (print "Evaluation:")
         (printf "\t%j -> %j\n\t%j -> %j" ',x ,x ',y ,y)
         (printf "Results:\n\t%j\n\t%j" ,x ,y)
         (if (dyn :assertv=-error)
           (error "Assertion failed"))))))

# (testv "single-line metadata" (pp "test"))
# (assertv= (= 2 2) true)

# TODO: error tests
# TODO: options - show function each time, hide success, exit on failiure, etc
(defmacro on-function [f tests]
  (def grouped
    (seq [c :range [0 (length tests) 3]] {:desc (get tests c) :args (get tests (+ c 1)) :expect (get tests (+ c 2))}))
  (def max-desc-width (max ;(map (fn [x] (length (get x :desc))) grouped)))
  (if (not= (% (length tests) 3) 0)
    (error "Length of tests array not divisible by 3"))
  ~(do

     (printf "== TESTING FUNCTION: %j" ',f)
     (loop [c :range [0 (length ,tests) 3]]
       (def desc (get ,tests c))
       (def expect (get ,tests (+ c 2)))
       (def args (get ,tests (+ c 1)))
       (def result (,f ;args))
       (def spaces (string/repeat " " (- ,max-desc-width (length desc))))

       (if (deep= expect result)
         (do
         (if (dyn :test-show-success)
           (printf "%s%s | ✅ %j -> %j == %j" spaces desc ['f ;args] result expect)))
         (do
           (if (dyn :on-function-assertv=)
             (do
               (print "===============")
               (printf "%s\t ❌ %j" desc ['f ;args])
               (assertv= expect result)
               (print "==============="))
             (do
               (def fmted (string/format "❌  %s ::: %j -> %j != %j" desc ['f ;args] result expect))
               (if (dyn :test-error-fail)
                 (error fmted)
                 (print fmted)))))))))

# (setdyn :on-function-assertv= true)
# (on-function flatten
#              ["table" [[:a :c [:b]]] @[:a :b]])

