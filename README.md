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

## License

MIT
