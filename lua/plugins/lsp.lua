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
    },
    config = function()
      -- Patch vim.lsp.client to fix the "bufnr: expected number, got function" error
      local original_resolve_bufnr = vim.lsp.util.resolve_bufnr or function(bufnr)
        if bufnr == nil or bufnr == 0 then
          return vim.api.nvim_get_current_buf()
        end
        return bufnr
      end
      
      vim.lsp.util.resolve_bufnr = function(bufnr)
        -- Handle the case where bufnr might be a function (the root cause of the error)
        if type(bufnr) == "function" then
          vim.notify("[LSP ERROR] bufnr is a function, using current buffer instead", vim.log.levels.ERROR)
          return vim.api.nvim_get_current_buf()
        end
        return original_resolve_bufnr(bufnr)
      end
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
        -- Validate buffer number to prevent the "expected number, got function" error
        if type(bufnr) ~= "number" then
          vim.notify(string.format("[LSP ERROR] Invalid bufnr in on_attach: expected number, got %s", type(bufnr)), vim.log.levels.ERROR)
          return
        end
        
        -- Ensure buffer is valid and loaded
        if not vim.api.nvim_buf_is_valid(bufnr) then
          vim.notify(string.format("[LSP ERROR] Invalid buffer %d in on_attach", bufnr), vim.log.levels.ERROR)
          return
        end

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

        -- HTML (removed twig to prevent LSP conflicts)
        html = {
          filetypes = { "html" }
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
                enable = false,  -- Disable PHP formatting
              },
              environment = {
                includePaths = {
                  "/usr/share/php",
                  "vendor/",
                },
              },
            },
          },
          -- Completely disable formatting capabilities for PHP
          capabilities = (function()
            local caps = vim.lsp.protocol.make_client_capabilities()
            caps.textDocument.formatting = nil
            caps.textDocument.rangeFormatting = nil
            return caps
          end)(),
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
      
      -- Safely get cmp_nvim_lsp capabilities (will be available from our cmp plugin)
      local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      if cmp_nvim_lsp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      else
        vim.notify("[LSP WARNING] cmp_nvim_lsp not available, using default capabilities", vim.log.levels.WARN)
      end
      
      -- Ensure capabilities has the required textDocument field structure
      capabilities.textDocument = capabilities.textDocument or {}
      capabilities.textDocument.completion = capabilities.textDocument.completion or {}
      capabilities.textDocument.completion.completionItem = capabilities.textDocument.completion.completionItem or {}
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
      }

      -- Try to setup mason-lspconfig safely
      pcall(function()
        mason_lspconfig.setup {
          ensure_installed = vim.tbl_keys(servers),
          automatic_installation = false,
          automatic_setup = false,
          -- Disable automatic_enable to prevent vim.lsp.enable() error in Neovim v0.10.0
          automatic_enable = false,
        }
      end)

      -- Setup LSP servers using the new vim.lsp.config API for Neovim 0.11+
      -- with fallback to lspconfig for older versions
      local function setup_lsp_server(server_name, server_config)
        -- Create a safe wrapper for on_attach to prevent buffer number issues
        local safe_on_attach = function(client, bufnr)
          -- Ensure we have a valid buffer number
          local actual_bufnr = bufnr
          if type(bufnr) ~= "number" then
            -- Try to get the current buffer if bufnr is invalid
            actual_bufnr = vim.api.nvim_get_current_buf()
            vim.notify(string.format("[LSP WARNING] Invalid bufnr for %s, using current buffer %d", server_name, actual_bufnr), vim.log.levels.WARN)
          end
          
          -- Final validation
          if type(actual_bufnr) == "number" and vim.api.nvim_buf_is_valid(actual_bufnr) then
            return on_attach(client, actual_bufnr)
          else
            vim.notify(string.format("[LSP ERROR] Could not establish valid buffer for %s", server_name), vim.log.levels.ERROR)
          end
        end
        
        local config = {
          capabilities = server_config.capabilities or capabilities,
          on_attach = safe_on_attach,
          settings = server_config.settings or {},
          filetypes = server_config.filetypes or nil,
        }
        
        -- Use new vim.lsp.config API if available (Neovim 0.11+)
        if vim.lsp.config and vim.fn.has('nvim-0.11') == 1 then
          vim.lsp.config[server_name] = config
        else
          -- Fallback to lspconfig for older versions
          local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
          if lspconfig_ok and lspconfig[server_name] then
            lspconfig[server_name].setup(config)
          else
            vim.notify(string.format("[LSP ERROR] Could not setup %s: lspconfig not available", server_name), vim.log.levels.ERROR)
          end
        end
      end
      
      -- Setup all LSP servers
      for server_name, server_config in pairs(servers) do
        setup_lsp_server(server_name, server_config)
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