local ls = require 'luasnip'
local extras = require 'luasnip.extras'
local fmt = require ('luasnip.extras.fmt').fmt
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = extras.rep
-- local lambda = extras.lambda

ls.add_snippets('c', {
  s('ifndef', fmt([[
  #ifndef {}
  #define {}

  {}

  #endif /* {} */
  ]], {i(1), rep(1), i(2), rep(1)})
  ),

  s('struct', fmt([[
  struct {} {{
    {}
  }};
  ]], {i(1), i(2)})),

  s('typedef struct', fmt([[
  typedef struct {} {{
    {}
  }} {};
  ]], {i(1), i(2), rep(1)}))
})

