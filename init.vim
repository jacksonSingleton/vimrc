let tabstop=4
let softtabstop=4
let g:vim_npr_file_names = ["", ".js", "/index.js", ".ts", ".tsx"]
set splitright
set shiftwidth=4
set expandtab
set smartindent
set guicursor=
set nohlsearch
set hidden
set noerrorbells
set nu
set nowrap
set ignorecase
set incsearch
set signcolumn=auto
set list
set listchars
set clipboard=unnamedplus
set termguicolors
set laststatus=3
set winbar=%=%f%=%m%=%r%=%w%=%h%=%=


call plug#begin('~/.vim/plugged')
    Plug 'andweeb/presence.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'APZelos/blamer.nvim'
    Plug 'ThePrimeagen/harpoon'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'neovim/nvim-lspconfig'

    " CMP
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'

    " For vsnip users.
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdtree'

    " Status Line
    Plug 'nvim-lualine/lualine.nvim'

    Plug 'feline-nvim/feline.nvim'
    Plug 'kyazdani42/nvim-web-devicons'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'prettier/vim-prettier', { 'do': 'npm install' }
    Plug 'mattn/emmet-vim'
    Plug 'tpope/vim-surround'
    Plug 'flazz/vim-colorschemes'
    Plug 'github/copilot.vim'
    Plug 'folke/zen-mode.nvim'
    Plug 'tomarrell/vim-npr'
    Plug 'arthurxavierx/vim-caser'
    Plug 'dylanaraps/wal.vim'
    Plug 'evanleck/vim-svelte'
    Plug 'pangloss/vim-javascript'
    Plug 'f-person/git-blame.nvim'
    Plug 'HerringtonDarkholme/yats.vim'

    " Themes
    Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
call plug#end()

" Language Servers Start " 
lua << EOF
require'lspconfig'.tsserver.setup{}
EOF

" Harpoon into telescope "
:lua require('telescope').load_extension('harpoon')

" Language Servers END "

" Initialize Status Bar

luafile ~/.config/nvim/status.lua

let mapleader = " "
" NORMAL Mode Remaps " 
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({search = vim.fn.input("Grep For > ")}) <CR>
nnoremap <leader>ff <cmd> :lua require('telescope.builtin').find_files{path_display = {'smart'}}<cr>
nnoremap <leader>fs <cmd>Telescope grep_string<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>no <cmd>NERDTreeToggle<cr>
nnoremap <leader>nf <cmd>NERDTreeFind<cr>
nnoremap <leader>bb <cmd>bn<cr>
nnoremap <leader>bw <cmd>bw<cr>
nnoremap <leader>pd <cmd>Prettier<cr>
nnoremap <leader>ds <cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })<CR>
nnoremap <leader>zm <cmd>ZenMode<cr>
nnoremap <leader>hm <cmd>lua require('harpoon.mark').add_file()<cr>
nnoremap <leader>hs <cmd>Telescope harpoon marks<cr>
nnoremap <leader>pv <cmd>"+p<cr>
nnoremap <leader>yv <cmd>"+y<cr>
nnoremap <leader>vb <cmd><C-v><CR>
nnoremap <leader>wh <C-w>h<CR>
nnoremap <leader>wl <C-w>l<CR>
nnoremap <leader>wj <C-w>j<CR>
nnoremap <leader>wk <C-w>k<CR>
nnoremap <leader>K <cmd>lua vim.lsp.buf.hover()<CR>

" INSERT Mode Remaps " 
inoremap {<CR> {<CR>}<C-o>O
inoremap [<CR> [<CR>]<C-o>O

" VISUAL Mode Remaps " 
vnoremap <leader>pis <cmd>PrettierPartial<cr>
" AUTOCOMMANDS " 
"autocmd BufWritePost *.ts :silent !tsc % " COMPILE TYPESCRIPT TO JS ON WRITE
 

" TERM Mode Remaps
tnoremap <Esc> <C-\><C-n>
:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

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
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    local servers = { 'tsserver', 'cssls' }
    for _, lsp in ipairs(servers) do
      require('lspconfig')[lsp].setup {
        capabilities = capabilities
      }
    end
EOF


colorscheme catppuccin-mocha
lua << EOF
require('zen-mode').setup{}
EOF

" Rich Presence Config "
let g:presence_main_image = "file"

let g:airline_powerline_fonts = 0
