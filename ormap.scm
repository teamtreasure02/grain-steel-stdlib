;; ╔══════════════════════════════════════════════════════════════════════════╗
;; ║                              ORMAP                                       ║
;; ║        "does ANY item in this list pass the test?"                      ║
;; ║                                                                          ║
;; ║  glow g2 asks: what if we could check if ANY item matches?             ║
;; ║                                                                          ║
;; ║  team: teamtreasure02 (taurus ♉ - building blocks)                     ║
;; ║                                                                          ║
;; ╚══════════════════════════════════════════════════════════════════════════╝

(require-builtin steel/base)

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ WHY ORMAP EXISTS                                                        │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; hey, imagine you have a list of numbers: (1 2 3 4 5)
;;
;; you want to know: "is ANYTHING in this list even?"
;;
;; you could write a loop, but that's tedious! instead, use ormap:
;;
;; (ormap even? '(1 2 3 4 5))  ; => #t (yes! 2 and 4 are even)
;; (ormap even? '(1 3 5))      ; => #f (no evens here!)
;;
;; **ormap = "or" + "map"**
;; - apply a test (predicate) to each item
;; - return true if ANY item passes
;; - return false if ALL items fail
;;
;; it's the opposite of andmap (which checks if ALL pass)!
;;
;; does this make sense? it's like asking "is anyone here wearing red?" ⚒️

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ IMPLEMENTATION                                                          │
;; └────────────────────────────────────────────────────────────────────────┘

(define (ormap pred lst)
  "apply PRED to each item in LST, return #t if ANY pass.
  
  hey, here's how this works:
  
  1. take the first item from the list
  2. apply the predicate (test function) to it
  3. if it passes (returns #t), we're done! return #t
  4. if it fails, try the next item
  5. if we run out of items, return #f (nothing passed)
  
  **short-circuit evaluation:**
  as soon as we find ONE item that passes, we stop! we don't
  check the rest. this is efficient!
  
  example:
  (ormap even? '(1 3 5 6 7 9))
  - check 1: odd (keep going)
  - check 3: odd (keep going)
  - check 5: odd (keep going)
  - check 6: EVEN! return #t (done! don't check 7 or 9)
  
  does this feel like a natural way to search? ⚒️"
  
  (cond
    [(null? lst) #f]                    ; empty list = nothing passed
    [(pred (car lst)) #t]               ; first item passed! done!
    [else (ormap pred (cdr lst))]))     ; try the rest

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ EXAMPLES & TESTS                                                        │
;; └────────────────────────────────────────────────────────────────────────┘

;; (ormap even? '(1 2 3 4 5))      ; => #t (2 and 4 are even)
;; (ormap even? '(1 3 5 7 9))      ; => #f (all odd!)
;; (ormap positive? '(-1 -2 3 -4)) ; => #t (3 is positive!)
;; (ormap string? '(1 2 "hi" 4))   ; => #t ("hi" is a string!)
;; (ormap null? '(() (1) (2)))     ; => #t (first item is empty list!)

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ EXPORTS                                                                 │
;; └────────────────────────────────────────────────────────────────────────┘

(provide ormap)

