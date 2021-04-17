(declare-project
  :dependencies ["https://github.com/nate/isatty"
                 "https://github.com/janet-lang/json"])

(declare-executable :name "typeup" :entry "main.janet" :install true)
