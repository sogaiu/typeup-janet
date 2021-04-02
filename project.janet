(declare-project
  :dependencies ["https://github.com/pyrmont/testament"
                 "https://github.com/nate/isatty"
                 "https://github.com/janet-lang/json"])

(declare-executable :name "tup" :entry "translate.janet" :install true)
