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

-- Shortcut to make file executeble
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Mapping esc to caps lock so I don't need to travel so far
vim.keymap.set("n", "<A-e>", "<Esc>")
vim.keymap.set("i", "<A-e>", "<Esc>")
vim.keymap.set("v", "<A-e>", "<Esc>")

--Delete line without deleting indice and begin editiing
vim.keymap.set("n", "<leader>D", "g__\"_Da")
vim.keymap.set("v", "<leader>D", "g__\"_Da")

-- Keysetup so Norwegian keyboards won't be as combersome to use with vim motions
vim.keymap.set("n", ",", "/")
vim.keymap.set("v", ",", "/")

vim.keymap.set("n", "ø", "[")
-- vim.keymap.set("i", "ø", "[")
vim.keymap.set("v", "ø", "[")

vim.keymap.set("n", "æ", "]")
-- vim.keymap.set("i", "æ", "]")
vim.keymap.set("v", "æ", "]")

vim.keymap.set("n", "¤", "$")
-- vim.keymap.set("i", "¤", "$")
vim.keymap.set("v", "¤", "$")

vim.keymap.set("n", "<S-Ø>", "{")
-- vim.keymap.set("i", "<S-Ø>", "{")
vim.keymap.set("v", "<S-Ø>", "{")

vim.keymap.set("n", "<S-Æ>", "}")
-- vim.keymap.set("i", "<S-Æ>", "}")
vim.keymap.set("v", "<S-Æ>", "}")

-- Normal error handeling in go
vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

-- Normal python imports
vim.keymap.set(
    "n",
    "<leader>pi",
    "iimport pandas as pd<ESC>oimport seaborn as sns<ESC>oimport numpy as np<ESC>oimport matplotlib.pyplot as plt"
)
