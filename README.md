# utils.nvim

An unopinionated set of utility functions for neovim plugins

The goal of this plugin is to work with existing neovim libraries/plugins to provide a more complete set of utility functions.

A sub-goal of this library is to provide an intuitive wrapper interface over the neovim API. All utilities in this plugin are typed by the [lua-language-server's standard](https://github.com/LuaLS/lua-language-server/wiki/Annotations).

## Usage

[lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "samsze0/utils.nvim",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "pysan3/pathlib.nvim"
  }
}
```

## TODO

- Add `vim.system` wrapper
- Add `oop` module
- Add `vim.wait` wrapper
- Add `vim.stricmp` wrapper
- Remove `base64` module and force downstream use `vim.base64`
- Wrap `vim.json`
- Wrap `vim.diff`
- Add `highlight` module
- Remove `uv` module and replace with nvim-nio (if possible)
- Wrap `vim.spell`
- Wrap `vim.inspect_pos` and `vim.show_pos`
- Perhaps update `nullish` impl by leveraging `vim.defaulttable` or `vim.tbl_get`
- Perhaps remove `is_array` and just use `vim.array` or `vim.list` instead
- Wrap `vim.list_contains`, `vim.list_extend`, `vim.list_slice`, `vim.tbl_contains`, `vim.tbl_count`, `vim.tbl_filter`, `vim.tbl_keys`, `vim.tbl_map`, `vim.tbl_values`
- Add `schema` module by leveraging `vim.validate`
- Wrap `vim.loader`
- Wrap `vim.iter` and perhaps advise the usage of `vim.iter` over table utils

## License

MIT
