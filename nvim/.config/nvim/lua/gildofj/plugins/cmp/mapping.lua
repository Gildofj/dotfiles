local cmp = require("cmp")
local luasnip = require("luasnip")

local has_ghost_text = function()
  return not cmp.visible() and cmp.get_active_entry()
end

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return cmp.mapping.preset.insert({
  ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehaviorInsert }), -- previous suggestion
  ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehaviorInsert }), -- next suggestion
  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
  ["<C-e>"] = cmp.mapping.abort(), -- close completion window
  ["<CR>"] = cmp.mapping.confirm(),
  ["<S-CR>"] = function(fallback)
    cmp.abort()
    fallback()
  end,
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif has_ghost_text() then
      cmp.confirm({ select = true })
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump(1)
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { "i", "s" }),
  -- ["<S-Tab>"] = cmp.mapping(function(fallback)
  --   if cmp.visible() then
  --     cmp.select_prev_item()
  --   elseif luasnip.expand_or_jumpable() then
  --     luasnip.expand_or_jump(-1)
  --   end
  -- end),
  ["<S-Tab>"] = nil, -- Disable Shift+Tab because conflict with Gemini autocomplete command
})
