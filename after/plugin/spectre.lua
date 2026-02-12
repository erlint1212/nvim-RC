local spectre = require("spectre")

spectre.setup({
    color_devicons = true,
    open_cmd = 'vnew',
    live_update = true,
    -- Ensure the default is always project-wide
    default = {
        find = {
            cmd = "rg",
            options = {"--ignore-case"}
        },
        replace = {
            cmd = "sed"
        }
    },
})

-- KEYMAPS (Project-Wide Only)

-- 1. Open Spectre (Clean state)
vim.keymap.set('n', '<leader>S', function() 
    spectre.toggle() 
end, { desc = "Toggle Spectre (Project)" })

-- 2. Search for the word under the cursor (Project-wide)
vim.keymap.set('n', '<leader>sw', function() 
    spectre.open_visual({select_word=true}) 
end, { desc = "Search current word (Project)" })

-- 3. Search for the currently selected text (Project-wide)
vim.keymap.set('v', '<leader>sw', function() 
    spectre.open_visual() 
end, { desc = "Search selection (Project)" })
