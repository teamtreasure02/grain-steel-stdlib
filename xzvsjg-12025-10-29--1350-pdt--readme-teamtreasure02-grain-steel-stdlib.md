# grain-steel-stdlib - missing scheme functions for steel

**team**: teamtreasure02 (taurus ♉ - building blocks)  
**purpose**: provide missing standard library functions for steel, prepare upstream prs  
**status**: initial implementation, ready for community contribution! ⚒️

---

## what is this?

hey, steel is a rust-hosted scheme implementation. it's awesome! but it's also young, so some standard scheme functions aren't implemented yet.

**this repo provides those missing functions** so you can write scheme-style code in steel TODAY, while we prepare pull requests to add them to steel's core library.

---

## functions provided

**list operations:**
- `andmap` - apply predicate to all items, return true if all pass ✅
- `ormap` - apply predicate to all items, return true if any pass ✅

**string operations:**
- `string-trim` - remove whitespace from both ends ✅
- `string-trim-left` - remove whitespace from left ✅
- `string-trim-right` - remove whitespace from right ✅
- `string-split` - split string by delimiter ✅
- `string-join` - join list of strings with separator ✅
- `string-upcase` - convert to uppercase ✅
- `string-downcase` - convert to lowercase ✅
- `string-starts-with?` - check if string starts with prefix ✅
- `string-ends-with?` - check if string ends with suffix ✅
- `string-replace` - replace all occurrences ✅

(all functions include glow g2 teaching comments!)

---

## usage

```steel
;; list operations
(require "grain-steel-stdlib/andmap.scm")
(require "grain-steel-stdlib/ormap.scm")

(andmap positive? '(1 2 3 4))  ; => #t (all positive!)
(andmap positive? '(1 -2 3 4)) ; => #f (not all positive)
(ormap even? '(1 3 5 6 7))     ; => #t (6 is even!)
(ormap even? '(1 3 5 7))       ; => #f (all odd)

;; string operations
(require "grain-steel-stdlib/steel-strings.scm")

(string-trim "  hello  ")           ; => "hello"
(string-split "a,b,c" #\,)          ; => ("a" "b" "c")
(string-join '("a" "b" "c") ",")    ; => "a,b,c"
(string-upcase "hello")             ; => "HELLO"
```

---

## contributing upstream

once these are battle-tested in grain network, we'll prepare prs for steel's core library!

**goal**: help the whole steel community! ⚒️

---

now == next + 1 🌾

