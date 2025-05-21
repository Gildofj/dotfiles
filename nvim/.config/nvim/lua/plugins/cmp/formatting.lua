local lspkind = require("lspkind")

return {
  format = function(entry, vim_item)
    local source_names = {
      nvim_lsp = "[LSP]",
      nvim_lua = "[Lua]",
      luasnip = "[Snip]",
      buffer = "[Buf]",
      path = "[Path]",
      emoji = "[Emoji]",
      calc = "[Calc]",
    }

    vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol_text" })
    vim_item.menu = source_names[entry.source.name]
    vim_item.abbr = string.sub(vim_item.abbr, 1, 80)
    return vim_item
  end,
}
