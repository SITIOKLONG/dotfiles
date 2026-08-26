-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "unnamedplus"
vim.cmd("let g:netrw_liststyle = 3")

vim.g.autoformat = false

-- cursor
-- vim.g.neovide_cursor_vfx_mode = "pixiedust"
-- vim.g.neovide_cursor_vfx_mode = "torpedo"
-- vim.g.neovide_cursor_vfx_particle_density = 100.0
vim.g.neovide_cursor_animation_length = 0.15
vim.g.neovide_cursor_trail_size = 0.8
vim.g.neovide_floating_shadow = false
vim.g.neovide_input_ime = true
vim.g.neovide_hide_mouse_when_typing = true

-- window
vim.g.neovide_opacity = 0.9
vim.g.neovide_normal_opacity = 1.0
vim.g.neovide_show_border = false
vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 4.0
vim.g.neovide_floating_blur_amount_y = 4.0
vim.g.neovide_floating_blur = 1
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5

-- font
vim.o.guifont = "JetBrainsMono NF Medium:h14"

-- python
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = false
vim.g.neovide_theme = "dark"

-- grammar check
vim.opt.spell = false
vim.opt.conceallevel = 0
vim.opt.wrap = true
vim.opt.relativenumber = true
vim.opt.listchars = { space = "·" }
vim.opt.list = true

vim.opt.guicursor =
  "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait0-blinkoff0-blinkon0-Cursor/lCursor,sm:block-blinkwait0-blinkoff0-blinkon0"
