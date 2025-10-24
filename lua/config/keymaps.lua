--[[
╭─────────────────────────────────────────────────────────────╮
│                    Keymaps Configuration                    │
│                                                             │
│  Global keymaps and shortcuts                               │
╰─────────────────────────────────────────────────────────────╯
--]]

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better up/down
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- Buffers
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
keymap(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- Save file
keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Lazy
keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- New file
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- File explorer (Neo-tree)
keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Explorer NeoTree (root dir)" })
keymap("n", "<leader>E", "<cmd>Neotree toggle float<cr>", { desc = "Explorer NeoTree (float)" })

-- Location and quickfix lists
keymap("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
keymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

keymap("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
keymap("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- Formatting
keymap({ "n", "v" }, "<leader>cf", function()
  -- Add diagnostic logging
  vim.notify("Leader cf triggered!", vim.log.levels.INFO)
  
  -- Check if conform is available
  local conform_ok, conform = pcall(require, "conform")
  if not conform_ok then
    vim.notify("ERROR: conform.nvim not loaded: " .. tostring(conform), vim.log.levels.ERROR)
    return
  end
  
  -- Get current buffer info
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  local filename = vim.api.nvim_buf_get_name(bufnr)
  
  vim.notify(string.format("Formatting buffer %d, filetype: %s, file: %s", bufnr, filetype, filename), vim.log.levels.INFO)
  
  -- Check available formatters for this filetype
  local formatters = conform.list_formatters(bufnr)
  if #formatters == 0 then
    vim.notify("WARNING: No formatters available for filetype: " .. filetype, vim.log.levels.WARN)
  else
    vim.notify("Available formatters: " .. vim.inspect(formatters), vim.log.levels.INFO)
  end
  
  -- Attempt formatting
  local success, result = pcall(conform.format, { async = true, lsp_fallback = true })
  if not success then
    vim.notify("ERROR: Formatting failed: " .. tostring(result), vim.log.levels.ERROR)
  else
    vim.notify("Formatting completed successfully", vim.log.levels.INFO)
  end
end, { desc = "Format" })

-- Diagnostic keymaps
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
keymap("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Terminal Mappings
keymap("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
keymap("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
keymap("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
keymap("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
keymap("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
keymap("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Write/Save commands
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
keymap("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save all files" })
keymap("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Save and quit" })
keymap("n", "<leader>ww", "<cmd>w<cr>", { desc = "Save file" })

-- Window/Split Management
keymap("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
keymap("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- Advanced window/split commands
keymap("n", "<leader>vs", "<C-W>s", { desc = "Split window horizontally" })
keymap("n", "<leader>vv", "<C-W>v", { desc = "Split window vertically" })
keymap("n", "<leader>vn", "<cmd>vnew<cr>", { desc = "New vertical split" })
keymap("n", "<leader>vh", "<cmd>new<cr>", { desc = "New horizontal split" })
keymap("n", "<leader>vo", "<C-W>o", { desc = "Close all other windows" })
keymap("n", "<leader>vq", "<C-W>q", { desc = "Close current window" })
keymap("n", "<leader>vc", "<C-W>c", { desc = "Close current window" })
keymap("n", "<leader>vx", "<C-W>x", { desc = "Exchange windows" })
keymap("n", "<leader>vr", "<C-W>r", { desc = "Rotate windows" })
keymap("n", "<leader>vR", "<C-W>R", { desc = "Rotate windows reverse" })

-- Window movement
keymap("n", "<leader>vH", "<C-W>H", { desc = "Move window far left" })
keymap("n", "<leader>vJ", "<C-W>J", { desc = "Move window far down" })
keymap("n", "<leader>vK", "<C-W>K", { desc = "Move window far up" })
keymap("n", "<leader>vL", "<C-W>L", { desc = "Move window far right" })

-- Window resizing (enhanced)
keymap("n", "<leader>v=", "<C-W>=", { desc = "Equalize window sizes" })
keymap("n", "<leader>v+", "<cmd>resize +5<cr>", { desc = "Increase height" })
keymap("n", "<leader>v-", "<cmd>resize -5<cr>", { desc = "Decrease height" })
keymap("n", "<leader>v>", "<cmd>vertical resize +5<cr>", { desc = "Increase width" })
keymap("n", "<leader>v<", "<cmd>vertical resize -5<cr>", { desc = "Decrease width" })

-- Buffer management in splits
keymap("n", "<leader>vb", function()
  vim.ui.select(
    vim.tbl_map(function(buf)
      return vim.fn.bufname(buf) ~= "" and vim.fn.bufname(buf) or "[No Name]"
    end, vim.api.nvim_list_bufs()),
    { prompt = "Select buffer to open in new split:" },
    function(choice)
      if choice then
        vim.cmd("split")
        vim.cmd("buffer " .. choice)
      end
    end
  )
end, { desc = "Open buffer in horizontal split" })

keymap("n", "<leader>vB", function()
  vim.ui.select(
    vim.tbl_map(function(buf)
      return vim.fn.bufname(buf) ~= "" and vim.fn.bufname(buf) or "[No Name]"
    end, vim.api.nvim_list_bufs()),
    { prompt = "Select buffer to open in new vertical split:" },
    function(choice)
      if choice then
        vim.cmd("vsplit")
        vim.cmd("buffer " .. choice)
      end
    end
  )
end, { desc = "Open buffer in vertical split" })

-- Quick split with file picker
keymap("n", "<leader>vf", function()
  vim.cmd("split")
  require("telescope.builtin").find_files()
end, { desc = "Find file in horizontal split" })

keymap("n", "<leader>vF", function()
  vim.cmd("vsplit")
  require("telescope.builtin").find_files()
end, { desc = "Find file in vertical split" })

-- Multi-window layouts
keymap("n", "<leader>v2", function()
  vim.cmd("only")
  vim.cmd("vsplit")
end, { desc = "2-column layout" })

keymap("n", "<leader>v3", function()
  vim.cmd("only")
  vim.cmd("vsplit")
  vim.cmd("vsplit")
  vim.cmd("wincmd =")
end, { desc = "3-column layout" })

keymap("n", "<leader>v4", function()
  vim.cmd("only")
  vim.cmd("vsplit")
  vim.cmd("split")
  vim.cmd("wincmd l")
  vim.cmd("split")
  vim.cmd("wincmd =")
end, { desc = "4-window grid layout" })

-- Tabs
keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Toggle options
keymap("n", "<leader>uf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format Buffer" })

keymap("n", "<leader>us", function()
  vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle Spelling" })

keymap("n", "<leader>uw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle Word Wrap" })

keymap("n", "<leader>ul", function()
  vim.opt.number = not vim.opt.number:get()
end, { desc = "Toggle Line Numbers" })

keymap("n", "<leader>ur", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle Relative Numbers" })

-- DDEV/Drupal commands
keymap("n", "<leader>d", "<cmd>!ddev drush cr<cr>", { desc = "DDEV Drush Cache Rebuild" })

-- Git restore commands
keymap("n", "<leader>grf", function()
  local file = vim.fn.expand("%")
  if file == "" then
    vim.notify("No file to restore", vim.log.levels.WARN)
    return
  end
  local choice = vim.fn.confirm("Restore " .. file .. " to last commit?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd("!git restore " .. vim.fn.shellescape(file))
    vim.cmd("checktime")
    vim.notify("Restored " .. file .. " to last commit", vim.log.levels.INFO)
  end
end, { desc = "Restore current file to last commit" })

keymap("n", "<leader>grF", function()
  local file = vim.fn.expand("%")
  if file == "" then
    vim.notify("No file to restore", vim.log.levels.WARN)
    return
  end
  vim.cmd("!git restore " .. vim.fn.shellescape(file))
  vim.cmd("checktime")
  vim.notify("Restored " .. file .. " to last commit", vim.log.levels.INFO)
end, { desc = "Force restore current file (no confirmation)" })

keymap("n", "<leader>grs", function()
  local file = vim.fn.expand("%")
  if file == "" then
    vim.notify("No file to restore", vim.log.levels.WARN)
    return
  end
  local choice = vim.fn.confirm("Restore " .. file .. " from staging area?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd("!git restore --staged " .. vim.fn.shellescape(file))
    vim.notify("Restored " .. file .. " from staging area", vim.log.levels.INFO)
  end
end, { desc = "Restore current file from staging area" })

keymap("n", "<leader>grh", function()
  local choice = vim.fn.confirm("Hard reset current directory to HEAD? This will lose all uncommitted changes!", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd("!git reset --hard HEAD")
    vim.cmd("checktime")
    vim.notify("Hard reset to HEAD completed", vim.log.levels.WARN)
  end
end, { desc = "Hard reset to HEAD (destructive)" })

keymap("n", "<leader>grc", function()
  local commit = vim.fn.input("Enter commit hash or reference (e.g., HEAD~1): ")
  if commit == "" then
    vim.notify("No commit specified", vim.log.levels.WARN)
    return
  end
  local file = vim.fn.expand("%")
  if file == "" then
    vim.notify("No file to restore", vim.log.levels.WARN)
    return
  end
  local choice = vim.fn.confirm("Restore " .. file .. " to " .. commit .. "?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd("!git restore --source=" .. vim.fn.shellescape(commit) .. " " .. vim.fn.shellescape(file))
    vim.cmd("checktime")
    vim.notify("Restored " .. file .. " to " .. commit, vim.log.levels.INFO)
  end
end, { desc = "Restore current file to specific commit" })

-- Git ignore commands
keymap("n", "<leader>gif", function()
  local file = vim.fn.expand("%:.")
  if file == "" then
    vim.notify("No file to ignore", vim.log.levels.WARN)
    return
  end
  local gitignore_path = vim.fn.findfile(".gitignore", ".;")
  if gitignore_path == "" then
    gitignore_path = ".gitignore"
  end
  
  -- Check if file is already ignored
  local handle = io.popen("git check-ignore " .. vim.fn.shellescape(file) .. " 2>/dev/null")
  local result = handle:read("*a")
  handle:close()
  
  if result ~= "" then
    vim.notify(file .. " is already ignored", vim.log.levels.INFO)
    return
  end
  
  -- Add to gitignore
  local gitignore_file = io.open(gitignore_path, "a")
  if gitignore_file then
    gitignore_file:write("\n" .. file .. "\n")
    gitignore_file:close()
    vim.notify("Added " .. file .. " to .gitignore", vim.log.levels.INFO)
    
    -- Refresh Neogit if it's open
    vim.cmd("silent! NeogitResetState")
  else
    vim.notify("Could not open .gitignore file", vim.log.levels.ERROR)
  end
end, { desc = "Add current file to .gitignore" })

keymap("n", "<leader>gid", function()
  local dir = vim.fn.expand("%:h")
  if dir == "" or dir == "." then
    vim.notify("No directory to ignore", vim.log.levels.WARN)
    return
  end
  
  local gitignore_path = vim.fn.findfile(".gitignore", ".;")
  if gitignore_path == "" then
    gitignore_path = ".gitignore"
  end
  
  local ignore_pattern = dir .. "/"
  
  -- Check if directory pattern is already ignored
  local handle = io.popen("git check-ignore " .. vim.fn.shellescape(dir) .. " 2>/dev/null")
  local result = handle:read("*a")
  handle:close()
  
  if result ~= "" then
    vim.notify(dir .. "/ is already ignored", vim.log.levels.INFO)
    return
  end
  
  -- Add to gitignore
  local gitignore_file = io.open(gitignore_path, "a")
  if gitignore_file then
    gitignore_file:write("\n" .. ignore_pattern .. "\n")
    gitignore_file:close()
    vim.notify("Added " .. ignore_pattern .. " to .gitignore", vim.log.levels.INFO)
    
    -- Refresh Neogit if it's open
    vim.cmd("silent! NeogitResetState")
  else
    vim.notify("Could not open .gitignore file", vim.log.levels.ERROR)
  end
end, { desc = "Add current directory to .gitignore" })

keymap("n", "<leader>gip", function()
  local pattern = vim.fn.input("Enter pattern to ignore (e.g., *.log, node_modules/, etc.): ")
  if pattern == "" then
    vim.notify("No pattern specified", vim.log.levels.WARN)
    return
  end
  
  local gitignore_path = vim.fn.findfile(".gitignore", ".;")
  if gitignore_path == "" then
    gitignore_path = ".gitignore"
  end
  
  -- Add to gitignore
  local gitignore_file = io.open(gitignore_path, "a")
  if gitignore_file then
    gitignore_file:write("\n" .. pattern .. "\n")
    gitignore_file:close()
    vim.notify("Added " .. pattern .. " to .gitignore", vim.log.levels.INFO)
    
    -- Refresh Neogit if it's open
    vim.cmd("silent! NeogitResetState")
  else
    vim.notify("Could not open .gitignore file", vim.log.levels.ERROR)
  end
end, { desc = "Add custom pattern to .gitignore" })

keymap("n", "<leader>gie", function()
  local gitignore_path = vim.fn.findfile(".gitignore", ".;")
  if gitignore_path == "" then
    gitignore_path = ".gitignore"
    -- Create .gitignore if it doesn't exist
    local gitignore_file = io.open(gitignore_path, "w")
    if gitignore_file then
      gitignore_file:write("# .gitignore\n")
      gitignore_file:close()
    end
  end
  vim.cmd("edit " .. gitignore_path)
end, { desc = "Edit .gitignore file" })

keymap("n", "<leader>gis", function()
  local file = vim.fn.expand("%:.")
  if file == "" then
    file = vim.fn.input("Enter file/pattern to check: ")
    if file == "" then
      vim.notify("No file specified", vim.log.levels.WARN)
      return
    end
  end
  
  local handle = io.popen("git check-ignore -v " .. vim.fn.shellescape(file) .. " 2>/dev/null")
  local result = handle:read("*a")
  handle:close()
  
  if result ~= "" then
    vim.notify("Ignored by: " .. result:gsub("\n", ""), vim.log.levels.INFO)
  else
    vim.notify(file .. " is NOT ignored", vim.log.levels.INFO)
  end
end, { desc = "Check if file is ignored" })

-- Quit
keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Alternative escape mapping - kl to exit insert mode
keymap("i", "kl", "<Esc>", { desc = "Exit insert mode" })
keymap("i", "lk", "<Esc>", { desc = "Exit insert mode" })
