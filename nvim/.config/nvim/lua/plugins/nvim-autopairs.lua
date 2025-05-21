return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  opts = function()
    local autopairs = require("nvim-autopairs")
    local ts_conds = require("nvim-autopairs.ts-conds")
    local Rule = require("nvim-autopairs.rule")

    autopairs.setup({
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    })

    autopairs.add_rules({
      Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
      Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
    })
  end,
  config = function(_, _)
    -- integração com nvim-cmp
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
