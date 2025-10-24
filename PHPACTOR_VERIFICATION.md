# Phpactor Installation & Verification Guide

This guide helps you verify that Phpactor is properly installed and working in your Neovim setup.

## What is Phpactor?

Phpactor is a powerful PHP language server and refactoring tool that provides:

- Advanced code completion
- Refactoring capabilities
- Class generation
- File navigation
- Code transformation

## Current Configuration

Two Phpactor plugins are configured:

1. **phpactor/phpactor** - The main Phpactor tool
2. **gbprod/phpactor.nvim** - Neovim integration wrapper

## Verification Steps

### 1. Check Plugin Installation

```vim
:Lazy
```

Look for these plugins in the Lazy plugin manager:

- ✅ `phpactor/phpactor`
- ✅ `gbprod/phpactor.nvim`

### 2. Check System Requirements

Phpactor requires:

- **PHP 8.0+** (check with `php --version`)
- **Composer** (check with `composer --version`)

```bash
# Check PHP version
php --version

# Check Composer
composer --version
```

### 3. Verify Phpactor Installation

Open a PHP file and run:

```vim
:PhpactorStatus
```

If this command doesn't exist, Phpactor isn't loaded. Try:

```vim
:Lazy reload phpactor/phpactor
:Lazy reload gbprod/phpactor.nvim
```

### 4. Test Phpactor Commands

Open a PHP file and test these key mappings:

| Keymap       | Command                | Description       |
| ------------ | ---------------------- | ----------------- |
| `<leader>pm` | `:PhpactorContextMenu` | Open context menu |
| `<leader>pn` | `:PhpactorClassNew`    | Create new class  |
| `<leader>pe` | `:PhpactorClassExpand` | Expand class      |
| `<leader>pv` | `:PhpactorMoveFile`    | Move file         |
| `<leader>pc` | `:PhpactorCopyFile`    | Copy file         |
| `<leader>pr` | `:PhpactorTransform`   | Transform code    |

### 5. Test Context Menu

1. Open a PHP file
2. Place cursor on a class name or method
3. Press `<leader>pm`
4. You should see a context menu with options like:
   - Go to definition
   - Find references
   - Generate method
   - Extract method
   - etc.

## Troubleshooting

### Issue 1: "PhpactorContextMenu command not found"

**Cause**: Phpactor plugin not loaded or PHP file not detected

**Solutions**:

```vim
# Check if in PHP file
:set filetype?

# Manually load Phpactor
:Lazy load phpactor/phpactor

# Check available commands
:command Phpactor
```

### Issue 2: "Composer not found"

**Cause**: Composer not installed or not in PATH

**Solutions**:

```bash
# Install Composer (macOS)
brew install composer

# Install Composer (Linux)
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Verify installation
composer --version
```

### Issue 3: "PHP version too old"

**Cause**: PHP version < 8.0

**Solutions**:

```bash
# Update PHP (macOS)
brew install php@8.2
brew link php@8.2

# Update PHP (Ubuntu)
sudo apt update
sudo apt install php8.2

# Verify version
php --version
```

### Issue 4: Phpactor build fails

**Cause**: Build process failed during plugin installation

**Solutions**:

```vim
# Clean and reinstall
:Lazy clean
:Lazy install

# Manual build (if needed)
# Navigate to: ~/.local/share/nvim/lazy/phpactor/
# Run: composer install --no-dev -o
```

### Issue 5: Context menu empty or not working

**Cause**: Phpactor not properly analyzing the project

**Solutions**:

1. Ensure you're in a PHP project directory
2. Create a `composer.json` file if missing:

```json
{
  "name": "my-project/php-project",
  "require": {
    "php": ">=8.0"
  }
}
```

3. Run `:PhpactorIndexer` to rebuild index

## Manual Installation Verification

If automatic installation fails, you can manually verify:

### 1. Check Phpactor Binary

```bash
# Check if Phpactor binary exists
ls ~/.local/share/nvim/lazy/phpactor/bin/phpactor

# Test Phpactor directly
~/.local/share/nvim/lazy/phpactor/bin/phpactor --version
```

### 2. Manual Build

```bash
cd ~/.local/share/nvim/lazy/phpactor/
composer install --no-dev -o
```

### 3. Test Phpactor Commands

```bash
# Test basic functionality
~/.local/share/nvim/lazy/phpactor/bin/phpactor status
```

## Expected Behavior

When Phpactor is working correctly:

1. **Context Menu**: `<leader>pm` shows a menu with PHP-specific actions
2. **Class Creation**: `<leader>pn` prompts for new class details
3. **Code Navigation**: Can jump to definitions and find references
4. **Refactoring**: Can extract methods, rename variables, etc.
5. **No Error Messages**: No Phpactor-related errors in `:messages`

## Integration with Other Tools

Phpactor works alongside:

- **Intelephense**: Primary LSP (Phpactor LSP is disabled in config)
- **PHP-CS-Fixer**: Code formatting
- **Copilot**: AI suggestions
- **Telescope**: File navigation

## Performance Notes

- Phpactor may take time to index large projects
- First-time usage might be slower as it builds the index
- Consider excluding `vendor/` directories for better performance

## Getting Help

If Phpactor still isn't working:

1. Check `:messages` for error details
2. Run `:checkhealth` for general Neovim health
3. Check Phpactor logs (if available)
4. Consult [Phpactor documentation](https://phpactor.readthedocs.io/)

## Quick Test Script

Create this test PHP file to verify Phpactor functionality:

```php
<?php

class TestClass
{
    private $property;

    public function testMethod()
    {
        return $this->property;
    }
}

$test = new TestClass();
```

1. Open this file in Neovim
2. Place cursor on `TestClass`
3. Press `<leader>pm`
4. You should see context menu options

If the context menu appears with relevant options, Phpactor is working correctly!

## Resolving Your Specific PhpactorStatus Issues

Based on your PhpactorStatus output, here are targeted solutions:

### ✘ Issue: "Composer not found"

**Problem**: Composer not detected in your WordPress theme directory
**Impact**: Class creation and some refactoring features won't work optimally

**Solutions**:

1. **Add composer.json to your theme** (Recommended for WordPress themes):

```bash
cd /Users/pixelstorm/wp_playground/pxs/wp-content/themes/pixelstorm
```

Create `composer.json`:

```json
{
  "name": "pixelstorm/wordpress-theme",
  "description": "Pixelstorm WordPress Theme",
  "type": "wordpress-theme",
  "require": {
    "php": ">=8.0"
  },
  "require-dev": {
    "php-stubs/wordpress-stubs": "^6.0",
    "php-stubs/woocommerce-stubs": "^8.0",
    "phpstan/phpstan": "^1.0"
  },
  "autoload": {
    "psr-4": {
      "Pixelstorm\\Theme\\": "inc/"
    }
  }
}
```

Then run:

```bash
composer install
```

2. **Alternative: Work from project root** (if you have a main composer.json):

```bash
cd /Users/pixelstorm/wp_playground/pxs
# Open Neovim from here instead
```

### ✘ Issue: "Path not trusted"

**Problem**: Phpactor won't load configuration from untrusted paths
**Impact**: Project-specific Phpactor settings won't be loaded

**Solutions**:

1. **Create global Phpactor config** (Recommended):

```bash
mkdir -p ~/.config/phpactor
```

Create `~/.config/phpactor/phpactor.json`:

```json
{
  "language_server_phpstan.enabled": false,
  "language_server_psalm.enabled": false,
  "code_transform.import_globals": true,
  "worse_reflection.enable_cache": true,
  "indexer.enabled": true,
  "indexer.include_patterns": ["**/*.php"],
  "indexer.exclude_patterns": [
    "**/vendor/**",
    "**/node_modules/**",
    "**/.git/**"
  ],
  "symfony.enabled": false,
  "wordpress.enabled": true
}
```

2. **Trust the specific path** (if you want project-specific config):

```bash
# Add to your shell profile (~/.zshrc or ~/.bashrc)
export PHPACTOR_TRUSTED_PATHS="/Users/pixelstorm/wp_playground"
```

Then restart your terminal and Neovim.

### ✘ Issue: Missing config files (Optional)

**Problem**: No Phpactor config files found
**Impact**: Using default settings (usually fine)

**Solution** (Optional - only if you want custom settings):

Create `~/.config/phpactor/phpactor.yml`:

```yaml
# WordPress-specific settings
wordpress.enabled: true
code_transform.import_globals: true
worse_reflection.enable_cache: true

# Indexer settings for better performance
indexer.enabled: true
indexer.include_patterns:
  - "**/*.php"
indexer.exclude_patterns:
  - "**/vendor/**"
  - "**/node_modules/**"
  - "**/.git/**"

# Disable conflicting language servers (we use Intelephense)
language_server_phpstan.enabled: false
language_server_psalm.enabled: false
```

## Verification After Fixes

After applying the fixes, run:

```vim
:PhpactorStatus
```

You should see:

- ✔ Composer detected
- ✔ Git detected
- ✔ XDebug is disabled
- ✔ Configuration loaded (if you added config files)

## WordPress Theme Development Tips

For WordPress theme development with Phpactor:

1. **Use proper PHP namespaces** in your theme's `inc/` directory
2. **Create classes for theme functionality** (easier to refactor)
3. **Use Phpactor's class generation**: `<leader>pn` to create new classes
4. **Leverage context menu**: `<leader>pm` for refactoring options

## Quick WordPress Theme Setup

If you want to optimize your theme for Phpactor:

```bash
cd /path/to/your/theme
composer init
composer require --dev php-stubs/wordpress-stubs
composer require --dev php-stubs/woocommerce-stubs
```

This gives you better autocompletion and refactoring for WordPress functions.

## Current Status Summary

✅ **Phpactor is installed and working** - Version 4fd7d1fb detected
✅ **Git integration working** - Faster refactorings enabled  
✅ **XDebug disabled** - Good for performance
✘ **Composer missing** - Follow solutions above to fix
✘ **Path not trusted** - Follow solutions above to fix

**Bottom Line**: Phpactor is functional but will work much better after adding composer.json and configuring trusted paths.
