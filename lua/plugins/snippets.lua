--[[
╭─────────────────────────────────────────────────────────────╮
│                    Code Snippets Configuration              │
│                                                             │
│  LuaSnip with custom snippets for web development          │
╰─────────────────────────────────────────────────────────────╯
--]]

return {
  -- LuaSnip
  {
    "L3MON4D3/LuaSnip",
    build = (function()
      -- Build Step is needed for regex support in snippets
      -- This step is not supported in many windows environments
      -- Remove the below condition to re-enable on windows
      if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
        return
      end
      return "make install_jsregexp"
    end)(),
    dependencies = {
      -- `friendly-snippets` contains a variety of premade snippets.
      --    See the README about individual language/framework/plugin snippets:
      --    https://github.com/rafamadriz/friendly-snippets
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = {
      -- Remove conflicting Tab mapping - handled by nvim-cmp now
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
    config = function(_, opts)
      require("luasnip").setup(opts)

      -- Load custom snippets
      require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets" })

      -- Extend filetypes
      require("luasnip").filetype_extend("javascript", { "jsdoc" })
      require("luasnip").filetype_extend("javascript", { "javascriptreact" })
      require("luasnip").filetype_extend("typescript", { "tsdoc" })
      require("luasnip").filetype_extend("typescript", { "typescriptreact" })
      require("luasnip").filetype_extend("php", { "phpdoc" })
      require("luasnip").filetype_extend("twig", { "html" })
      require("luasnip").filetype_extend("scss", { "css" })
    end,
  },

  -- Note: nvim-cmp configuration is handled in cmp.lua to prevent conflicts
  -- This duplicate configuration has been removed to eliminate startup messages
}