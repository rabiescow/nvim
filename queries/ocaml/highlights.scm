; Modules
;--------
([
  (module_name)
  (module_type_name)
] )

(open_module (#set! priority 105)) @keyword.module.open

(open_module
  module: (module_path
    (module_name)  @keyword.module.name))

(application_expression
  function: (value_path
    (module_path
      (module_name (#set! priority 145)) @keyword.module.name)
  ))

; Types
;------
((type_constructor) @type.builtin
  (#any-of? @type.builtin
    "int" "char" "bytes" "string" "float" "bool" "unit" "exn" "array" "list" "option" "int32"
    "int64" "nativeint" "format6" "lazy_t")  (#set! priority 131))

([
  (class_name)
  (class_type_name)
  (type_constructor)
] @type )

[
  (constructor_name)
  (tag)
] @constructor

; Variables
;----------
[
  (value_name)
  (type_variable)
] @variable

(value_pattern (#set! priority 130)) @variable.parameter

((value_pattern) @character.special
  (#eq? @character.special "_"))

; Functions
;----------

(let_binding
  pattern: (value_name) @function
  (parameter) )

(let_binding
  pattern: (value_name) @function
  body: [
    (fun_expression)
    (function_expression)
  ])

(value_specification
  (value_name) @function)

(external
  (value_name) @function)

(method_name) @function.method

; Application
;------------
(infix_expression
  left: (value_path
    (value_name) @function.call)
  operator: (concat_operator) @_operator
  (#eq? @_operator "@@"))

(infix_expression
  operator: (rel_operator) @_operator
  right: (value_path
    (value_name) @function.call)
  (#eq? @_operator "|>"))

((value_name) @function.builtin
  (#any-of? @function.builtin "raise" "raise_notrace" "failwith" "invalid_arg"))

; Fields
;-------
[
  (field_name)
  (instance_variable_name)
] @variable.member

; Labels
; ------
(label_name) @label

; Constants
;----------
; Don't let normal parens take priority over this
((unit) @constant.builtin
  (#set! priority 105))

(boolean) @boolean

[
  (number)
  (signed_number)
] @number

(character) @character

(string) @string

(quoted_string
  "{" @string
  "}" @string) @string

(escape_sequence) @string.escape

[
  (conversion_specification)
  (pretty_printing_indication)
] @string.special

; Arguments
(application_expression
  argument: (labeled_argument
    (label_name) @function.argument.name
    (#set! priority 130)))

(application_expression
  argument: (labeled_argument
  (label_name)
  expression: (parenthesized_expression) @function.argument.func
  (#set! priority 130)))

(application_expression
  argument: (labeled_argument
    (label_name)
  expression: (value_path) @function.argument.func
  (#set! priority 130)))

; Keywords
;---------
[
  "and"
  "as"
  "assert"
  "begin"
  "constraint"
  "end"
  "external"
  "in"
  "inherit"
  "initializer"
  "match"
  "method"
  "module"
  "new"
  "of"
  "sig"
  "val"
  "when"
  "with"
] @keyword

[
  "object"
  "class"
  "struct"
  "type"
] @keyword.type

[
  "lazy"
  "mutable"
  "nonrec"
  "rec"
  "private"
  "virtual"
] @keyword.modifier

([
  "fun"
  "function"
  "functor"
  "let"
] @keyword.function (#set! priority 130))

[
  "if"
  "then"
  "else"
] @keyword.conditional

[
  "exception"
  "try"
] @keyword.exception

[
  "include"
  "open"
] @keyword.import

[
  "for"
  "to"
  "downto"
  "while"
  "do"
  "done"
] @keyword.repeat

; Punctuation
;------------
(attribute
  [
    "[@"
    "]"
  ] @punctuation.special)

((attribute
  (attribute_id) @attribute.method
  (attribute_payload) @attribute.name) @attribute.ppx (#set! priority 130))

(item_attribute
  [
    "[@@"
    "]"
  ] @punctuation.special (#set! priority 130))

((item_attribute
  (attribute_id) @attribute.method
  (attribute_payload) @attribute.name) @attribute.ppx (#set! priority 130))

(floating_attribute
  [
    "[@@@"
    "]"
  ] @punctuation.special)

((floating_attribute
  (attribute_id) @attribute.method
  (attribute_payload) @attribute.name) @attribute.ppx)

(extension
  [
    "[%"
    "]"
  ] @punctuation.special (#set! priority 133))

((extension
  (attribute_id) @attribute.method
  (attribute_payload) @attribute.name) @attribute.ppx (#set! priority 132))

(item_extension
  [
    "[%%"
    "]"
  ] @punctuation.special)

(item_extension
  (attribute_id) @attribute.method
  (attribute_payload) @attribute.name) @attribute.ppx

(quoted_extension
  [
    "{%"
    "}"
  ] @punctuation.special)

(quoted_item_extension
  [
    "{%%"
    "}"
  ] @punctuation.special)

"%" @punctuation.special

([
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "[@"
  "[@@"
  "[@@@"
  "[|"
  "|]"
  "[<"
  "[>"
] (#set! priority 131) ) @punctuation.bracket

((object_type
  [
    "<"
    ">"
  ] (#set! priority 131) ) @punctuation.bracket)

([
  ","
  "."
  ";"
  ":"
  "="
  "|"
  "~"
  "?"
  "+"
  "-"
  "!"
  ">"
  "&"
  "->"
  ";;"
  ":>"
  "+="
  ":="
  ".."
] (#set! priority 131)) @punctuation.delimiter

(range_pattern
  ".." @character.special)

; Operators
;----------
([
  (prefix_operator)
  (sign_operator)
  (pow_operator)
  (mult_operator)
  (add_operator)
  (concat_operator)
  (rel_operator)
  (and_operator)
  (or_operator)
  (assign_operator)
  (hash_operator)
  (indexing_operator)
  (let_operator)
  (and_operator)
  (match_operator)
] @operator )


(match_expression
  (match_operator) @keyword)

(value_definition
  [
    (let_operator)
    (let_and_operator)
  ] @keyword)

[
  "*"
  "#"
  "::"
  "<-"
] @operator

; Attributes
;-----------
(attribute_id) @attribute

; Comments
;---------
[
  (comment)
  (line_number_directive)
  (directive)
] @comment @spell

(shebang) @keyword.directive
