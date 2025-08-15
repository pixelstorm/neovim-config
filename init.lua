--[[
╭─────────────────────────────────────────────────────────────╮
│                    Neovim Configuration                     │
│                                                             │
│  A comprehensive Neovim setup with modern plugins and      │
│  features for web development, including:                  │
│                                                             │
│  • Tokyo Night theme                                       │
│  • LSP support (PHP, JS, CSS, SCSS, Twig)                 │
│  • Telescope + FZF integration                             │
│  • GitHub Copilot                                          │
│  • Treesitter syntax highlighting                          │
│  • Code snippets with LuaSnip                             │
│  • Git integration with Neogit                            │
│  • Modern statusline with Lualine                         │
│  • Alpha dashboard (better than Startify)                 │
│                                                             │
│  Author: Generated for pixelstorm                          │
│  Last Updated: 2025-08-14                                  │
╰─────────────────────────────────────────────────────────────╯
--]]

-- Bootstrap lazy.nvim plugin manager
require("config.lazy")

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")