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

    local icons = Core.icons.kinds
    if icons[item.kind] then
      item.kind = icons[item.kind] .. " " .. item.kind
    end

    item.menu = source_names[entry.source.name]
    item.abbr = string.sub(item.abbr, 1, 80)

    return item
  end,
}
