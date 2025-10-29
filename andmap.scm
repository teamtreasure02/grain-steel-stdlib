;; ╔══════════════════════════════════════════════════════════════════════════╗
;; ║                           ANDMAP                                         ║
;; ║         "and" map - check if predicate is true for ALL items            ║
;; ║                                                                          ║
;; ║  glow g2 asks: what if we could check ALL at once? ⚒️                   ║
;; ║                                                                          ║
;; ║  team: teamtreasure02 (taurus ♉ - building the missing blocks)         ║
;; ║                                                                          ║
;; ╚══════════════════════════════════════════════════════════════════════════╝

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ WHY THIS EXISTS                                                         │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; hey, imagine you have a list of numbers and you want to check:
;; "are ALL of them positive?"
;;
;; in scheme, you'd use `andmap`:
;; (andmap positive? '(1 2 3 4))  => #t (yes, all positive!)
;; (andmap positive? '(1 -2 3))   => #f (no, -2 is negative!)
;;
;; but steel doesn't have `andmap` built-in yet! so we're adding it here.
;;
;; this function will eventually be contributed UPSTREAM to steel itself,
;; so everyone can benefit! ⚒️

(require-builtin steel/base)

(define (andmap pred lst)
  ;; check if predicate is true for ALL items in list
  ;;
  ;; hey, this is like asking "does everyone in the class pass the test?"
  ;; if even ONE person fails, the answer is no!
  ;;
  ;; returns #t if ALL items satisfy predicate
  ;; returns #f if ANY item doesn't satisfy predicate
  ;; returns #t for empty list (vacuous truth!)
  (or (null? lst)
      (and (pred (car lst))
           (andmap pred (cdr lst)))))

(provide andmap)

