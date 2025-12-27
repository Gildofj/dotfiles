return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    build = function()
      local TS = require("nvim-treesitter")
      if not TS.get_installed then
        Utils.error("Restart Neovim and run `TSUpdate` to use the `nvim-treesitter` **main** branch.")
      end

      package.loaded["gildofj.utils.treesitter"] = nil
      Utils.treesitter.build(function()
        TS.update(nil, { summary = true })
      end)
    end,
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts_extend = { "ensure_installed" },
    ---@alias gildofj.TSFeat { enable?: boolean, disable?: string[] }
    ---@class gildofj.TSConfig
    opts = {
      highlight = { enable = true }, ---@type gildofj.TSFeat
      indent = { enable = true }, ---@type gildofj.TSFeat
      fold = { enable = true }, ---@type gildofj.TSFeat
      ensure_installed = {
        "astro",
        "bash",
        "c",
        "cpp",
        "diff",
        "json",
        "llvm",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "rust",
        "swift",
        "toml",
        "tsx",
        "typescript",
        "javascript",
        "html",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    ---@param opts gildofj.TSConfig
    config = function(_, opts)
      local TS = require("nvim-treesitter")

      -- enable for astro files
      vim.filetype.add({
        extension = {
          astro = "astro",
        },
      })

      setmetatable(require("nvim-treesitter.install"), {
        __newindex = function(_, k)
          if k == "compilers" then
            vim.schedule(function()
              Utils.error("Setting custom compilers for `nvim-treesitter` is no longer supported.")
            end)
          end
        end,
      })

      -- some quick sanity checks
      if not TS.get_installed then
        return Utils.error("Please use `:Lazy` and update `nvim-treesitter`")
      elseif type(opts.ensure_installed) ~= "table" then
        return Utils.error("`nvim-treesitter` opts.ensure_installed must be a table")
      end

      TS.setup(opts)
      Utils.treesitter.get_installed(true) -- initialize the installed langs

      -- install missing parsers
      local install = vim.tbl_filter(function(lang)
        return not Utils.treesitter.have(lang)
      end, opts.ensure_installed or {})
      if #install > 0 then
        TS.install(install, { summary = true }):await(function()
          Utils.treesitter.get_installed(true) -- refresh the installed langs
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("gildofj_treesitter", { clear = true }),
        callback = function(ev)
          local filetype, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
          if not Utils.treesitter.have(filetype) then
            return
          end

          ---@param feat string
          ---@param query string
          local function enabled(feat, query)
            local f = opts[feat] or {} --@type gildofj.TSFeat
            return f.enable ~= false
              and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
              and Utils.treesitter.have(filetype, query)
          end

          -- highlighting
          if enabled("highlight", "highlights") then
            pcall(vim.treesitter.start, ev.buf)
          end
          -- indents
          if enabled("indent", "indents") then
            Utils.set_default("indentexpr", "v:lua.Utils.treesitter.indentexpr()")
          end

          -- folds
          if enabled("folds", "folds") then
            if Utils.set_default("foldmethod", "expr") then
              Utils.set_default("foldexpr", "v:lua.Utils.treesitter.foldexpr()")
            end
          end
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
  },
}
