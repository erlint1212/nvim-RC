local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  -- Jumps to the definition of the symbol under the cursor
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

  -- Displays hover information (documentation/types) for the symbol under the cursor
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

  -- Searches for a symbol (variable/function) across the entire project/workspace
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)

  -- Opens a floating window showing the error/warning diagnostic for the current line
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)

  -- Jumps to the NEXT diagnostic (error/warning) in the buffer
  -- (Note: Standard Vim convention usually puts 'next' on ']', but your code has it on '[')
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)

  -- Jumps to the PREVIOUS diagnostic (error/warning) in the buffer
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

  -- Opens "Code Actions" menu (quick fixes, imports, refactors)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

  -- Lists all references to the symbol under the cursor (where it is used)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)

  -- Renames the symbol under the cursor across the whole project
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)

  -- [Insert Mode] Shows help for the current function signature (parameters) while typing
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
      'rust_analyzer', 
      'lua_ls',
      -- 'pyright',       -- Python
      -- 'gopls',         -- Go
      -- 'cssls',         -- CSS
      -- 'html'           -- HTML
  },
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

-- this is the function that loads the extra snippets to luasnip
-- from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip', keyword_length = 2},
    {name = 'buffer', keyword_length = 3},
  },
  formatting = lsp_zero.cmp_format({details = false}),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})
