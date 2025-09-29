(boolean) @boolean

(null) @constant.builtin

[
  (number)
  (format_index)
] @number

[
  (string)
  (format_string)
] @string

(format_variable
  [
    "{"
    "}"
  ] @punctuation.special)

(scape_sequence) @string.escape

; NOTE: higher priority is applied in order to override injection's highlighting
; of `regex` and `bash` parsers
(context
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "github" "env" "vars" "job" "jobs" "steps" "runner" "secrets" "strategy" "matrix" "needs"
    "inputs")
  (#set! priority 110))

(property
  [
    (identifier)
    (asterisk)
  ] @variable.member
  (#set! priority 110))

((property_deref) @punctuation.delimiter
  (#set! priority 110))

(index) @punctuation.delimiter

(function_call
  function: (identifier) @function)

(function_call
  [
    "("
    ")"
  ] @punctuation.bracket)

"," @punctuation.delimiter

(delimited_expression
  [
    "${{"
    "}}"
  ] @punctuation.bracket
  (#set! priority 110))

(logical_group
  [
    "("
    ")"
  ] @punctuation.bracket)

[
  (operator)
  (not)
] @operator
