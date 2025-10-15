--[[
╭─────────────────────────────────────────────────────────────╮
│                    Autocmds Configuration                   │
│                                                             │
│  Automatic commands and event handlers                      │
╰─────────────────────────────────────────────────────────────╯
--]]

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto-format on save for specific filetypes (PHP excluded)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_format"),
  pattern = { "*.lua", "*.js", "*.ts", "*.jsx", "*.tsx", "*.css", "*.scss", "*.html", "*.twig" },
  callback = function(event)
    if vim.g.autoformat then
      local filetype = vim.bo[event.buf].filetype
      
      -- Skip formatting for PHP files entirely
      if filetype == "php" then
        return
      end
      
      -- Add diagnostic logging for Twig files
      if filetype == "twig" then
        vim.notify("DEBUG: Formatting Twig file: " .. event.match, vim.log.levels.INFO)
        
        -- Check LSP clients attached to this buffer
        local clients = vim.lsp.get_active_clients({ bufnr = event.buf })
        for _, client in ipairs(clients) do
          vim.notify("DEBUG: LSP client attached: " .. client.name, vim.log.levels.INFO)
        end
        
        -- Temporarily disable LSP for Twig files during formatting to prevent sync issues
        local lsp_clients = vim.lsp.get_active_clients({ bufnr = event.buf })
        for _, client in ipairs(lsp_clients) do
          vim.lsp.buf_detach_client(event.buf, client.id)
        end
        
        -- Format the file
        local ok, err = pcall(function()
          require("conform").format({ async = false, lsp_fallback = false })
        end)
        
        if not ok then
          vim.notify("DEBUG: Conform formatting failed: " .. tostring(err), vim.log.levels.ERROR)
        end
        
        -- Re-attach LSP clients after formatting
        vim.schedule(function()
          for _, client in ipairs(lsp_clients) do
            vim.lsp.buf_attach_client(event.buf, client.id)
          end
        end)
      else
        -- Normal formatting for non-Twig files
        require("conform").format({ async = false, lsp_fallback = true })
      end
    end
  end,
})

-- Enable auto-format by default
vim.g.autoformat = true

-- Disable Treesitter on query errors to prevent crashes
vim.api.nvim_create_autocmd("User", {
  group = augroup("treesitter_error_handler"),
  pattern = "TreesitterError",
  callback = function()
    vim.notify("Treesitter error detected, disabling for this buffer", vim.log.levels.WARN)
    vim.treesitter.stop()
  end,
})

-- Twig filetype detection for .html.twig files
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  group = augroup("twig_filetype"),
  pattern = "*.html.twig",
  callback = function()
    vim.bo.filetype = "twig"
  end,
})

-- Additional safety for PHP files and problematic parsers (excluding twig)
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  group = augroup("disable_problematic_treesitter"),
  pattern = {"*.php", "*.blade.php"},
  callback = function()
    -- Disable Treesitter highlighting for these file types
    vim.treesitter.stop()
    -- Use built-in syntax highlighting instead
    vim.cmd("syntax enable")
  end,
})