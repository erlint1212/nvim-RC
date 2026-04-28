-- Toggle the project-wide diagnostics window
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Project Diagnostics (Trouble)" })

-- Toggle the buffer-specific diagnostics window (errors only in your current file)
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })

-- Toggle the Quickfix list (useful if you run project-wide make/lint commands)
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
