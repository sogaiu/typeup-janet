# typeup - a markup language for typists
# Goals

Markdown is pretty hard to write, for a variety of reasons

+ Each item of a list has to be prefixed which makes them harder to type, and nesting means tabbing which can be tedious to do manually.
+ Bold requires wrapping text with 2 characters on each side
+ Shift usage isn't considered. I'd rather not type shift and stay in the home row

Because of this, typeup departs from markdown in some ways

However, typeup is pragmatic. For some elements, it offers markdown alongside its new format, because it's better for some purposes. Sometimes, it keeps markdown's elements

# Syntax

A walkthrough of the syntax is provided in [example.tup](https://git.sr.ht/~skuzzymiglet/typeup/tree/master/item/example.tup). Notable elements are:

+ Lists are bracketed rather than using line prefixes. This makes them trivial to type and nest
+ Bold and italic can be done without using Shift
+ Metadata is built in
+ Typeup can be extended infinitely using custom blocks, whose content is passed to a function or a program and then substituted with the output

# Status

typeup is a work-in-progress project. I'm writing, unoptimized parser in Janet using the PEG module (work in progress, can render some elements to HTML). [Karitham](https://github.com/Karitham) is working on a [parser](https://github.com/Karitham/typeup) in Rust (WIP).

If you want to join in, tell me. My contact details are at [skuz.xyz](https://skuz.xyz/)
