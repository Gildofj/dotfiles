local cmp = require("cmp")

-- sources for autocompletion
return cmp.config.sources({
  { name = "nvim_lsp" }, -- LSP suggestions,
  { name = "nvim_lua" }, -- lua autocompletion,
  { name = "luasnip" }, -- snippets
  { name = "path" }, -- file system paths
}, {
  { name = "buffer" }, -- text within current buffer
  { name = "calc" }, -- calc results,
  { name = "emoji" }, -- emojis,
})
