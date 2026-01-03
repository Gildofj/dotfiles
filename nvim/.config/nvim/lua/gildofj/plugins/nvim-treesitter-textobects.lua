return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = "VeryLazy",
  opts = {
    select = {
      enable = true,
      -- Automatically jump foward to tetxobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can capture groups defined in textobjects.scm
        ["a="] = { query = "@assingment.outer", desc = "Select outer part of an assignment" },
        ["i="] = { query = "@assingment.inner", desc = "Select inner part of an assignment" },
        ["l="] = { query = "@assingment.lhs", desc = "Select left hand side of an assignment" },
        ["r="] = { query = "@assingment=rhs", desc = "Select right side of an assignment" },

        ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
        ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

        ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
        ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

        ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
        ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

        ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
        ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

        ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
        ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

        ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>na"] = "@parameter.inner", -- swap parameter/argument with next
        ["<leader>nm"] = "@function.outer", -- swap function with next
      },
      swap_previous = {
        ["<leader>pa"] = "@parameter.inner", -- swap parameter/argument with previous
        ["<leader>pm"] = "@function.outer", -- swap function with previous
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      -- LazyVim extention to create buffer-local keymaps
      keys = {
        goto_next_start = {
          ["]f"] = { query = "@call.outer", desc = "Next function call start" },
          ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
          ["]c"] = { query = "@class.outer", desc = "Next class start" },
          ["]i"] = { query = "@conditional.outer", desc = "Next conditional call start" },
          ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
        },
        goto_next_end = {
          ["]F"] = { query = "@call.outer", desc = "Next function call end" },
          ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
          ["]C"] = { query = "@class.outer", desc = "Next class end" },
          ["]I"] = { query = "@conditional.outer", desc = "Next conditional call end" },
          ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
        },
        goto_previous_start = {
          ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
          ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
          ["[c"] = { query = "@class.outer", desc = "Prev class start" },
          ["[i"] = { query = "@conditional.outer", desc = "Prev conditional call start" },
          ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
        },
        goto_previous_end = {
          ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
          ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
          ["[C"] = { query = "@class.outer", desc = "Prev class end" },
          ["[I"] = { query = "@conditional.outer", desc = "Prev conditional call end" },
          ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
        },
      },
    },
  },
  config = function(_, opts)
    local TS = require("nvim-treesitter-textobjects")
    if not TS.setup then
      Utils.error("Use `:Lazy` and update `nvim-treesitter`")
      return
    end
    TS.setup(opts)

    local function attach(buf)
      local filetype = vim.bo[buf].filetype
      if not (vim.tbl_get(opts, "move", "enable") and Utils.treesitter.have(filetype, "textobjects")) then
        return
      end
      ---@type table<string, table<string, string>>
      local moves = vim.tbl_get(opts, "move", "keys") or {}

      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          local queries = type(query) == "table" and query or { query }
          local parts = {}
          for _, q in ipairs(queries) do
            local part = q:gsub("@", ""):gsub("%..*", "")
            part = part:sub(1, 1):upper() .. part:sub(2)
            table.insert(parts, part)
          end
          local desc = table.concat(parts, " or ")
          desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
          if not (vim.wo.diff and key:find("[cC]")) then
            vim.keymap.set({ "n", "x", "o" }, key, function()
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end, {
              buffer = buf,
              desc = desc,
              silent = true,
            })
          end
        end
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("gildofj_treesitter_textobjects", { clear = true }),
      callback = function(ev)
        attach(ev.buf)
      end,
    })
    vim.tbl_map(attach, vim.api.nvim_list_bufs())
  end,
}
