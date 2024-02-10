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
vim.o.termguicolors = true

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
  ensure_installed = {'docker_compose_language_service','bashls','marksman','dockerls','lua_ls','puppet', 'pyright', 'gopls','clangd','hydra_lsp'},
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
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "yaml", "puppet","c", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}


