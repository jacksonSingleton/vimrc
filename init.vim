let tabstop=4 
let softtabstop=4
set splitright
set shiftwidth=4
set expandtab
set smartindent 
set guicursor=
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set nu
set nowrap
set ignorecase
set incsearch
set colorcolumn=80
set signcolumn=yes
set list
set listchars

call plug#begin('~/.vim/plugged')
    Plug 'andweeb/presence.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/nvim-cmp' 
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdtree'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'prettier/vim-prettier', { 'do': 'npm install' }
    Plug 'mattn/emmet-vim'
    Plug 'tpope/vim-surround'
    Plug 'flazz/vim-colorschemes'
    Plug 'github/copilot.vim'
call plug#end()

" Language Servers Start " 
lua << EOF
require'lspconfig'.tsserver.setup{}
EOF

" Language Servers END "

let mapleader = " "
" NORMAL Mode Remaps " 
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({search = vim.fn.input("Grep For > ")}) <CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>no <cmd>NERDTreeToggle<cr>
nnoremap <leader>bb <cmd>bn<cr>
nnoremap <leader>bw <cmd>bw<cr>
nnoremap <leader>pd <cmd>Prettier<cr>
nnoremap <silent> g? <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

" INSERT Mode Remaps " 
inoremap {<CR> {<CR>}<C-o>O
inoremap [<CR> [<CR>]<C-o>O

" VISUAL Mode Remaps " 
vnoremap <leader>pis <cmd>PrettierPartial<cr>
" AUTOCOMMANDS " 
"autocmd BufWritePost *.ts :silent !tsc % " COMPILE TYPESCRIPT TO JS ON WRITE
 


"Nvim LSP Configuration and Keybindings" 
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'tsserver', 'cssls', 'solargraph' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" CMP Config "
set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'
  cmp.setup({
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'buffer' },
    })
  })
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    local servers = { 'tsserver', 'cssls' }
    for _, lsp in ipairs(servers) do
      require('lspconfig')[lsp].setup {
        capabilities = capabilities
      }
    end
EOF


let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16_gruvbox_dark_hard'
