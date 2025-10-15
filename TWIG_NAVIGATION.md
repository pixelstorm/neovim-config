# Twig Navigation Guide

This configuration enhances Neovim's ability to navigate Twig template files, especially those using namespace syntax.

## Features

### Enhanced `gf` Command

The `gf` (go to file) command now works with:

- Twig namespace syntax: `@cwa_components/icons/arrow.twig`
- Regular includes: `components/header.twig`
- Automatic file extension detection (`.twig`, `.html.twig`)

### Key Bindings

| Key          | Action              | Description                              |
| ------------ | ------------------- | ---------------------------------------- |
| `gf`         | Go to file          | Navigate to the Twig file under cursor   |
| `<C-w>f`     | Go to file in split | Open the Twig file in a horizontal split |
| `<leader>tf` | Debug path          | Show path resolution debug info          |

### Supported Namespace Mappings

The configuration includes common namespace mappings:

```
@cwa_components  -> templates/components/
@components      -> templates/components/
@layouts         -> templates/layouts/
@partials        -> templates/partials/
@macros          -> templates/macros/
@forms           -> templates/forms/
@emails          -> templates/emails/
@base            -> templates/base/
@admin           -> templates/admin/
```

### Template Search Paths

The system searches for templates in these locations (in order):

1. `templates/`
2. `src/templates/`
3. `app/templates/`
4. `resources/templates/`
5. `views/`
6. `src/views/`
7. `app/views/`
8. Current directory

## Usage Examples

### Basic Usage

1. Open a Twig file containing: `{% include '@cwa_components/icons/arrow.twig' %}`
2. Place cursor anywhere on `@cwa_components/icons/arrow.twig`
3. Press `gf` to navigate to the file

### Debug Mode

If a file isn't found:

1. Place cursor on the filename
2. Press `<leader>tf` to see debug information
3. Check the resolved path and available namespace mappings

### Customization

To add custom namespace mappings, edit `nvim/lua/config/twig-navigation.lua`:

```lua
M.namespace_mappings = {
  your_namespace = "path/to/templates",
  -- Add more mappings here
}
```

## Troubleshooting

### File Not Found

If `gf` shows "File not found", the debug function (`<leader>tf`) will show:

- Original filename
- Resolved path
- Whether the file is readable
- Available namespace mappings
- Similar files in the project

### Custom Project Structure

If your project uses a different structure, update the `template_paths` in `twig-navigation.lua`:

```lua
M.template_paths = {
  "your/custom/path/",
  "another/path/",
}
```

## Error Messages

The enhanced navigation provides helpful error messages with:

- The original filename you tried to open
- The resolved path it searched for
- Suggestions for similar files found in the project
