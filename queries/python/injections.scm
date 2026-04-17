(call
  function: (attribute
    object: (identifier) @_re)
  arguments: (argument_list
    (string
      (string_content) @injection.content))
  (#eq? @_re "re")
  (#set! injection.language "regex"))

(call
  function: (attribute
    object: (identifier) @_re)
  arguments: (argument_list
    (concatenated_string
      [
        (string
          (string_content) @injection.content)
        (comment)
      ]+))
  (#eq? @_re "re")
  (#set! injection.language "regex"))

((binary_operator
  left: (string
    (string_content) @injection.content)
  operator: "%")
  (#set! injection.language "printf"))

((comment) @injection.content
  (#set! injection.language "comment"))

((module
   (comment) @_comment
   (expression_statement
     (assignment
       right: (string
         (string_content) @injection.content))))
  (#eq? @_comment "# language=json")
  (#set! injection.language "json"))

((block
   (comment) @_comment
   (expression_statement
     (assignment
       right: (string
         (string_content) @injection.content))))
  (#eq? @_comment "# language=json")
  (#set! injection.language "json"))
