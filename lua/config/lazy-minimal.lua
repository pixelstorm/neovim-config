--[[
╭─────────────────────────────────────────────────────────────╮
│                    Minimal Lazy Configuration              │
│                                                             │
│  Minimal lazy.nvim setup for debugging plugin loading      │
╰─────────────────────────────────────────────────────────────╯
--]]

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim with OPTIMIZED settings
require("lazy").setup({
  spec = {
    -- Only load essential plugins for testing
    {
      "folke/tokyonight.nvim",
      lazy = true,
      priority = 1000,
    },
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
  },
  defaults = {
    lazy = true, -- ENABLE lazy loading by default
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = false }, -- DISABLE automatic updates during startup
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
    backdrop = 60,
  },
})