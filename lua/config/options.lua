--[[
╭─────────────────────────────────────────────────────────────╮
│                    Neovim Options                           │
│                                                             │
│  Core Neovim settings and options                          │
╰─────────────────────────────────────────────────────────────╯
--]]

local opt = vim.opt

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General
opt.mouse = "a"                     -- Enable mouse support
opt.clipboard = "unnamedplus"       -- Use system clipboard
opt.swapfile = false               -- Disable swap files
opt.backup = false                 -- Disable backup files
opt.undofile = false               -- Disable persistent undo (prevents undo across sessions)
opt.undolevels = 1000              -- Limit undo levels per session
opt.undoreload = 0                 -- Don't save undo info when reloading a file
opt.updatetime = 200               -- Faster completion (4000ms default)
opt.timeoutlen = 300               -- Time to wait for a mapped sequence to complete
opt.autowrite = true               -- Enable auto write
opt.confirm = true                 -- Confirm to save changes before exiting modified buffer

-- UI
opt.number = true                  -- Print line number
opt.relativenumber = true          -- Relative line numbers
opt.signcolumn = "yes"             -- Always show the signcolumn
opt.cursorline = true              -- Enable highlighting of the current line
opt.termguicolors = true           -- True color support
opt.winminwidth = 5                -- Minimum window width
opt.wrap = false                   -- Disable line wrap
opt.linebreak = true               -- Wrap lines at convenient points
opt.pumheight = 10                 -- Maximum number of entries in a popup
opt.pumblend = 10                  -- Popup blend
opt.winblend = 0                   -- Window blend
opt.showmode = false               -- Don't show mode since we have a statusline
opt.conceallevel = 2               -- Hide * markup for bold and italic, but not markers with substitutions
opt.list = true                    -- Show some invisible characters (tabs...)
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = {
  foldopen = "-",
  foldclose = "+",
  fold = " ",
  foldsep = " ",
  diff = "/",
  eob = " ",
}

-- Editing
opt.expandtab = true               -- Use spaces instead of tabs
opt.shiftwidth = 2                 -- Size of an indent
opt.tabstop = 2                    -- Number of spaces tabs count for
opt.softtabstop = 2                -- Number of spaces tabs count for in insert mode
opt.smartindent = true             -- Insert indents automatically
opt.shiftround = true              -- Round indent
opt.autoindent = true              -- Copy indent from current line when starting a new line

-- Search
opt.ignorecase = true              -- Ignore case
opt.smartcase = true               -- Don't ignore case with capitals
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit"         -- Preview incremental substitute
opt.hlsearch = true                -- Highlight search results

-- Splits
opt.splitbelow = true              -- Put new windows below current
opt.splitright = true              -- Put new windows right of current
opt.splitkeep = "screen"           -- Keep the same relative cursor position when splitting

-- Scrolling
opt.scrolloff = 4                  -- Lines of context
opt.sidescrolloff = 8              -- Columns of context

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full" -- Command-line completion mode

-- Folding
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Session
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Disable some builtin vim plugins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "syntax",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end