-- Enhanced PHP navigation configuration
-- Handles PHP include/require patterns and project structures

local M = {}

-- Common PHP search paths (in order of preference)
M.php_paths = {
  "",  -- Current directory
  "./",
  "../",
  "src/",
  "app/",
  "lib/",
  "includes/",
  "inc/",
  "classes/",
  "vendor/",
  "public/",
  "web/",
  "htdocs/",
  "www/",
}

-- Function to resolve PHP file paths
function M.resolve_php_path(fname)
  -- Clean up the filename (remove quotes and whitespace)
  fname = fname:gsub("^['\"]", ""):gsub("['\"]$", ""):gsub("^%s+", ""):gsub("%s+$", "")
  
  -- If it's already an absolute path, return as-is
  if fname:match("^/") then
    return fname
  end
  
  -- Try the filename as-is first
  if vim.fn.filereadable(fname) == 1 then
    return fname
  end
  
  -- Try with .php extension if not present
  if not fname:match("%.php$") then
    local with_php = fname .. ".php"
    if vim.fn.filereadable(with_php) == 1 then
      return with_php
    end
  end
  
  -- Try different base paths
  for _, base_path in ipairs(M.php_paths) do
    local full_path = base_path .. fname
    if vim.fn.filereadable(full_path) == 1 then
      return full_path
    end
    
    -- Also try with .php extension
    if not fname:match("%.php$") then
      local with_ext = full_path .. ".php"
      if vim.fn.filereadable(with_ext) == 1 then
        return with_ext
      end
    end
  end
  
  -- Try relative to current file's directory
  local current_dir = vim.fn.expand('%:p:h')
  local relative_path = current_dir .. "/" .. fname
  if vim.fn.filereadable(relative_path) == 1 then
    return relative_path
  end
  
  if not fname:match("%.php$") then
    local relative_with_ext = relative_path .. ".php"
    if vim.fn.filereadable(relative_with_ext) == 1 then
      return relative_with_ext
    end
  end
  
  return fname
end

-- Enhanced gf function for PHP files
function M.goto_php_file()
  local cfile = vim.fn.expand('<cfile>')
  if cfile == "" then
    -- Try to extract filename from current line if <cfile> is empty
    local line = vim.fn.getline('.')
    local patterns = {
      "require_once ['\"]([^'\"]+)['\"]",  -- require_once 'file.php'
      "require ['\"]([^'\"]+)['\"]",       -- require 'file.php'
      "include_once ['\"]([^'\"]+)['\"]",  -- include_once 'file.php'
      "include ['\"]([^'\"]+)['\"]",       -- include 'file.php'
      "require_once%(([^)]+)%)",           -- require_once(file)
      "require%(([^)]+)%)",                -- require(file)
      "include_once%(([^)]+)%)",           -- include_once(file)
      "include%(([^)]+)%)",                -- include(file)
    }
    
    for _, pattern in ipairs(patterns) do
      local match = line:match(pattern)
      if match then
        -- Clean up the match (remove quotes and whitespace)
        cfile = match:gsub("^['\"]", ""):gsub("['\"]$", ""):gsub("^%s+", ""):gsub("%s+$", "")
        break
      end
    end
  end
  
  if cfile == "" then
    vim.notify("No file found under cursor", vim.log.levels.WARN)
    return
  end
  
  local resolved_path = M.resolve_php_path(cfile)
  
  if vim.fn.filereadable(resolved_path) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(resolved_path))
  else
    -- Show helpful error message with suggestions
    local suggestions = {}
    
    -- Try to find similar files
    local base_name = vim.fn.fnamemodify(cfile, ":t:r")  -- Get filename without extension
    local find_cmd = "find . -name '*" .. base_name .. "*.php' 2>/dev/null | head -5"
    local similar_files = vim.fn.systemlist(find_cmd)
    
    if #similar_files > 0 then
      table.insert(suggestions, "Similar files found:")
      for _, file in ipairs(similar_files) do
        table.insert(suggestions, "  " .. file)
      end
    end
    
    local error_msg = string.format(
      "File not found: %s\nResolved to: %s\n%s",
      cfile,
      resolved_path,
      table.concat(suggestions, "\n")
    )
    
    vim.notify(error_msg, vim.log.levels.ERROR)
  end
end

-- Function to open file in split
function M.goto_php_file_split()
  local cfile = vim.fn.expand('<cfile>')
  local resolved_path = M.resolve_php_path(cfile)
  
  if vim.fn.filereadable(resolved_path) == 1 then
    vim.cmd('split ' .. vim.fn.fnameescape(resolved_path))
  else
    M.goto_php_file()  -- Fall back to regular function for error handling
  end
end

-- Debug function
function M.debug_php_path()
  local cfile = vim.fn.expand('<cfile>')
  local line = vim.fn.getline('.')
  
  -- Try to extract from line if cfile is empty
  if cfile == "" then
    local patterns = {
      "require_once ['\"]([^'\"]+)['\"]",
      "require ['\"]([^'\"]+)['\"]",
      "include_once ['\"]([^'\"]+)['\"]",
      "include ['\"]([^'\"]+)['\"]",
    }
    
    for _, pattern in ipairs(patterns) do
      local match = line:match(pattern)
      if match then
        cfile = match:gsub("^['\"]", ""):gsub("['\"]$", "")
        break
      end
    end
  end
  
  local resolved_path = M.resolve_php_path(cfile)
  
  print("=== PHP Path Debug ===")
  print("Original: " .. cfile)
  print("Resolved: " .. resolved_path)
  print("Readable: " .. (vim.fn.filereadable(resolved_path) == 1 and "Yes" or "No"))
  print("Current directory: " .. vim.fn.getcwd())
  print("Current file directory: " .. vim.fn.expand('%:p:h'))
  
  -- Show search paths
  print("\nSearch paths:")
  for _, path in ipairs(M.php_paths) do
    print("  " .. (path == "" and "." or path))
  end
  
  -- Test all possible paths
  print("\nTesting paths:")
  for _, base_path in ipairs(M.php_paths) do
    local test_path = base_path .. cfile
    local readable = vim.fn.filereadable(test_path) == 1
    print("  " .. test_path .. " -> " .. (readable and "EXISTS" or "NOT FOUND"))
    
    if not cfile:match("%.php$") then
      local with_ext = test_path .. ".php"
      local ext_readable = vim.fn.filereadable(with_ext) == 1
      print("  " .. with_ext .. " -> " .. (ext_readable and "EXISTS" or "NOT FOUND"))
    end
  end
end

-- Setup function to be called from ftplugin
function M.setup()
  -- Set up includeexpr
  vim.opt_local.includeexpr = "v:lua.require('config.php-navigation').resolve_php_path(v:fname)"
  
  -- Set up path
  for _, path in ipairs(M.php_paths) do
    vim.opt_local.path:append(path .. "**")
  end
  
  -- Set suffixes
  vim.opt_local.suffixesadd:prepend(".php")
  vim.opt_local.suffixesadd:prepend(".inc")
  vim.opt_local.suffixesadd:prepend(".class.php")
  
  -- Set up keymaps
  vim.keymap.set('n', 'gf', M.goto_php_file, { 
    buffer = true, 
    desc = "Go to PHP file" 
  })
  
  vim.keymap.set('n', '<C-w>f', M.goto_php_file_split, { 
    buffer = true, 
    desc = "Go to PHP file in split" 
  })
  
  vim.keymap.set('n', '<leader>pf', M.debug_php_path, { 
    buffer = true, 
    desc = "Debug PHP file path" 
  })
end

return M