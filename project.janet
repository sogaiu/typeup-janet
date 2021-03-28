(declare-project
  :dependencies ["https://github.com/pyrmont/testament"
                 "https://github.com/nate/isatty"])

(declare-executable :name "tup" :entry "translate.janet" :install true)
