-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
-- basic settings
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.tabstop = 4
vim.bo.tabstop = 4 
vim.bo.softtabstop = 4
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
-- 新行对齐当前行
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
vim.bo.smartindent = true
-- set nu
vim.cmd([[set nu]])
-- custom keymap -- map CTRL + s to save without quit
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map("i", "<C-s>", "<Esc>:w<CR>a", opts)
map("n", "<C-s>", "<Esc>:w<CR>", opts)
map("v", "<C-s>", "<Esc>:w<CR>", opts)
-- jump between windows
map("n","<C-h>","<C-w><C-h>", opts)
map("n","<C-j>","<C-w><C-j>", opts)
map("n","<C-k>","<C-w><C-k>", opts)
map("n","<C-l>","<C-w><C-l>", opts)
-- shortcut to toggle nvim-tree(nerdtree)
local set = vim.keymap.set -- equivalent to map
set("n","tt", ":NvimTreeToggle<CR>", opts)
-- exit from terminal mode,the default keygroup is so weird,have to be changed!
set("t","<Esc>","<C-\\><C-n>",opts)
-- scroll settings
set("n", "<C-u>", "9k", opts)
set("n", "<C-d>", "9j", opts)
set("i", "<C-u>", "<Esc>6ki", opts)
set("i", "<C-d>", "<Esc>6ji", opts)
-- just move cursor foward
set("i","<C-l>","<Right>",opts)
-- quit without save
set("n","QQ",":q!<CR>",opts)
-- 光标以上和以下保持的最小屏幕行数
vim.opt.scrolloff = 5


-- lazy setup -- add lazypath to the runtimepath
local lazypath = '~/.local/share/nvim/site/lazy.nvim'
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
    { "tanvirtin/monokai.nvim",opts = {} },
    {
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons", },
		config = function()
			require("nvim-tree").setup ({})
		end,
        },
    {
        "neovim/nvim-lspconfig",
		config = function()
			-- Configuration for nvim-lspconfig
			require("lspconfig").gopls.setup({})
		end,
        },
    {
        "ray-x/go.nvim",
		dependencies = {  -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
		        },
		config = function()
			require("go").setup()
		end,
		event = {"CmdlineEnter"},
		ft = {"go", 'gomod'},
		build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
        }, 
	{
		-- autocompletion
		"hrsh7th/nvim-cmp", -- completion plugin
        "hrsh7th/cmp-nvim-lsp", -- completion powered by language server protocal
        "hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
	   	-- snippets
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
	    },
	-- { "neoclide/coc.nvim", },
    -- A powerful autopair plugin for Neovim that supports multiple characters.   
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
        }
})

-- colorscheme gruvbox & monokai setup
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
-- vim.cmd([[colorscheme monokai]])

-- neovim tree setup
require("nvim-tree").setup({
    view = { width = 25, },
})

-- Run gofmt + goimport on save
local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
		require('go.format').goimport()
    end,
    group = format_sync_grp,
})

-- auto completion
require('nvim-cmp')

-- coc autocompletion
-- require('coc-nvim')
