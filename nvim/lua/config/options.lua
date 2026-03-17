-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "unnamedplus"
vim.cmd("let g:netrw_liststyle = 3")

vim.g.autoformat = false
-- vim.g.neovide_cursor_vfx_mode = "pixiedust"
-- vim.g.neovide_cursor_vfx_mode = "torpedo"
-- vim.g.neovide_cursor_vfx_particle_density = 100.0
vim.g.neovide_floating_shadow = false
vim.g.neovide_input_ime = true
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_opacity = 0.6
vim.g.neovide_normal_opacity = 1.0
vim.g.neovide_show_border = false
vim.o.guifont = "Fira Code:h12"
vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 4.0
vim.g.neovide_floating_blur_amount_y = 4.0
vim.g.neovide_floating_blur = 1

vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5

vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = false
vim.g.neovide_theme = "dark"

local opt = vim.opt

opt.spell = false
opt.conceallevel = 0
opt.wrap = true
opt.relativenumber = true
opt.listchars = { space = "·" }
opt.guifont = { "CaskaydiaCove Nerd Font", ":h12" }
opt.list = true

opt.guicursor =
  "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait0-blinkoff0-blinkon0-Cursor/lCursor,sm:block-blinkwait0-blinkoff0-blinkon0"
