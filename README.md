# utils.nvim

An unopinionated set of utility functions for neovim plugins

The library/plugin would not include anything that I feel like there is a better alternative for. For example, I would not include utilities for creating/managing neovim windows, as plugins like nui.nvim have taken great care of that.

## Usage

[lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "samsze0/utils.nvim",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "pysan3/pathlib.nvim",
        "echasnovski/mini.test"
    }
}
```

## License

MIT