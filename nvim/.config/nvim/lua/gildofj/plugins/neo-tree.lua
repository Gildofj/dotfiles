return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  disactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
    -- because `cwd` is not set up properly.
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      desc = "Start Neo-tree with directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end
      end,
    })
  end,
  opts = function()
    local command = require("neo-tree.command")
    vim.keymap.set("n", "<C-b>", ":Neotree filesystem reveal left<CR>")
    vim.keymap.set("n", "<C-S-b>", ":Neotree filesystem action=close<CR>")
    vim.keymap.set("n", "<C-g>", ":Neotree float git_status reveal<CR>")

    -- Disable netrw (file explorer) to prevent conflicts with Neo-tree
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    return {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        use_libuv_watcher = true,
        follow_current_file = {
          enabled = true,
        },
      },
      window = {
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = {
            "toggle_preview",
            config = {
              use_float = false,
              use_image_nvim = true,
            },
          },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged = "󰱒",
          },
        },
      },
      nesting_rules = {
        ["package.json"] = {
          pattern = "^package%.json$",
          files = {
            "package-lock.json",
            "yarn.lock",
            "pnpm-lock.yaml",
            "eslint.*",
            ".eslintrc*",
            ".prettier*",
            ".nvmrc",
            ".editorconfig",
            "tsconfig.*",
            "vite.config.*",
          },
        },
        ["tsconfig.json"] = {
          pattern = "^tsconfig%.json$",
          files = {
            "tsconfig.*.json",
          },
        },
        [".env"] = {
          pattern = "^%.env$",
          files = {
            ".env.*",
          },
        },
        ["tailwind.config.js"] = {
          pattern = "^tailwind%.config%.js$",
          files = {
            "tailwind.config.*",
            "postcss.config.*",
          },
        },
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            command.execute({ action = "close" })
          end,
        },
        {
          event = "file_renamed",
          handler = function(args)
            print("File " .. args.source .. " renamed to " .. args.destination)
          end,
        },
        {
          event = "file_moved",
          handler = function(args)
            print("File " .. args.source .. " moved to " .. args.destination)
          end,
        },
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.cmd("highlight! Cursor blend=100")
          end,
        },
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            vim.cmd("wincmd =")
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function(args)
            vim.cmd("wincmd =")
          end,
        },
      },
    }
  end,
}
