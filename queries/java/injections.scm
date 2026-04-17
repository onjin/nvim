([
  (block_comment)
  (line_comment)
] @injection.content
  (#set! injection.language "comment"))

((block_comment) @injection.content
  (#lua-match? @injection.content "/[*][*][%s]")
  (#set! injection.language "javadoc"))

; markdown-style javadocs https://openjdk.org/jeps/467
((line_comment) @injection.content
  (#lua-match? @injection.content "^///%s")
  (#set! injection.language "javadoc"))

((method_invocation
  name: (identifier) @_method
  arguments: (argument_list
    .
    (string_literal
      .
      (_) @injection.content)))
  (#any-of? @_method "format" "printf")
  (#set! injection.language "printf"))

((method_invocation
  object: (string_literal
    (string_fragment) @injection.content)
  name: (identifier) @_method)
  (#eq? @_method "formatted")
  (#set! injection.language "printf"))

((block
   (line_comment) @_comment
   (local_variable_declaration
     (variable_declarator
       value: (string_literal
         [
           (string_fragment)
           (multiline_string_fragment)
         ] @injection.content))))
  (#eq? @_comment "// language=json")
  (#set! injection.language "json")
  (#set! injection.combined))

((block
   (block_comment) @_comment
   (local_variable_declaration
     (variable_declarator
       value: (string_literal
         [
           (string_fragment)
           (multiline_string_fragment)
         ] @injection.content))))
  (#eq? @_comment "/* language=json */")
  (#set! injection.language "json")
  (#set! injection.combined))

((block
   (line_comment) @_comment
   (local_variable_declaration
     (variable_declarator
       value: (method_invocation
         arguments: (argument_list
           .
           (string_literal
             [
               (string_fragment)
               (multiline_string_fragment)
             ] @injection.content))))))
  (#eq? @_comment "// language=json")
  (#set! injection.language "json")
  (#set! injection.combined))

((block
   (block_comment) @_comment
   (local_variable_declaration
     (variable_declarator
       value: (method_invocation
         arguments: (argument_list
           .
           (string_literal
             [
               (string_fragment)
               (multiline_string_fragment)
             ] @injection.content))))))
  (#eq? @_comment "/* language=json */")
  (#set! injection.language "json")
  (#set! injection.combined))

((block
   (line_comment) @_comment
   (expression_statement
     (assignment_expression
       right: (string_literal
         [
           (string_fragment)
           (multiline_string_fragment)
         ] @injection.content))))
  (#eq? @_comment "// language=json")
  (#set! injection.language "json")
  (#set! injection.combined))

((block
   (block_comment) @_comment
   (expression_statement
     (assignment_expression
       right: (string_literal
         [
           (string_fragment)
           (multiline_string_fragment)
         ] @injection.content))))
  (#eq? @_comment "/* language=json */")
  (#set! injection.language "json")
  (#set! injection.combined))
