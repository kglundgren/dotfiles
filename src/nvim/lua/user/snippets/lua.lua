local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets('lua', {
  s('hello', {
    t("print('Hello, "),
    i(1),
    t("World!')")
  }),

  s('function', {
    t('function '),
    i(1),
    t('('),
    i(2),
    t(') '),
    i(3),
    t(' end')
  })
})

