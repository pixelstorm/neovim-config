# 🪲 Neovim Configuration Debugging Guide

This guide helps you diagnose and fix the two critical issues you're experiencing:

1. **Neovim crashes when using `gf` on WordPress template paths**
2. **Only 6/50 plugins loading at startup**

## 🚨 **IMMEDIATE FIXES IMPLEMENTED**

### ✅ **WordPress Template Navigation Crash - FIXED**

**Problem**: `gf` command crashed when trying to navigate to WordPress template parts like:

```php
<?php get_template_part('template-parts/services/local-seo/section', 'faq'); ?>
```

**Solution**: Enhanced PHP navigation with comprehensive error handling and WordPress-specific path resolution.

**What was added**:

- WordPress template function pattern recognition
- Safe error handling with fallback to default `gf` behavior
- Enhanced path resolution for WordPress template structures
- Comprehensive logging for debugging

### ✅ **Enhanced Error Handling - IMPLEMENTED**

All navigation functions now have:

- `pcall()` wrappers to prevent crashes
- Detailed error logging
- Automatic fallback to default Neovim behavior
- WordPress-specific path patterns

## 🔍 **DIAGNOSTIC COMMANDS**

### **1. Run Full Plugin Diagnostics**

```vim
:lua require('config.plugin-diagnostics').run_full_diagnostics()
```

This will show you:

- Which plugins are loaded vs not loaded
- Dependency conflicts
- Configuration errors
- Startup performance metrics

### **2. Force Load All Plugins (Debug)**

```vim
:lua require('config.plugin-diagnostics').force_load_all()
```

Attempts to manually load all plugins and reports which ones fail.

### **3. Check Plugin File Structure**

```vim
:lua require('config.plugin-diagnostics').check_plugin_files()
```

Validates all plugin configuration files for syntax errors.

### **4. Test WordPress Navigation**

```vim
:lua require('config.plugin-diagnostics').validate_lazy_config()
```

In a PHP file with WordPress template calls, try:

- `gf` on a `get_template_part()` line
- `<leader>pf` to debug the path resolution

## 🔧 **STEP-BY-STEP TROUBLESHOOTING**

### **Step 1: Test the WordPress Navigation Fix**

1. **Open a WordPress PHP file** with template calls like:

   ```php
   <?php get_template_part('template-parts/services/local-seo/section', 'faq'); ?>
   ```

2. **Position cursor** on the template path

3. **Press `gf`** - it should now:

   - Either navigate to the file successfully
   - Show helpful error messages instead of crashing
   - Fall back to default behavior safely

4. **Check debug output** with `<leader>pf` to see path resolution details

### **Step 2: Diagnose Plugin Loading Issues**

1. **Run the full diagnostics**:

   ```vim
   :lua require('config.plugin-diagnostics').run_full_diagnostics()
   ```

2. **Look for these common issues**:

   - **Dependency conflicts**: Plugin A requires Plugin B but B failed to load
   - **Configuration errors**: Syntax errors in plugin config files
   - **Lazy loading conditions**: Plugins waiting for triggers that never happen

3. **Check the output for**:
   - How many plugins are actually configured vs loaded
   - Which specific plugins are failing
   - Error messages from failed plugins

### **Step 3: Force Load Plugins (If Needed)**

If diagnostics show plugins that should load but don't:

```vim
:lua require('config.plugin-diagnostics').force_load_all()
```

This will attempt to manually load each plugin and show specific error messages.

## 🎯 **MOST LIKELY CAUSES & SOLUTIONS**

### **Plugin Loading Issues**

Based on the configuration analysis, here are the most likely causes:

#### **1. Lazy Loading Configuration Problem**

**Symptom**: Plugins configured but not loading
**Cause**: `lazy = false` in config but plugins still not loading
**Solution**: Check for dependency chain failures

#### **2. Laravel.nvim Dependency Issue**

**Symptom**: Laravel plugin and dependents failing
**Cause**: `nvim-nio` dependency issues
**Fix**: Already implemented error handling, but may need manual installation

#### **3. LSP Buffer Number Validation**

**Symptom**: LSP-related plugins failing to load
**Cause**: Buffer number validation errors
**Fix**: Already implemented comprehensive patches

## 🚀 **TESTING YOUR FIXES**

### **Test WordPress Navigation**

1. Open any WordPress PHP file
2. Find a line with `get_template_part()`
3. Position cursor on the file path
4. Press `gf` - should work without crashing

### **Test Plugin Loading**

1. Restart Neovim
2. Run `:Lazy` to see plugin status
3. Check if more than 6 plugins are loaded
4. Run diagnostics to identify remaining issues

## 📊 **EXPECTED RESULTS**

After implementing these fixes:

### **WordPress Navigation**

- ✅ No more crashes on `gf`
- ✅ Helpful error messages when files not found
- ✅ WordPress template path recognition
- ✅ Fallback to default behavior when needed

### **Plugin Loading**

- 🔍 Clear diagnostic information about what's failing
- 🔍 Specific error messages for each failed plugin
- 🔍 Dependency conflict identification
- 🔍 Path to fixing remaining issues

## 🆘 **IF ISSUES PERSIST**

### **WordPress Navigation Still Crashes**

1. Check if the enhanced navigation is loading:

   ```vim
   :lua print(vim.inspect(require('config.php-navigation')))
   ```

2. Verify the ftplugin is working:
   ```vim
   :set filetype?
   ```
   Should show `filetype=php` in PHP files

### **Plugin Loading Still Poor**

1. Run diagnostics and share the output
2. Check for specific error messages
3. Try loading individual plugins manually:
   ```vim
   :Lazy load plugin-name
   ```

## 📝 **LOGGING AND DEBUG INFO**

### **Enable Debug Logging**

```vim
:set verbose=1
```

### **Check Messages**

```vim
:messages
```

### **WordPress Navigation Debug**

In a PHP file, use `<leader>pf` to see detailed path resolution information.

---

## 🎉 **SUMMARY OF FIXES**

### ✅ **Implemented Solutions**

1. **WordPress template navigation crash** - Fixed with comprehensive error handling
2. **Enhanced path resolution** - WordPress-specific template patterns
3. **Plugin diagnostics system** - Complete diagnostic toolkit
4. **Error handling throughout** - Prevents crashes, provides helpful messages

### 🔍 **Diagnostic Tools Added**

1. **Full plugin diagnostics** - Identifies loading issues
2. **Force plugin loading** - Tests individual plugin problems
3. **Configuration validation** - Checks for syntax errors
4. **WordPress navigation debugging** - Path resolution details

**Next Steps**: Run the diagnostic commands above to identify and fix the remaining plugin loading issues.
