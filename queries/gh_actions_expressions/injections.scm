(function_call
  function: (identifier) @function
  (#eq? @function "fromJSON")
  arguments: (arguments
    .
    (string
      (string_content) @injection.content
      (#set! injection.language "json"))))

(function_call
  function: (identifier) @function
  (#eq? @function "hashFiles")
  arguments: (arguments
    (string
      (string_content) @injection.content
      (#set! injection.language "gitignore"))))
