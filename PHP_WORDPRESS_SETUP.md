# PHP & WordPress Development Setup Guide

This guide covers the enhanced PHP and WordPress development setup for Neovim, including HTML formatting and snippet suggestions within PHP files.

## What's Been Implemented

### 1. Enhanced LSP Configuration

- **HTML LSP** now supports PHP files for embedded HTML formatting
- **Intelephense** re-enabled with WordPress stubs and formatting
- **Emmet LSP** added for HTML snippets in PHP files

### 2. Improved Formatting

- PHP formatting re-enabled with `php-cs-fixer` and `phpcbf`
- Enhanced rules: `@PSR12,@Symfony` with risky fixes allowed
- HTML formatting works within PHP files via Prettier

### 3. Enhanced Completion

- LSP completion re-enabled for PHP files
- Proper priority system: LSP (1000) > LuaSnip (750) > Buffer (500) > Path (250)
- Copilot enabled for PHP, HTML, CSS, SCSS, JavaScript, TypeScript

### 4. New Plugins Added

- **Phpactor**: Advanced PHP language server and refactoring tools
- **Emmet-vim**: Enhanced HTML snippet support in PHP
- **Laravel.nvim**: Modern PHP framework support
- **Vdebug**: PHP debugging support
- **PHP-CS-Fixer**: Code style fixing

### 5. Enhanced File Detection

- Automatic PHP filetype detection for `.php`, `.phtml`, `.inc`
- WordPress-specific detection with proper indentation settings
- Template file detection for `.html.php`, `.template.php`

## Installation Steps

### 1. Install Required Tools

#### Via Mason (Recommended)

```vim
:MasonInstall html-lsp emmet-ls intelephense prettier php-cs-fixer phpcbf phpcs phpstan psalm
```

#### Via System Package Manager

**macOS (Homebrew):**

```bash
brew install php-cs-fixer phpcs phpstan psalm
npm install -g prettier @prettier/plugin-php
```

**Ubuntu/Debian:**

```bash
sudo apt install php-codesniffer
composer global require friendsofphp/php-cs-fixer phpstan/phpstan vimeo/psalm
npm install -g prettier @prettier/plugin-php
```

### 2. WordPress Stubs (Optional but Recommended)

For better WordPress development, install WordPress stubs:

```bash
composer global require php-stubs/wordpress-stubs php-stubs/woocommerce-stubs php-stubs/acf-pro-stubs
```

### 3. Configuration Files

#### PHP-CS-Fixer Configuration

Create `.php-cs-fixer.php` in your project root:

```php
<?php

$finder = PhpCsFixer\Finder::create()
    ->in(__DIR__)
    ->exclude(['vendor', 'node_modules'])
    ->name('*.php')
    ->notName('*.blade.php');

return (new PhpCsFixer\Config())
    ->setRules([
        '@PSR12' => true,
        '@Symfony' => true,
        'array_syntax' => ['syntax' => 'short'],
        'ordered_imports' => ['sort_algorithm' => 'alpha'],
        'no_unused_imports' => true,
        'not_operator_with_successor_space' => true,
        'trailing_comma_in_multiline' => true,
        'phpdoc_scalar' => true,
        'unary_operator_spaces' => true,
        'binary_operator_spaces' => true,
        'blank_line_before_statement' => [
            'statements' => ['break', 'continue', 'declare', 'return', 'throw', 'try'],
        ],
        'phpdoc_single_line_var_spacing' => true,
        'phpdoc_var_without_name' => true,
        'method_argument_space' => [
            'on_multiline' => 'ensure_fully_multiline',
            'keep_multiple_spaces_after_comma' => true,
        ],
    ])
    ->setFinder($finder);
```

#### PHPCS Configuration

Create `phpcs.xml` in your project root:

```xml
<?xml version="1.0"?>
<ruleset name="WordPress Coding Standards">
    <description>WordPress Coding Standards</description>

    <file>.</file>

    <exclude-pattern>vendor/*</exclude-pattern>
    <exclude-pattern>node_modules/*</exclude-pattern>
    <exclude-pattern>*.min.js</exclude-pattern>
    <exclude-pattern>*.min.css</exclude-pattern>

    <rule ref="PSR12"/>
    <rule ref="WordPress-Core"/>
    <rule ref="WordPress-Docs"/>
    <rule ref="WordPress-Extra"/>
</ruleset>
```

## Key Features & Usage

### 1. HTML Formatting in PHP

- HTML within PHP files now gets proper formatting via Prettier
- Use `:Format` or `<leader>cf` to format current buffer
- Auto-formatting on save is enabled by default

### 2. Enhanced Snippets

- **Emmet**: Type HTML abbreviations and expand with `<Tab>`
  - Example: `div.container>ul.list>li*3` + `<Tab>`
- **LuaSnip**: Extensive PHP and WordPress snippets available
  - Example: `add_action` + `<Tab>` for WordPress hooks
- **Copilot**: AI-powered suggestions for PHP and HTML

### 3. LSP Features

- **Go to Definition**: `gd`
- **Find References**: `gr`
- **Hover Documentation**: `K`
- **Code Actions**: `<leader>ca`
- **Rename Symbol**: `<leader>rn`

### 4. Phpactor Features

- **Context Menu**: `<leader>pm`
- **New Class**: `<leader>pn`
- **Expand Class**: `<leader>pe`
- **Move File**: `<leader>pv`
- **Transform Code**: `<leader>pr`

**📋 Phpactor Verification**: See [`PHPACTOR_VERIFICATION.md`](nvim/PHPACTOR_VERIFICATION.md) for detailed installation verification and troubleshooting.

### 5. Debugging

- Vdebug is configured for Xdebug on port 9003
- Set breakpoints with `:Breakpoint`
- Start debugging with `:VdebugStart`

## WordPress-Specific Features

### 1. File Detection

WordPress files are automatically detected and configured with:

- 4-space indentation (WordPress standard)
- Proper filetype detection
- WordPress-specific LSP stubs

### 2. WordPress Stubs

Intelephense is configured with comprehensive WordPress stubs:

- Core WordPress functions
- WooCommerce functions
- ACF Pro functions
- Common plugin functions

### 3. WordPress Snippets

Extensive WordPress snippets are available in [`php.snippets`](nvim/snips/php.snippets):

- `add_action` - WordPress action hooks
- `custom_post_type_cpt` - Custom post type registration
- `acf_image_array` - ACF image field handling
- `wp_nav_menu` - Navigation menu output
- And many more...

## Troubleshooting

### 1. Node.js Version Error for Copilot (FIXED)

**Error**: "[Copilot.lua] Node.js version 22 or newer required but found 14.18.0"
**Impact**: Copilot AI suggestions disabled
**Status**: ✅ **FIXED** - Copilot now automatically detects Node.js v22 from nvm

**What was fixed**:

- Copilot configuration now automatically searches for Node.js v22 in nvm directories
- Falls back to common installation paths if nvm isn't found
- No more manual Node.js path configuration needed

**If you still get Node.js errors**:

**Option 1: Install Node.js v22 via nvm (if not already done)**

```bash
# Install/update to Node.js v22
nvm install 22
nvm use 22
nvm alias default 22

# Verify version
node --version  # Should show v22.x.x
```

**Option 2: Manual path override (if auto-detection fails)**

```lua
-- In copilot.lua, override the auto-detection
copilot_node_command = '/path/to/your/node22', -- e.g., '/usr/local/bin/node'
```

### 2. Leader Key Errors (FIXED)

**Error**: "You need to set `vim.g.mapleader` **BEFORE** loading lazy"
**Solution**: Leader keys are now set in `init.lua` before lazy loads. This has been fixed.

### 2. Laravel.nvim Dependency Error (FIXED)

**Error**: "Nio is required for Laravel, please install it"
**Solution**: The `nvim-nio` dependency has been added. If you still get errors:

```vim
:Lazy install nvim-neotest/nvim-nio
```

### 3. Treesitter Deprecation Warning (FIXED)

**Warning**: "vim.treesitter.language.require_language() is deprecated"
**Solution**: Updated to use the new treesitter API. This warning has been resolved.

### 4. LSP Not Working

```vim
:LspInfo
:Mason
```

Check if language servers are installed and running.

### 5. Formatting Not Working

```vim
:ConformInfo
```

Verify formatters are installed and configured.

### 6. Snippets Not Expanding

- Ensure LuaSnip is loaded: `:Lazy`
- Check snippet files are in the correct location
- Verify filetype detection: `:set filetype?`

### 7. Copilot Not Suggesting

```vim
:Copilot status
:Copilot auth
```

### 8. Plugin Loading Issues

If you encounter plugin loading issues:

```vim
:Lazy clean
:Lazy sync
```

Then restart Neovim.

## File Structure

```
nvim/
├── lua/
│   ├── config/
│   │   └── options.lua          # Enhanced file detection
│   └── plugins/
│       ├── lsp.lua              # Enhanced LSP config
│       ├── conform.lua          # Enhanced formatting
│       ├── cmp.lua              # Enhanced completion
│       ├── copilot.lua          # Enhanced Copilot
│       └── php-wordpress.lua    # New PHP/WordPress plugins
├── snips/
│   ├── php.snippets             # Extensive PHP snippets
│   ├── php.wordpress.snippets   # WordPress-specific snippets
│   └── html.snippets            # HTML snippets
└── PHP_WORDPRESS_SETUP.md       # This guide
```

## Next Steps

1. **Restart Neovim** to load all changes
2. **Install tools** via Mason or system package manager
3. **Test formatting** on a PHP file with HTML content
4. **Try snippets** - type `add_action` and press Tab
5. **Test Copilot** - start typing PHP/HTML code
6. **Configure project-specific** settings as needed

## Additional Resources

- [Intelephense Documentation](https://intelephense.com/)
- [PHP-CS-Fixer Rules](https://cs.symfony.com/doc/rules/index.html)
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)
- [Emmet Cheat Sheet](https://docs.emmet.io/cheat-sheet/)
