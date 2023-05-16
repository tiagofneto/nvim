# Neovim Config

My highly customized Neovim config, written in **Lua**. Aims to provide a seamless, efficient and feature-rich coding experience. 

Please note that this is a **work in progress**, and is continually updated as the Vim/Neovim ecosystem evolves and new plugins are released.

<p align="center">
<img width="700" alt="main" src="https://github.com/tiagofneto/nvim/assets/46165861/5ff32dd2-5dc1-462f-8591-b625c4dc2891">
<img width="700" alt="telescope" src="https://github.com/tiagofneto/nvim/assets/46165861/83cedb2a-338d-4ebc-85d0-52395b4eacc4">
</p>
 
## Key Plugins
- **[LSP Zero](https://github.com/VonHeikemen/lsp-zero.nvim)**: This plugin eliminates the boilerplate code and automates the setup of [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) (configs for Nvim LSP Client), [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) (autocomplete), and [mason.nvim](https://github.com/williamboman/mason.nvim) (LSP servers management).

- **[Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)**: A powerful fuzzy finder plugin that utilizes [ripgreg](https://github.com/BurntSushi/ripgrep).

- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: Provides advanced syntax highlighting capabilities.

- **[nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)**: A fast and flexible file explorer.

- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)**: A lightweight and customizable statusline.

- **[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)**: Allows for seamless navigation between vim panes and tmux splits.

## Directory Structure
- `after/plugin/`: This folder contains the configuration and setup files for the plugins used in this Neovim setup.

- `lua/tiagofneto/lazy.lua`: Responsible for plugin management using the [lazy.nvim](https://github.com/folke/lazy.nvim) plugin.

- `lua/tiagofneto/remap.lua`: This file contains all the remappings used in this setup.

- `lua/tiagofneto/set.lua`: Here you will find various Vim options settings.

As the Vim/Neovim landscape is always changing, I encourage you to explore, clone, fork, or adapt this configuration to your own needs.
