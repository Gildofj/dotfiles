local lspkind = require("lspkind")

-- TODO: Use local icons
return {
  format = function(entry, item)
    local source_names = {
      nvim_lsp = "[LSP]",
      nvim_lua = "[Lua]",
      luasnip = "[Snip]",
      buffer = "[Buf]",
      path = "[Path]",
      emoji = "[Emoji]",
      calc = "[Calc]",
    }

    item.kind = lspkind.symbolic(item.kind, { mode = "symbol_text" })
    item.menu = source_names[entry.source.name]
    item.abbr = string.sub(item.abbr, 1, 80)
    return item
  end,
}
