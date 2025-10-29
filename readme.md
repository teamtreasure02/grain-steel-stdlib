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

**currently implemented:**
- `andmap` - apply predicate to all items, return true if all pass ✅

**planned (coming soon!):**
- `ormap` - apply predicate to all items, return true if any pass
- additional string utilities as needed by grain network

(note: string-trim, string-split, string-join already exist in teamtreasure02/grainorder/steel-strings.scm - we may move them here for community use!)

---

## usage

```steel
(require "grain-steel-stdlib/andmap.scm")

(andmap positive? '(1 2 3 4))  ; => #t
(andmap positive? '(1 -2 3 4)) ; => #f
```

---

## contributing upstream

once these are battle-tested in grain network, we'll prepare prs for steel's core library!

**goal**: help the whole steel community! ⚒️

---

now == next + 1 🌾

