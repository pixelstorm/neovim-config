--[[
╭─────────────────────────────────────────────────────────────╮
│                    LSP Configuration                        │
│                                                             │
│  Language Server Protocol setup for multiple languages     │
│  Supports: PHP, JavaScript, CSS, SCSS, Twig                │
╰─────────────────────────────────────────────────────────────╯
--]]

return {
  -- LSP Configuration & Plugins
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
      
      -- Completion capabilities
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Brief Aside: **What is LSP?**
      --
      -- LSP is an acronym you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized way.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine)
      -- are standalone processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(client, bufnr)
        -- NOTE: Remember that lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself
        -- many times.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end

      -- mason-lspconfig requires that these setup functions are called in this order
      -- before setting up the servers.
      require('mason').setup()
      
      -- Setup mason-lspconfig with minimal configuration to avoid enable field error
      local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
      if not mason_lspconfig_ok then
        vim.notify("mason-lspconfig not available", vim.log.levels.WARN)
        return
      end

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. They will be passed to
      --  the `settings` field of the server config. You must look up that documentation yourself.
      --
      --  If you want to override the default filetypes that a language server will attach to you can
      --  define the property 'filetypes' to the map in question.
      local servers = {
        -- CSS
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore"
              }
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = "ignore"
              }
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = "ignore"
              }
            }
          }
        },

        -- HTML
        html = {
          filetypes = { "html", "twig" }
        },

        -- JavaScript/TypeScript
        ts_ls = {}, -- Updated from deprecated tsserver

        -- PHP
        intelephense = {
          settings = {
            intelephense = {
              files = {
                maxSize = 1000000,
              },
              format = {
                braces = "psr12",
              },
              environment = {
                includePaths = {
                  "/usr/share/php",
                  "vendor/",
                },
              },
            },
          },
        },

        -- Twig (using HTML LSP with Twig support)
        -- Note: For better Twig support, you might want to use a dedicated Twig LSP
        -- but HTML LSP with Twig filetype works reasonably well

        -- JSON
        jsonls = {},

        -- YAML
        yamlls = {},

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Setup neovim lua configuration
      require('neodev').setup()

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      -- Safely get cmp_nvim_lsp capabilities
      local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      if cmp_nvim_lsp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Try to setup mason-lspconfig safely
      pcall(function()
        mason_lspconfig.setup {
          ensure_installed = vim.tbl_keys(servers),
          automatic_installation = false,
          automatic_setup = false,
        }
      end)

      -- Setup LSP servers manually to avoid automatic_enable issues
      for server_name, server_config in pairs(servers) do
        local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
        if lspconfig_ok and lspconfig[server_name] then
          lspconfig[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = server_config.settings or {},
            filetypes = server_config.filetypes or nil,
          }
        end
      end

      -- Setup mason-tool-installer for additional tools
      local mason_tool_installer_ok, mason_tool_installer = pcall(require, 'mason-tool-installer')
      if mason_tool_installer_ok then
        mason_tool_installer.setup {
          ensure_installed = {
            -- Formatters
            'prettier',
            'stylua',
            'php-cs-fixer',
            
            -- Linters
            'eslint_d',
            'phpcs',
            'stylelint',
          },
        }
      end
    end,
  },
}