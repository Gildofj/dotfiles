return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp", "nvim-treesitter/nvim-treesitter" },
  opts = {
    check_ts = true,
    ts_config = {
      lua = { "string" },
      javascript = { "template_string" },
      java = false,
    },
  },
  config = function(_, opts)
    local autopairs = require("nvim-autopairs")
    local ts_conds = require("nvim-autopairs.ts-conds")
    local Rule = require("nvim-autopairs.rule")

    autopairs.setup(opts)
    autopairs.add_rules({
      Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
      Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
    })

    -- integração com nvim-cmp
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    local ts_utils = require("nvim-treesitter.ts_utils")

    -- Detecta se o cursor está dentro de um nó JSX (ex: <MyComponent />)
    local function in_jsx()
      local node = ts_utils.get_node_at_cursor()
      while node do
        if node:type():match("jsx") then
          return true
        end
        node = node:parent()
      end
      return false
    end

    cmp.event:on("confirm_done", function(event)
      local entry = event.entry
      local item = entry:get_completion_item()
      -- Verifica se é Function ou Method e se está em JSX
      if (item.kind == 3 or item.kind == 2) and in_jsx() then
        return
      end

      cmp_autopairs.on_confirm_done()(event)
    end)
  end,
}
