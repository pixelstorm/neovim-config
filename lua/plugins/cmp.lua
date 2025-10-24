--[[
╭─────────────────────────────────────────────────────────────╮
│                    Completion Configuration                 │
│                                                             │
│  nvim-cmp setup with LSP, snippets, and other sources     │
╰─────────────────────────────────────────────────────────────╯
--]]

return {
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",

      -- Additional sources
      "hrsh7th/cmp-nvim-lua", -- Neovim Lua API
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load friendly snippets safely
      pcall(function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end)
      
      -- Load custom snippets safely
      pcall(function()
        require("config.snippets").setup()
      end)

      -- Setup complete - duplicate configuration conflict resolved
      vim.notify("[CMP] nvim-cmp configured with proper Tab completion behavior", vim.log.levels.INFO)

      -- Override the problematic cmp-nvim-lsp source to fix buffer number issues
      local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      if cmp_nvim_lsp_ok then
        -- Patch the source to handle buffer number validation properly
        local original_source = cmp_nvim_lsp.source
        if original_source and original_source.complete then
          local original_complete = original_source.complete
          original_source.complete = function(self, params, callback)
            -- Ensure params has valid buffer context
            if params and params.context then
              local bufnr = params.context.bufnr or vim.api.nvim_get_current_buf()
              if type(bufnr) ~= "number" then
                vim.notify("[CMP ERROR] Invalid bufnr in cmp-nvim-lsp source, aborting completion", vim.log.levels.ERROR)
                callback({ items = {}, isIncomplete = false })
                return
              end
              params.context.bufnr = bufnr
            end
            return original_complete(self, params, callback)
          end
        end
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              local selected_entry = cmp.get_selected_entry()
              if selected_entry then
                -- Confirm the currently highlighted/selected item
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
              else
                -- If no item is selected, select the first one and confirm
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
              end
            else
              fallback()
            end
          end, { "i" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            -- Check if Copilot suggestion is available first
            local copilot_ok, copilot_suggestion = pcall(require, "copilot.suggestion")
            if copilot_ok and copilot_suggestion.is_visible() then
              copilot_suggestion.accept()
              return
            end
            
            -- Handle snippet expansion/jumping
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif cmp.visible() then
              -- Get current selection info
              local selected_entry = cmp.get_selected_entry()
              
              if selected_entry then
                -- Check if we're at the last item by trying to select next
                local current_selected = cmp.get_selected_entry()
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                local new_selected = cmp.get_selected_entry()
                
                -- If selection didn't change, we're at the last item
                if current_selected == new_selected then
                  -- At last item - confirm it
                  cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                end
                -- Otherwise, we've already moved to next item
              else
                -- No item selected, select the first one
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              end
            else
              -- No completion menu visible, trigger completion
              cmp.complete()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          -- Add dedicated navigation keys for completion menu
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        }),
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            -- Add safety checks for LSP source
            entry_filter = function(entry, ctx)
              -- Ensure we have a valid buffer context
              local bufnr = vim.api.nvim_get_current_buf()
              if type(bufnr) ~= "number" or not vim.api.nvim_buf_is_valid(bufnr) then
                vim.notify("[CMP WARNING] Invalid buffer context in LSP source", vim.log.levels.WARN)
                return false
              end
              
              -- Debug logging for LSP completion requests
              vim.notify(string.format("[CMP DEBUG] LSP entry filter called, bufnr: %s (type: %s)", tostring(bufnr), type(bufnr)), vim.log.levels.DEBUG)
              return true
            end
          },
          { name = "luasnip" },
          { name = "nvim_lua" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Kind icons
            local kind_icons = {
              Text = "",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "",
              Field = "󰇽",
              Variable = "󰂡",
              Class = "󰠱",
              Interface = "",
              Module = "",
              Property = "󰜢",
              Unit = "",
              Value = "󰎠",
              Enum = "",
              Keyword = "󰌋",
              Snippet = "",
              Color = "󰏘",
              File = "󰈙",
              Reference = "",
              Folder = "󰉋",
              EnumMember = "",
              Constant = "󰏿",
              Struct = "",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "󰅲",
            }
            
            -- This concatenates the icons with the name of the item kind
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            
            -- Source
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              path = "[Path]",
            })[entry.source.name]
            
            return vim_item
          end,
        },
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "buffer" },
        }),
      })

      -- Set configuration for markdown files
      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Re-enable LSP completion for PHP files with proper priority
      cmp.setup.filetype("php", {
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 }, -- Re-enable LSP
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
      })

      -- Set configuration for Twig files
      cmp.setup.filetype("twig", {
        sources = cmp.config.sources({
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Set configuration for HTML files
      cmp.setup.filetype("html", {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },

  -- Snippet collection
  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}