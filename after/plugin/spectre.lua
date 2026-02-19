local spectre = require("spectre")

spectre.setup({
    color_devicons = true,
    open_cmd = 'vnew',
    live_update = true,

    -- 1. SEARCH ENGINE CONFIGURATION
    find_engine = {
        ['rg'] = {
            cmd = "rg",
            -- These arguments are passed to ripgrep
            args = {
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                
                -- EXPLICIT IGNORES (Add your folders here)
                '--glob=!**/.git/*',       -- Ignore git folder
                '--glob=!**/node_modules/*', -- Ignore node_modules
                '--glob=!**/dist/*',       -- Ignore build folders
                '--glob=!lazy-lock.json',  -- Ignore specific lockfiles
            },
            options = {
                ['ignore-case'] = {
                    value= "--ignore-case",
                    icon="[I]",
                    desc="ignore case"
                },
                ['hidden'] = {
                    value="--hidden",
                    desc="hidden file",
                    icon="[H]"
                },
            }
        },
    },

    default = {
        find = {
            cmd = "rg",
            options = {"ignore-case"}
        },
        replace = {
            cmd = "sed"
        }
    },
})

-- 2. KEYMAPS (Project-Wide Only)

-- Toggle Spectre (Project)
vim.keymap.set('n', '<leader>S', function() 
    spectre.toggle() 
end, { desc = "Toggle Spectre (Project)" })

-- Search current word (Project)
vim.keymap.set('n', '<leader>sw', function() 
    spectre.open_visual({select_word=true}) 
end, { desc = "Search current word (Project)" })

-- Search selection (Project)
vim.keymap.set('v', '<leader>sw', function() 
    spectre.open_visual() 
end, { desc = "Search selection (Project)" })
