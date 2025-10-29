;; ╔══════════════════════════════════════════════════════════════════════════╗
;; ║                          STEEL STRINGS                                   ║
;; ║            missing string functions for steel (scheme → python)          ║
;; ║                 "python's string power, lisp's elegance"                 ║
;; ║                                                                          ║
;; ║  glow g2 asks: what if steel had all the string tools python has?       ║
;; ║                                                                          ║
;; ║  phase 1: essential string operations (trim, split, join, case)         ║
;; ║  team: teamtreasure02 (taurus ♉ / VI. the lovers - building blocks)    ║
;; ║                                                                          ║
;; ╚══════════════════════════════════════════════════════════════════════════╝

(require-builtin steel/strings as strings-builtin)

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ WHY THIS MODULE EXISTS                                                  │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; hey, let's talk about why we need this. steel is amazing - it's scheme
;; running on rust! but it's still young, and some standard string functions
;; aren't implemented yet.
;;
;; you know how python has .strip(), .split(), .join()? or how scheme has
;; string-trim, string-split? steel is getting there, but right now we're
;; missing some pieces.
;;
;; this module fills the gaps! think of it as a compatibility layer - we
;; implement the missing functions in pure steel, using only what steel
;; already has.
;;
;; **what we're building:**
;; - string-trim (remove whitespace from ends)
;; - string-trim-left / string-trim-right
;; - string-split (split on delimiter)
;; - string-join (join list with delimiter)  
;; - string-starts-with? / string-ends-with?
;; - string-replace (replace all occurrences)
;; - string-upcase / string-downcase (if not built-in)
;;
;; **how we build it:**
;; using only steel's existing primitives:
;; - string->list / list->string (convert to work with chars)
;; - char? char=? char-whitespace? (character operations)
;; - map, filter, fold (functional transformations)
;;
;; does this make sense? we're bootstrapping the tools we need! 🌾

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ STRING TRIMMING - remove whitespace from ends                           │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; python: "  hello  ".strip() → "hello"
;; scheme: (string-trim "  hello  ") → "hello"
;; steel: let's build it!

(define (char-whitespace? c)
  "check if a character is whitespace (space, tab, newline, etc).
  
  why is this important? because trimming means removing these characters!
  
  whitespace characters:
  - space (32)
  - tab (9)
  - newline (10)
  - carriage return (13)
  
  does that cover most cases you'd want to trim?"
  
  (or (char=? c #\space)
      (char=? c #\tab)
      (char=? c #\newline)
      (char=? c #\return)))

(define (string-trim-left s)
  "remove whitespace from the LEFT side of a string.
  
  algorithm:
  1. convert string to list of characters
  2. drop characters while they're whitespace
  3. convert back to string
  
  example: '  hello' → 'hello'
  
  why start from the left? because that's the natural direction to read!"
  
  (list->string 
    (let loop ([chars (string->list s)])
      (cond
        [(null? chars) '()]
        [(char-whitespace? (car chars)) (loop (cdr chars))]
        [else chars]))))

(define (string-trim-right s)
  "remove whitespace from the RIGHT side of a string.
  
  algorithm:
  1. reverse the string
  2. trim from the left (which is really the right!)
  3. reverse back
  
  clever trick, right? why write the same logic twice?"
  
  (list->string 
    (reverse 
      (let loop ([chars (reverse (string->list s))])
        (cond
          [(null? chars) '()]
          [(char-whitespace? (car chars)) (loop (cdr chars))]
          [else chars])))))

(define (string-trim s)
  "remove whitespace from BOTH sides of a string.
  
  combines trim-left and trim-right!
  
  example: '  hello  ' → 'hello'
  
  why trim both sides? because that's what you usually want when cleaning
  up user input or parsing data!"
  
  (string-trim-right (string-trim-left s)))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ STRING SPLITTING - break string into parts                              │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; python: "a,b,c".split(",") → ["a", "b", "c"]
;; steel: let's make it happen!

(define (string-split s delimiter)
  "split a string on a delimiter character.
  
  example: (string-split \"hello-world\" #\\-) → (\"hello\" \"world\")
  
  algorithm:
  1. scan through string character by character
  2. accumulate characters into 'current part'
  3. when we hit delimiter, save current part and start new one
  4. return list of all parts
  
  why a character delimiter? because it's the simplest case to implement!
  for string delimiters, we'd need more complex matching."
  
  (let loop ([chars (string->list s)]
             [current '()]
             [result '()])
    (cond
      ;; end of string: save final part
      [(null? chars)
       (reverse (cons (list->string (reverse current)) result))]
      
      ;; found delimiter: save current part, start new one
      [(char=? (car chars) delimiter)
       (loop (cdr chars)
             '()
             (cons (list->string (reverse current)) result))]
      
      ;; regular character: add to current part
      [else
       (loop (cdr chars)
             (cons (car chars) current)
             result)])))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ STRING JOINING - combine list into string                               │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; python: ", ".join(["a", "b", "c"]) → "a, b, c"
;; the INVERSE of split!

(define (string-join strings delimiter)
  "join a list of strings with a delimiter.
  
  example: (string-join '('hello' 'world') ' ') → 'hello world'
  
  algorithm:
  1. if empty list, return empty string
  2. if one string, return it as-is
  3. otherwise: first string + delimiter + join rest
  
  this is a classic recursive pattern - does it feel natural?"
  
  (cond
    [(null? strings) ""]
    [(null? (cdr strings)) (car strings)]
    [else
     (string-append
       (car strings)
       (string delimiter)
       (string-join (cdr strings) delimiter))]))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ STRING PREDICATES - questions about strings                             │
;; └────────────────────────────────────────────────────────────────────────┘

(define (string-starts-with? s prefix)
  "check if string starts with a prefix.
  
  example: (string-starts-with? 'hello' 'he') → #t
  
  algorithm:
  1. check if prefix is longer than string (can't match!)
  2. extract first N characters of string (where N = prefix length)
  3. compare with prefix
  
  why not just use substring and string=? yep, that's exactly what we do!"
  
  (let ([s-len (string-length s)]
        [p-len (string-length prefix)])
    (and (>= s-len p-len)
         (string=? (substring s 0 p-len) prefix))))

(define (string-ends-with? s suffix)
  "check if string ends with a suffix.
  
  example: (string-ends-with? 'hello' 'lo') → #t
  
  algorithm:
  same as starts-with, but we extract from the END of the string!"
  
  (let ([s-len (string-length s)]
        [sf-len (string-length suffix)])
    (and (>= s-len sf-len)
         (string=? (substring s (- s-len sf-len) s-len) suffix))))

(define (string-contains? s substring)
  "check if string contains a substring anywhere.
  
  example: (string-contains? 'hello world' 'lo wo') → #t
  
  algorithm:
  try starting at each position - does it match?"
  
  (let ([s-len (string-length s)]
        [sub-len (string-length substring)])
    (let loop ([pos 0])
      (cond
        [(> (+ pos sub-len) s-len) #f]  ;; ran out of string
        [(string=? (substring s pos (+ pos sub-len)) substring) #t]  ;; match!
        [else (loop (+ pos 1))]))))  ;; try next position

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ STRING REPLACEMENT - find and replace                                   │
;; └────────────────────────────────────────────────────────────────────────┘

(define (string-replace s old new)
  "replace all occurrences of 'old' with 'new' in string.
  
  example: (string-replace 'hello hello' 'hello' 'hi') → 'hi hi'
  
  algorithm:
  1. scan through string
  2. when we find 'old', replace with 'new'
  3. otherwise keep character as-is
  
  this is simplified - for now only works with single-char replacement.
  full implementation would need substring matching!"
  
  ;; TODO: implement full substring replacement
  ;; for now: character-only version
  (if (and (= (string-length old) 1)
           (= (string-length new) 1))
      (let ([old-char (string-ref old 0)]
            [new-char (string-ref new 0)])
        (list->string
          (map (lambda (c)
                 (if (char=? c old-char) new-char c))
               (string->list s))))
      (error "string-replace: only single-character replacement supported for now")))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ CASE CONVERSION - upper/lower case                                      │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; steel might have these built-in, but let's provide them just in case!

(define (string-upcase s)
  "convert string to uppercase.
  
  example: (string-upcase 'hello') → 'HELLO'"
  
  (list->string (map char-upcase (string->list s))))

(define (string-downcase s)
  "convert string to lowercase.
  
  example: (string-downcase 'HELLO') → 'hello'"
  
  (list->string (map char-downcase (string->list s))))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ USAGE EXAMPLES                                                          │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; at the top of your steel file:
;;
;;   (require "steel-strings.scm")
;;
;; then use like python:
;;
;;   (string-trim "  hello  ")                    → "hello"
;;   (string-split "a,b,c" #\,)                   → ("a" "b" "c")
;;   (string-join '("hello" "world") " ")         → "hello world"
;;   (string-starts-with? "hello" "he")           → #t
;;   (string-contains? "hello world" "lo wo")     → #t
;;   (string-replace "hello" "l" "L")             → "heLLo"
;;
;; familiar? that's the goal! python-like ease, scheme elegance! 🌾

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ PHASE 1 COMPLETE!                                                      │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; what we built:
;; ✅ string-trim, string-trim-left, string-trim-right
;; ✅ string-split (character delimiter)
;; ✅ string-join
;; ✅ string-starts-with?, string-ends-with?, string-contains?
;; ✅ string-replace (single character)
;; ✅ string-upcase, string-downcase
;; ✅ glow g2 teaching comments throughout
;;
;; what's next (phase 2):
;; - string-split with string delimiters (not just char)
;; - string-replace with full substring support
;; - string-pad-left / string-pad-right
;; - string-repeat (repeat string N times)
;; - string-reverse
;; - string-index (find position of substring)
;; - regex support (via rust FFI?)
;;
;; does this give steel the string power it needs? ⚒️⚡
;;
;; now == next + 1 🌾

(displayln "\n╔════════════════════════════════════════════════════════════════════╗")
(displayln "║  STEEL STRINGS MODULE LOADED! ⚒️                                   ║")
(displayln "║  python-like string operations for steel                           ║")
(displayln "╚════════════════════════════════════════════════════════════════════╝\n")


