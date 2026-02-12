local spectre = require("spectre")

spectre.setup({
    -- You can add custom options here if needed,
    -- otherwise the defaults are usually great.
    color_devicons = true,
    open_cmd = 'vnew',
    live_update = true, -- Auto-update search results as you type
})

-- Keymaps

-- Open Spectre (Global Search)
vim.keymap.set('n', '<leader>S', function() spectre.toggle() end, {
    desc = "Toggle Spectre"
})

-- Search for the word under the cursor
vim.keymap.set('n', '<leader>sw', function() spectre.open_visual({select_word=true}) end, {
    desc = "Search current word"
})

-- Search for the currently selected text (Visual Mode)
vim.keymap.set('v', '<leader>sw', function() spectre.open_visual() end, {
    desc = "Search current selection"
})

-- Search strictly within the current file
vim.keymap.set('n', '<leader>sp', function() spectre.open_file_search({select_word=true}) end, {
    desc = "Search on current file"
})
