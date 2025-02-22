local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets('cs', {
  s('cwl', {
    t('Console.WriteLine('),
    i(1),
    t(');')
  }),
})
