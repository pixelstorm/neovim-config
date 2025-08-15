--[[
╭─────────────────────────────────────────────────────────────╮
│                    Treesitter Configuration                 │
│                                                             │
│  Advanced syntax highlighting and code understanding        │
╰─────────────────────────────────────────────────────────────╯
--]]

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "VeryLazy" },
    enabled = false, -- TEMPORARILY DISABLED due to query compatibility issues
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find("[%]%[][cC]") then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        -- Disable highlighting for problematic languages and large files
        disable = function(lang, buf)
          -- Disable for languages with query compatibility issues
          local problematic_langs = {
            "php",
            "phpdoc",
            "twig",
            "blade",
            "smarty"
          }
          
          for _, problematic_lang in ipairs(problematic_langs) do
            if lang == problematic_lang then
              return true
            end
          end
          
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = {
        enable = true,
        -- Disable for problematic languages
        disable = { "python", "yaml" },
      },
      ensure_installed = {
        "bash",
        "c",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        -- "php" and "phpdoc" removed due to query compatibility issues
        "python",
        "query",
        "regex",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        -- Note: "twig" parser also removed due to query compatibility issues
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
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      
      -- Setup with error handling
      local ok, err = pcall(require("nvim-treesitter.configs").setup, opts)
      if not ok then
        vim.notify("Treesitter setup failed: " .. tostring(err), vim.log.levels.WARN)
        -- Fallback to basic configuration
        require("nvim-treesitter.configs").setup({
          highlight = {
            enable = true,
            disable = { "php", "phpdoc", "twig", "blade", "smarty" }
          },
          indent = { enable = true },
        })
      end
      
      -- Additional safety: disable any existing problematic parsers
      vim.schedule(function()
        local problematic_parsers = { "php", "phpdoc", "twig", "blade", "smarty" }
        for _, parser in ipairs(problematic_parsers) do
          pcall(function()
            vim.treesitter.language.require_language(parser, nil, true)
          end)
        end
      end)
    end,
  },
}