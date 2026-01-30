-- Set up VimTeX
vim.g.vimtex_view_method = 'okular'
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_compiler_method = 'latexmk'

-- This is the key for forward search:
-- --unique tells okular not to open a new window
-- #src:@line@tex is the synctex magic for jumping to the right spot
vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]

-- Enable inverse search (from PDF back to Vim)
vim.g.vimtex_view_general_options_inverse = vim.g.vimtex_view_general_options

