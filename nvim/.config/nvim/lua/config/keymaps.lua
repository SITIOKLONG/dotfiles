-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 取消 Alt+j/k 的默认映射（避免 Esc+j/k 被误触发）
vim.keymap.del({ "n", "i", "v" }, "<A-j>", { silent = true })
vim.keymap.del({ "n", "i", "v" }, "<A-k>", { silent = true })

-- 重新映射到 Ctrl+Alt+j/k（更安全的组合键）
vim.keymap.set("n", "<C-A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<C-A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<C-A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<C-A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<C-A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "<C-A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })
