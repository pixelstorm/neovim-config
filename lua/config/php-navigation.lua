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

-- WordPress-specific path resolution
function M.resolve_wordpress_path(fname)
  -- Clean up the filename (remove quotes and whitespace)
  fname = fname:gsub("^['\"]", ""):gsub("['\"]$", ""):gsub("^%s+", ""):gsub("%s+$", "")
  
  -- Get current file's directory to understand WordPress structure
  local current_file = vim.fn.expand('%:p')
  local current_dir = vim.fn.expand('%:p:h')
  
  -- Try to detect WordPress theme root by looking for common WordPress files
  local function find_theme_root(start_dir)
    local dir = start_dir
    for _ = 1, 10 do  -- Limit search depth
      -- Check for WordPress theme indicators
      local style_css = dir .. "/style.css"
      local functions_php = dir .. "/functions.php"
      local index_php = dir .. "/index.php"
      
      if vim.fn.filereadable(style_css) == 1 or
         vim.fn.filereadable(functions_php) == 1 or
         vim.fn.filereadable(index_php) == 1 then
        return dir
      end
      
      -- Move up one directory
      local parent = vim.fn.fnamemodify(dir, ":h")
      if parent == dir then break end  -- Reached root
      dir = parent
    end
    return start_dir  -- Fallback to original directory
  end
  
  local theme_root = find_theme_root(current_dir)
  vim.notify(string.format("[PHP NAV DEBUG] Theme root detected: %s", theme_root), vim.log.levels.DEBUG)
  
  -- WordPress template part paths (relative to theme root)
  local wp_paths = {
    "",  -- Current directory
    "./",
    theme_root .. "/",
    theme_root .. "/template-parts/",
    theme_root .. "/parts/",
    theme_root .. "/templates/",
    theme_root .. "/inc/",
    theme_root .. "/includes/",
    theme_root .. "/components/",
    theme_root .. "/blocks/",
    theme_root .. "/partials/",
  }
  
  -- Try WordPress-specific extensions first
  local wp_extensions = { ".php", "-template.php", ".template.php", ".part.php" }
  
  -- Try the filename as-is first
  if vim.fn.filereadable(fname) == 1 then
    return fname
  end
  
  -- Try with WordPress extensions
  for _, ext in ipairs(wp_extensions) do
    if not fname:match("%.php$") then
      local with_ext = fname .. ext
      if vim.fn.filereadable(with_ext) == 1 then
        return with_ext
      end
    end
  end
  
  -- Try WordPress-specific paths
  for _, base_path in ipairs(wp_paths) do
    local full_path = base_path .. fname
    if vim.fn.filereadable(full_path) == 1 then
      vim.notify(string.format("[PHP NAV DEBUG] Found file: %s", full_path), vim.log.levels.DEBUG)
      return full_path
    end
    
    -- Also try with WordPress extensions
    for _, ext in ipairs(wp_extensions) do
      if not fname:match("%.php$") then
        local with_ext = full_path .. ext
        if vim.fn.filereadable(with_ext) == 1 then
          vim.notify(string.format("[PHP NAV DEBUG] Found file with extension: %s", with_ext), vim.log.levels.DEBUG)
          return with_ext
        end
      end
    end
  end
  
  -- Fallback to standard PHP resolution
  return M.resolve_php_path(fname)
end

-- Helper function to find similar files
function M.find_similar_files(cfile)
  local suggestions = {}
  
  -- Get current file's directory to understand WordPress structure
  local current_dir = vim.fn.expand('%:p:h')
  local theme_root = M.find_theme_root(current_dir)
  
  -- Try to find similar files in the theme directory
  local base_name = vim.fn.fnamemodify(cfile, ":t:r")  -- Get filename without extension
  local find_cmd = string.format("find '%s' -name '*%s*.php' 2>/dev/null | head -10", theme_root, base_name)
  local similar_files = vim.fn.systemlist(find_cmd)
  
  if #similar_files > 0 then
    table.insert(suggestions, "Similar files found in theme:")
    for _, file in ipairs(similar_files) do
      -- Make path relative to theme root for readability
      local relative_path = file:gsub("^" .. vim.pesc(theme_root) .. "/", "")
      table.insert(suggestions, "  " .. relative_path)
    end
  end
  
  -- Smart WordPress template suggestions based on theme structure
  local smart_patterns = {
    theme_root .. "/" .. cfile .. ".php",
    theme_root .. "/template-parts/" .. cfile .. ".php",
    theme_root .. "/parts/" .. cfile .. ".php",
    theme_root .. "/templates/" .. cfile .. ".php",
    theme_root .. "/" .. cfile .. "-template.php",
  }
  
  table.insert(suggestions, "")
  table.insert(suggestions, "Suggested WordPress template paths:")
  for _, pattern in ipairs(smart_patterns) do
    local relative_pattern = pattern:gsub("^" .. vim.pesc(theme_root) .. "/", "")
    if vim.fn.filereadable(pattern) == 1 then
      table.insert(suggestions, "  ✓ " .. relative_pattern .. " (EXISTS)")
    else
      table.insert(suggestions, "  ✗ " .. relative_pattern)
    end
  end
  
  return suggestions
end

-- Helper function to find WordPress theme root (extracted for reuse)
function M.find_theme_root(start_dir)
  local dir = start_dir
  for _ = 1, 10 do  -- Limit search depth
    -- Check for WordPress theme indicators
    local style_css = dir .. "/style.css"
    local functions_php = dir .. "/functions.php"
    local index_php = dir .. "/index.php"
    
    if vim.fn.filereadable(style_css) == 1 or
       vim.fn.filereadable(functions_php) == 1 or
       vim.fn.filereadable(index_php) == 1 then
      return dir
    end
    
    -- Move up one directory
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then break end  -- Reached root
    dir = parent
  end
  return start_dir  -- Fallback to original directory
end

-- Enhanced gf function for PHP files with WordPress template support
function M.goto_php_file()
  -- Add comprehensive error handling to prevent crashes
  local success, result = pcall(function()
    local cfile = vim.fn.expand('<cfile>')
    local line = vim.fn.getline('.')
    
    -- Log debug information
    vim.notify(string.format("[PHP NAV DEBUG] Starting navigation - cfile: '%s', line: '%s'", cfile, line), vim.log.levels.DEBUG)
    
    if cfile == "" then
      -- Enhanced patterns including WordPress template functions
      local patterns = {
        -- WordPress template functions
        "get_template_part%(['\"]([^'\"]+)['\"]",                    -- get_template_part('path')
        "get_template_part%(['\"]([^'\"]+)['\"]%s*,%s*['\"]([^'\"]+)['\"]", -- get_template_part('path', 'name')
        "locate_template%(['\"]([^'\"]+)['\"]",                      -- locate_template('path')
        "load_template%(['\"]([^'\"]+)['\"]",                        -- load_template('path')
        
        -- Standard PHP includes
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
        local match1, match2 = line:match(pattern)
        if match1 then
          -- Handle WordPress get_template_part with two parameters
          if match2 then
            cfile = match1 .. "-" .. match2  -- Combine path and name
          else
            cfile = match1
          end
          -- Clean up the match (remove quotes and whitespace)
          cfile = cfile:gsub("^['\"]", ""):gsub("['\"]$", ""):gsub("^%s+", ""):gsub("%s+$", "")
          vim.notify(string.format("[PHP NAV DEBUG] Extracted from pattern: '%s'", cfile), vim.log.levels.DEBUG)
          break
        end
      end
    end
    
    if cfile == "" then
      vim.notify("No file found under cursor", vim.log.levels.WARN)
      return
    end
    
    -- WordPress-specific path resolution
    local resolved_path = M.resolve_wordpress_path(cfile)
    
    vim.notify(string.format("[PHP NAV DEBUG] Resolved path: '%s'", resolved_path), vim.log.levels.DEBUG)
    
    if vim.fn.filereadable(resolved_path) == 1 then
      vim.cmd('edit ' .. vim.fn.fnameescape(resolved_path))
      vim.notify(string.format("[PHP NAV] Opened: %s", resolved_path), vim.log.levels.INFO)
    else
      -- Show helpful error message with suggestions
      local suggestions = M.find_similar_files(cfile)
      
      local error_msg = string.format(
        "File not found: %s\nResolved to: %s\n%s",
        cfile,
        resolved_path,
        table.concat(suggestions, "\n")
      )
      
      vim.notify(error_msg, vim.log.levels.ERROR)
    end
  end)
  
  if not success then
    vim.notify(string.format("[PHP NAV ERROR] Navigation failed: %s", result), vim.log.levels.ERROR)
    -- Fallback to default gf behavior
    pcall(function() vim.cmd('normal! gf') end)
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
  -- Wrap setup in error handling to prevent crashes
  local success, error_msg = pcall(function()
    -- Set up includeexpr with WordPress support
    vim.opt_local.includeexpr = "v:lua.require('config.php-navigation').resolve_wordpress_path(v:fname)"
    
    -- Set up path with WordPress-specific directories
    local all_paths = vim.tbl_extend("force", M.php_paths, {
      "template-parts/",
      "parts/",
      "templates/",
      "components/",
      "blocks/",
      "partials/",
    })
    
    for _, path in ipairs(all_paths) do
      vim.opt_local.path:append(path .. "**")
    end
    
    -- Set suffixes including WordPress patterns
    vim.opt_local.suffixesadd:prepend(".php")
    vim.opt_local.suffixesadd:prepend(".inc")
    vim.opt_local.suffixesadd:prepend(".class.php")
    vim.opt_local.suffixesadd:prepend("-template.php")
    vim.opt_local.suffixesadd:prepend(".template.php")
    vim.opt_local.suffixesadd:prepend(".part.php")
    
    -- Set up keymaps with error handling
    vim.keymap.set('n', 'gf', function()
      local ok, err = pcall(M.goto_php_file)
      if not ok then
        vim.notify(string.format("[PHP NAV ERROR] gf failed: %s", err), vim.log.levels.ERROR)
        -- Fallback to default gf
        pcall(function() vim.cmd('normal! gf') end)
      end
    end, {
      buffer = true,
      desc = "Go to PHP/WordPress file (safe)"
    })
    
    vim.keymap.set('n', '<C-w>f', function()
      local ok, err = pcall(M.goto_php_file_split)
      if not ok then
        vim.notify(string.format("[PHP NAV ERROR] <C-w>f failed: %s", err), vim.log.levels.ERROR)
        -- Fallback to default behavior
        pcall(function() vim.cmd('normal! <C-w>f') end)
      end
    end, {
      buffer = true,
      desc = "Go to PHP/WordPress file in split (safe)"
    })
    
    vim.keymap.set('n', '<leader>pf', M.debug_php_path, {
      buffer = true,
      desc = "Debug PHP file path"
    })
    
    -- Only show setup message once per session
    if not vim.g.php_nav_setup_complete then
      vim.notify("[PHP NAV] WordPress-enhanced navigation setup complete", vim.log.levels.INFO)
      vim.g.php_nav_setup_complete = true
    end
  end)
  
  if not success then
    vim.notify(string.format("[PHP NAV ERROR] Setup failed: %s", error_msg), vim.log.levels.ERROR)
    -- Fallback to basic setup
    vim.opt_local.suffixesadd:prepend(".php")
  end
end

return M