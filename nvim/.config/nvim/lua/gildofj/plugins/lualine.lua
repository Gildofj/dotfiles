return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local icons = Core.icons

    vim.o.laststatus = vim.g.lualine_laststatus

    --Fix transparent background issue for catppuccin don't show component separators on lualine_x
    ---@type string | table<string, string>
    local lualine_theme = "auto"
    if string.find(vim.g.colors_name, "catppuccin") then
      local lualine_catpuccin = require("lualine.themes.catppuccin")
      lualine_catpuccin.normal.c.bg = "#181825"
      lualine_theme = lualine_catpuccin
    end

    local opts = {
      options = {
        theme = lualine_theme,
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dasboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          Utils.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { Utils.lualine.pretty_path() },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Utils.color("Statement") } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Utils.color("Constant") } end,
          },
          -- stylua: ignore
          {
            function() return icons.kinds.Gemini end,
            cond = function () local ok, _ = pcall(require, "gemini") return ok end,
            color = function () return { fg = Utils.color("Special") } end,
          },
          -- stylua: ignore
          {
            function () return "  " .. require("dap").status end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Utils.color("Debug") } end
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Utils.color("Special") } end,
          },
          {
            "diff",
            symbols = {},
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.modified,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = "  ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          "encoding",
          "fileformat",
          function()
            return "  " .. os.date("%R")
          end,
        },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    }

    return opts
  end,
}
