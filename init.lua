require("plugins")
local api = vim.api
vim.wo.number = true

-- fzf and fzf.vim
vim.g['fzf_action'] = {['ctrl-s'] = 'split', ['ctrl-v'] = 'vsplit'}
vim.g['fzf_layout'] = {window = {width = 0.8, height = 0.8}}
vim.g['fzf_preview_window'] = {'up:50%:+{2}-/2', 'ctrl-/'}
vim.keymap.set('n', '<leader>/', '<cmd>History/<CR>')
vim.keymap.set('n', '<leader>;', '<cmd>History:<CR>')
vim.keymap.set('n', '<leader>f', '<cmd>Files<CR>')
vim.keymap.set('n', '<leader>r', '<cmd>Rg<CR>')
vim.keymap.set('n', 's', '<cmd>Buffers<CR>')

------ NerdTree configuration ------

-- toggle NERDTree show/hide using <C-n> and <leader>n
api.nvim_set_keymap("n", "<leader>n", ":NERDTreeToggle<CR>", {noremap = true})
-- reveal open buffer in NERDTree
api.nvim_set_keymap("n", "<leader>r", ":NERDTreeFind<CR>", {noremap = true})

------ file search and find in project command mappings ------
-- map Ctrl-q (terminals don't recognize ctrl-tab) (recent files) to show all
-- files in the buffer
api.nvim_set_keymap("n", "<leader>f", ":Buffers<CR>", {noremap = true})
-- Ctrl-I maps to tab
-- But it destroys the C-i mapping in vim. Which is used to kind of go in and
-- used in conjunction with C-o.
api.nvim_set_keymap("n", "<C-b>", ":Buffers<CR>", {noremap = true})
-- map ctrlp to open file search
api.nvim_set_keymap("n", "<C-p>", ":Files<CR>", {noremap = true})
-- go to next buffer
api.nvim_set_keymap("n", "gn", ":bn<cr>", {noremap = true})
-- go to previous buffer
api.nvim_set_keymap("n", "gp", ":bp<cr>", {noremap = true})
-- toggle between 2 buffers
api.nvim_set_keymap("n", "gb", ":b#<cr>", {noremap = true})
api.nvim_set_keymap("n", "<C-t>", ":GFiles<CR>", {noremap = true})
api.nvim_set_keymap("n", "<leader>l", ":Lines<CR>", {noremap = true})
api.nvim_set_keymap("n", "<leader>fg", ":Rg!", {noremap = true})
api.nvim_set_keymap("n", "<leader>a", ":exe 'Rg!' expand('<cword>')<CR>", {noremap = true})

-- NERDCommenter
-- add 1 space after comment delimiter
api.nvim_set_var("NERDSpaceDelims", 1)
-- shortcuts to toggle commen
api.nvim_set_keymap("n", ",c", ':call nerdcommenter#Comment(0, "toggle")<CR>', {noremap = true})
api.nvim_set_keymap("v", ",c", ':call nerdcommenter#Comment(0, "toggle")<CR>', {noremap = true})

--Lua:
vim.cmd[[colorscheme nord]]

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here 
  -- with the ones you want to install
  ensure_installed = {'docker_compose_language_service','awk_ls','bashls','marksman','dockerls','lua_ls','puppet', 'pyright', 'gopls','clangd','hydra_lsp'},
  handlers = {
    lsp_zero.default_setup,
  },
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_format = require('lsp-zero').cmp_format()

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
  },
  mapping = cmp.mapping.preset.insert({
	  ['<CR>'] = cmp.mapping.confirm({select = false}),
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  })
})

