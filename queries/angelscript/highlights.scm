
; Highlights

(comment) @comment
(reciever (variable_access (identifier)) (#set! priority 98)) @keyword.class
((if_statement) @keyword.conditional
    condition: (parenthesized_expression)
    consequence: (compound_statement))

[name: (identifier)] @function.call
[function: (_)] @function
[index: (_)] @operator.index
([argument: (_ (identifier))] @variable.argument (#set! priority 103))
[field: (field_identifier)] @type.parameter
[parameters: (parameter_list)] @variable.parameter

((ERROR (identifier)) @function.call (#set! priority 103))
(escape_sequence) @punctuation.escape
(string_literal) @string.literal

((identifier) @variable (#set! priority 95))
; (variable_definition (type (datatype))) @variable.name
; (variable_access (identifier) (#set! priority 95)) @variable.type

[
  (true)
  (false)
] @boolean

[
  "default"
] @keyword

[
  "typedef"
] @keyword.type

"return" @keyword.return

[
  "while"
  "for"
  "do"
  "continue"
  "break"
] @keyword.repeat

[
  "is"
  "and"
  "or"
  "if"
  "else"
  "case"
  "switch"
] @keyword.conditional

[
  ";"
  ":"
  ","
  "."
] @punctuation.delimiter

[
  "::"
@punctuation.separator (#set! priority 105)]

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  "="
  "-"
  "*"
  "/"
  "+"
  "%"
  "~"
  "|"
  "&"
  "^"
  "<<"
  ">>"
  "<"
  "<="
  ">="
  ">"
  "=="
  "!="
  "!"
  "&&"
  "||"
  "-="
  "+="
  "*="
  "/="
  "%="
  "|="
  "&="
  "^="
  ">>="
  "<<="
  "--"
  "++"
] @operator

(comma_expression
  "," @operator)

(string_literal) @string

(escape_sequence) @string.escape

(null) @constant.builtin

(number_literal) @number

[(variable_definition
  ((type (_)) @type.builtin (#set! priority 103))
  ((identifier) @variable.name (#set! priority 103))
    ((_) @property (#set! priority 103)))]

[(variable_definition
  ((type (_)) @type.builtin (#set! priority 104))
  ((identifier) @variable.name (#set! priority 104))
  (field_expression
     argument: ((_) @variable.module (#set! priority 104))
     field: ((_) @type.parameter (#set! priority 104))))]

[(expression_statement
  (assignment_expression
    [left: ((_) @variable.name (#set! priority 104))]
    [right: ((_) @property (#set! priority 104))]))]

(type (datatype)) @type.builtin
((type (datatype (identifier))) (#set! priority 103)) @type.builtin
((type (datatype (primative_type))) (#set! priority 103)) @type.builtin
((primative_type) (#set! priority 103)) @type.builtin

[(binary_expression
    left: ((_) @variable.binary (#set! priority 102))
    right: ((_) @variable.binary (#set! priority 102)))]

(argument
value: (variable_access
  (identifier)) (#set! priority 105)) @variable.argument
