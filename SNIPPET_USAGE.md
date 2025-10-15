# Snippet Usage Guide

## How to Execute Snippets

### Method 1: Using Completion Menu (Recommended)

1. **Type the snippet trigger** (e.g., `dump`)
2. **Completion menu appears** showing available snippets
3. **Navigate with keys**:
   - `<Tab>` - Move to next item
   - `<S-Tab>` - Move to previous item
   - `<C-n>` - Move to next item (alternative)
   - `<C-p>` - Move to previous item (alternative)
4. **Press `<CR>` (Enter)** to execute the selected snippet
5. **Navigate placeholders**:
   - `<Tab>` - Jump to next placeholder
   - `<S-Tab>` - Jump to previous placeholder

### Method 2: Direct Expansion

1. **Type the snippet trigger** (e.g., `dump`)
2. **Press `<C-l>`** to expand the snippet directly
3. **Use `<C-l>` and `<C-h>`** to navigate between placeholders

## Available PHP Snippets

| Trigger    | Description           | Output                   |
| ---------- | --------------------- | ------------------------ |
| `dump`     | Laravel dump function | `dump($variable);`       |
| `dd`       | Laravel dump and die  | `dd($variable);`         |
| `var_dump` | PHP var_dump          | `var_dump($variable);`   |
| `print_r`  | PHP print_r           | `print_r($variable);`    |
| `echo`     | PHP echo statement    | `echo "Hello World";`    |
| `php`      | PHP opening tag       | `<?php`                  |
| `class`    | PHP class template    | Full class structure     |
| `function` | PHP function template | Function with parameters |
| `foreach`  | PHP foreach loop      | Foreach loop structure   |
| `if`       | PHP if statement      | If condition block       |
| `try`      | PHP try-catch         | Try-catch block          |

## Troubleshooting

### Snippet Not Appearing

- Ensure you're in a PHP file (`.php` extension)
- Check that the filetype is set correctly: `:set filetype?`
- Verify snippets are loaded: `:lua print(vim.inspect(require('luasnip').get_snippets('php')))`

### Can't Execute Snippet

- Make sure you're in **Insert mode** (`i` or `a`)
- Try using `<CR>` (Enter) to confirm selection
- Alternative: Use `<C-l>` for direct expansion

### Snippet Doesn't Expand

- Check if completion menu is visible
- Try typing more characters to trigger completion
- Use `<C-Space>` to manually trigger completion

## Key Bindings Summary

| Key         | Mode          | Action                                           |
| ----------- | ------------- | ------------------------------------------------ |
| `<CR>`      | Insert        | Accept selected completion/snippet               |
| `<Tab>`     | Insert        | Next completion item OR next snippet placeholder |
| `<S-Tab>`   | Insert        | Previous completion item OR previous placeholder |
| `<C-l>`     | Insert/Select | Expand snippet OR jump to next placeholder       |
| `<C-h>`     | Insert/Select | Jump to previous snippet placeholder             |
| `<C-Space>` | Insert        | Manually trigger completion                      |
| `<C-e>`     | Insert        | Abort completion                                 |

## Example Workflow

1. Open a PHP file
2. Enter Insert mode (`i`)
3. Type `dump`
4. See completion menu appear
5. **Press `<Tab>`** to execute (or use `<CR>`)
6. Type your variable name in the placeholder
7. Press `<Tab>` to move to next placeholder (if any)

## Fixed Tab Navigation

The Tab key now works correctly:

- **When completion menu is visible**: `<Tab>` executes the selected snippet
- **When in snippet mode**: `<Tab>` jumps to next placeholder
- **Use `<C-j>`/`<C-k>`** to navigate completion menu items
