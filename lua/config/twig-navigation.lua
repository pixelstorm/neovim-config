-- Enhanced Twig navigation configuration
-- Handles complex Twig namespace patterns and project structures

local M = {}

-- Project-specific namespace mappings
-- You can customize these based on your project structure
M.namespace_mappings = {
  cwa_components = "templates/components",
  components = "templates/components",
  layouts = "templates/layouts", 
  partials = "templates/partials",
  macros = "templates/macros",
  forms = "templates/forms",
  emails = "templates/emails",
  base = "templates/base",
  admin = "templates/admin",
}

-- Common template search paths (in order of preference)
M.template_paths = {
  "templates/",
  "src/templates/",
  "app/templates/",
  "resources/templates/",
  "views/",
  "src/views/",
  "app/views/",
  "",  -- Current directory
}

-- Function to resolve Twig namespace paths
function M.resolve_twig_path(fname)
  -- Clean up the filename (remove quotes and whitespace)
  fname = fname:gsub("^['\"]", ""):gsub("['\"]$", ""):gsub("^%s+", ""):gsub("%s+$", "")
  
  -- Handle namespace syntax @namespace/path/file.twig
  if fname:match("^@") then
    local namespace, path = fname:match("^@([^/]+)/(.+)$")
    if namespace and path then
      -- Try mapped namespace first
      local base_path = M.namespace_mappings[namespace]
      if base_path then
        local full_path = base_path .. "/" .. path
        if vim.fn.filereadable(full_path) == 1 then
          return full_path
        end
      end
      
      -- Try common patterns for unmapped namespaces
      local fallback_patterns = {
        "templates/" .. namespace .. "/" .. path,
        "src/templates/" .. namespace .. "/" .. path,
        "app/templates/" .. namespace .. "/" .. path,
        "resources/templates/" .. namespace .. "/" .. path,
        namespace .. "/" .. path,
      }
      
      for _, pattern in ipairs(fallback_patterns) do
        if vim.fn.filereadable(pattern) == 1 then
          return pattern
        end
      end
    end
  end
  
  -- Handle regular paths (non-namespace)
  if not fname:match("^/") then
    for _, base_path in ipairs(M.template_paths) do
      local full_path = base_path .. fname
      if vim.fn.filereadable(full_path) == 1 then
        return full_path
      end
      
      -- Also try with .twig extension if not present
      if not fname:match("%.twig$") then
        local with_ext = full_path .. ".twig"
        if vim.fn.filereadable(with_ext) == 1 then
          return with_ext
        end
        
        local with_html_ext = full_path .. ".html.twig"
        if vim.fn.filereadable(with_html_ext) == 1 then
          return with_html_ext
        end
      end
    end
  end
  
  return fname
end

-- Enhanced gf function with better error handling
function M.goto_twig_file()
  local cfile = vim.fn.expand('<cfile>')
  if cfile == "" then
    -- Try to extract filename from current line if <cfile> is empty
    local line = vim.fn.getline('.')
    local patterns = {
      "{% include ['\"]([^'\"]+)['\"]",  -- {% include 'file.twig' %}
      "{% extends ['\"]([^'\"]+)['\"]",  -- {% extends 'file.twig' %}
      "{% embed ['\"]([^'\"]+)['\"]",    -- {% embed 'file.twig' %}
      "@([^/]+/[^'\"\\s}]+)",            -- @namespace/path/file.twig
    }
    
    for _, pattern in ipairs(patterns) do
      local match = line:match(pattern)
      if match then
        cfile = match
        break
      end
    end
  end
  
  if cfile == "" then
    vim.notify("No file found under cursor", vim.log.levels.WARN)
    return
  end
  
  local resolved_path = M.resolve_twig_path(cfile)
  
  if vim.fn.filereadable(resolved_path) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(resolved_path))
  else
    -- Show helpful error message with suggestions
    local suggestions = {}
    
    -- Try to find similar files
    local base_name = vim.fn.fnamemodify(cfile, ":t:r")  -- Get filename without extension
    local find_cmd = "find . -name '*" .. base_name .. "*.twig' 2>/dev/null | head -5"
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
function M.goto_twig_file_split()
  local cfile = vim.fn.expand('<cfile>')
  local resolved_path = M.resolve_twig_path(cfile)
  
  if vim.fn.filereadable(resolved_path) == 1 then
    vim.cmd('split ' .. vim.fn.fnameescape(resolved_path))
  else
    M.goto_twig_file()  -- Fall back to regular function for error handling
  end
end

-- Debug function
function M.debug_twig_path()
  local cfile = vim.fn.expand('<cfile>')
  local resolved_path = M.resolve_twig_path(cfile)
  
  print("=== Twig Path Debug ===")
  print("Original: " .. cfile)
  print("Resolved: " .. resolved_path)
  print("Readable: " .. (vim.fn.filereadable(resolved_path) == 1 and "Yes" or "No"))
  print("Current directory: " .. vim.fn.getcwd())
  
  -- Show namespace mappings
  print("\nNamespace mappings:")
  for ns, path in pairs(M.namespace_mappings) do
    print("  @" .. ns .. " -> " .. path)
  end
end

-- Setup function to be called from ftplugin
function M.setup()
  -- Set up includeexpr
  vim.opt_local.includeexpr = "v:lua.require('config.twig-navigation').resolve_twig_path(v:fname)"
  
  -- Set up path
  for _, path in ipairs(M.template_paths) do
    vim.opt_local.path:append(path .. "**")
  end
  
  -- Set suffixes
  vim.opt_local.suffixesadd:prepend(".twig")
  vim.opt_local.suffixesadd:prepend(".html.twig")
  
  -- Set up keymaps
  vim.keymap.set('n', 'gf', M.goto_twig_file, { 
    buffer = true, 
    desc = "Go to Twig file" 
  })
  
  vim.keymap.set('n', '<C-w>f', M.goto_twig_file_split, { 
    buffer = true, 
    desc = "Go to Twig file in split" 
  })
  
  vim.keymap.set('n', '<leader>tf', M.debug_twig_path, { 
    buffer = true, 
    desc = "Debug Twig file path" 
  })
end

return M