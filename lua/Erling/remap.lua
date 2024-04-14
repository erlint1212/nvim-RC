vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Allows to move block of text when highlighted
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv'")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv'")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz") --Keeps the cursor in the middle when half page jump
vim.keymap.set("n", "<C-u>", "<C-u>zz") --same
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dp") --delets without copying

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>") --supposed to switch project, dosen't work Nixos?

vim.keymap.set("n", "<leader>g", "g_")
vim.keymap.set("v", "<leader>g", "g_")

-- Shortcut to make file executeble
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
