; extends

((block_mapping_pair
  value: [
    (block_node
      (block_scalar) @_value)
    (flow_node
      [
        (plain_scalar
          (string_scalar) @_value)
        (double_quote_scalar) @_value
      ])
  ]
  (#lua-match? @_value "${{")) @injection.content
  (#is-gh-actions-file? "")
  (#set! injection.language "gh_actions_expressions")
  (#set! injection.include-children))

((block_mapping_pair
  key: (flow_node) @_key
  (#eq? @_key "if")
  value: (flow_node
    (plain_scalar
      (string_scalar) @_value)
    (#not-lua-match? @_value "${{"))) @injection.content
  (#is-gh-actions-file? "")
  (#set! injection.language "gh_actions_expressions")
  (#set! injection.include-children))
