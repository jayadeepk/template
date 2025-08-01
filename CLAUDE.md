# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an AstroNvim v5+ configuration repository. AstroNvim is a modular Neovim configuration framework that uses lazy.nvim for plugin management.

## Common Development Commands

### Neovim Operations
- Start Neovim: `nvim`
- Update plugins: Within Neovim, run `:Lazy update`
- Install LSP servers: `:LspInstall <server_name>` (e.g., `:LspInstall lua_ls`)
- Install formatters/linters/debuggers: `:Mason` to open Mason UI
- Check plugin status: `:Lazy`

### Code Quality
- Lua linting: Uses Selene (configured in `selene.toml`)
- Formatting: Configured per-language through LSP and null-ls

## Architecture

### Configuration Structure
- `init.lua`: Bootstrap file that loads lazy.nvim and initiates the configuration
- `lua/lazy_setup.lua`: Main configuration entry point that sets up lazy.nvim with AstroNvim and imports
- `lua/plugins/`: Directory for plugin configurations that override or extend AstroNvim defaults
  - Each file returns a LazySpec table
  - Files starting with `if true then return {} end` are inactive templates
- `lua/config/`: Additional configuration files (currently contains mappings)
- `lua/community.lua`: Import community modules from AstroNvim/astrocommunity
- `lua/polish.lua`: Final configuration adjustments run after all plugins are loaded

### Key Configuration Points
- Leader key: Space (` `)
- Local leader: Comma (`,`)
- Plugin management: lazy.nvim
- LSP configuration: AstroLSP plugin
- UI customization: AstroUI plugin
- Core settings: AstroCore plugin

### Important Notes
- Most plugin files are currently disabled (return empty table at the start)
- To activate a plugin configuration, remove the `if true then return {} end` line
- AstroNvim pins plugins by default when tracking versions
- Mason is used for managing external tools (LSP servers, formatters, linters, debuggers)

## Recent Changes
- Configured Lua language server to disable formatting (commit: 89ebfd3)