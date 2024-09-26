--⚡Help⚡-------------------------------------------------------------------------⚡Help⚡--
-- some time it fails coz of github speed and then delete those repo downloaded folder if already exist error shows and retry
--Remove-Item C:\Users\nahid\AppData\Local\nvim-data\swap\  #delete swap regularly for errors
--helping
--folks/whichkey causing to hide intro
--for lazy for first time installation make sure leaderkey or mapping part is before the lazy commands so mappings will be correct. but for now working fine for some reason.
--cant use packer and lazy at the same time probably
--lazypackagemanager tools   --pip install neovim --scoop install cmake make gcc clangd 
--for lazy install plugin insie init.lua   
-- for lazy plugin packages their corrosponding commands must be after the package section
--for packer install plugin inside scoop/neovim/bin/lua/packer.lua
--require("packer")
--packer extension from git must be installed than the lua or packer lua can be used https://github.com/wbthomason/packer.nvim 
--also after adding the lua need to type :so 
--https://www.youtube.com/watch?v=w7i4amO_zaE
--Neotree command list ?-help leaderfn-opentree :Neotree-opentree
--install language servers like html snippet using mason after configuring lsp
-- scoop install cmake make gcc clangd go tssh ctags unzip curl gzip

--⚡Requirements⚡--------------------------------------------⚡Requirements⚡--
--npm i -g  pyright

--⚡Nvim-Surround⚡------------------------------------------⚡Nvim-Surround⚡--
 --   Old text                    Command         New text
--------------------------------------------------------------------------------
 --   surr*ound_words             ysiw)           (surround_words)
 --   *make strings               ys$"            "make strings"
 --   [delete ar*ound me!]        ds]             delete around me!
 --   remove <b>HTML t*ags</b>    dst             remove HTML tags
 --   'change quot*es'            cs'"            "change quotes"
 --   <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
 --   delete(functi*on calls)     dsf             function calls


--------------⚡Lazy.Nvum.PackageManager⚡--------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
--Lazy.nvim.Plugins Inside second brackets------------------------------------------------------------------------
require("lazy").setup({

--------------⚡Packages--------------
--{'AckslD/nvim-whichkey-setup.lua'},
--{'liuchengxu/vim-which-key'},
--{'folke/neoconf.nvim', cmd = "Neoconf" },
--{'goolord/alpha-nvim', config = function () require'alpha'.setup(require'alpha.themes.startify'.config) end }, --intro https://github.com/goolord/alpha-nvim
--{'mhinz/vim-startify'}, --intro https://github.com/mhinz/vim-startify
{'EdenEast/nightfox.nvim' },
{'L3MON4D3/LuaSnip'},
{'MunifTanjim/nui.nvim'},
{'NvChad/nvim-colorizer.lua'},
{'ThePrimeagen/harpoon'},
{'VonHeikemen/lsp-zero.nvim',branch = 'v2.x'},
{'crusj/bookmarks.nvim',keys = {{ "<tab><tab>", mode = { "n" } },},branch = 'main',config = function() require("bookmarks").setup() require("telescope").load_extension("bookmarks")end},
{'folke/neodev.nvim'},
{'folke/tokyonight.nvim'},
{'folke/trouble.nvim'},
{'folke/which-key.nvim', event = "VeryLazy", init = function() vim.o.timeout = true vim.o.timeoutlen = 300 end, opts = { }},
{'hrsh7th/cmp-nvim-lsp'},
{'hrsh7th/nvim-cmp'},
{'kdheepak/lazygit.nvim'},
{'kylechui/nvim-surround', version = "*", event = "VeryLazy", config = function() require("nvim-surround").setup({ }) end, },
{'mg979/vim-visual-multi',branch = 'master'},
{'neovim/nvim-lspconfig'},
{'nvim-lua/plenary.nvim'},
{'nvim-lualine/lualine.nvim'},
{'nvim-neo-tree/neo-tree.nvim',branch = "v3.x",},
{'nvim-telescope/telescope.nvim', tag = '0.1.3',},
{'nvim-tree/nvim-web-devicons'},
{'nvim-treesitter/nvim-treesitter', build = ":TSUpdate"},
{'nvim-treesitter/playground'},
{'rafamadriz/friendly-snippets'},
{'roobert/surround-ui.nvim', config = function() require("surround-ui").setup({ root_key = "S" }) end, },
{'saadparwaiz1/cmp_luasnip'},
{'startup-nvim/startup.nvim', config = function() require"startup".setup() end },  --intro https://github.com/startup-nvim/startup.nvim
{'sunjon/shade.nvim'},
{'williamboman/mason-lspconfig.nvim'},
{'williamboman/mason.nvim'},
{'yorik1984/lualine-theme.nvim'},
{'akinsho/bufferline.nvim', version = "*"},


 {
  'sudormrfbin/cheatsheet.nvim',

  requires = {
    {'nvim-telescope/telescope.nvim'},
    {'nvim-lua/popup.nvim'},
    {'nvim-lua/plenary.nvim'},
  }
},

{'tomasiser/vim-code-dark'}
})


vim.opt.termguicolors = true
require("bufferline").setup{}

require 'colorizer'.setup()

require'shade'.setup({
  overlay_opacity = 40,
  opacity_step = 1,
  keys = { toggle = '<Leader>ch', } })



--Default-Command-List---------------------
vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.wrap = false

--ColorSchemes--------------------------------------------------------
vim.opt.termguicolors = true
vim.cmd.colorscheme('codedark')
--vim.cmd.colorscheme('tokyonight')
--vim.cmd("colorscheme duskfox")
--vim.cmd("colorscheme habamax")
--vim.cmd.colorscheme('habamax')
--vim.cmd.colorscheme('morning')



--vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) --notworking
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) --notworking

--Set the highlight color for brackets
--vim.cmd([[highlight MatchParen guifg=#xxxxxx guibg=#xxxxxx]])

-- Change the color value as desired
--vim.cmd([[highlight Comment guifg=#xxxxxx]])

--RemapKeys.Default-this configs must be disabled if vim-which-key should work properly- to enable delete all vim which key parts
vim.g.mapleader = " "
local builtin = require('telescope.builtin')
local mark = require("harpoon.mark")
local ui = require ("harpoon.ui")
vim.g.wrap = "soft"



----------⚡--LSP-Config-Files--⚡----------
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls" ,"html", "cssmodules_ls","custom_elements_ls","powershell_es" }
})

local lspconfig = require('lspconfig')

local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

require("lspconfig").lua_ls.setup { settings = { Lua = { diagnostics = {
        globals = { "vim" } },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true, }}}}}


require("lspconfig").html.setup({})

vim.api.nvim_create_autocmd('LspAttach', {
group = vim.api.nvim_create_augroup('UserLspConfig', {}),
callback = function(ev)
vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    vim.keymap.set('n', '<space>XD', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>Xa', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})

local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
  mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-o>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), }),
  snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end, },
  sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' }, }, { { name = 'buffer' }, }), })


----------⚡--Bookmarks🔖--⚡----------
require("bookmarks.list").load{
    filename = '/Users/crusj/Project/bookmarks.nvim/README.md',
    description = 'readme',
    fre = 3,
    id = '429b65925c650553dfcc8576231837a2',
    line = 2,
    updated_at = 1651588531, }
require("bookmarks.list").load{
    filename = '/Users/crusj/Project/bookmarks.nvim/lua/bookmarks/config.lua',
    description = 'keymap',
    fre = 11,
    id = 'a22afa41979db45c6a8215cb7df6304f',
    line = 6,
    updated_at = 1651588572, }
require("bookmarks.list").load{
    filename = '/Users/crusj/Project/bookmarks.nvim/lua/bookmarks/event.lua',
    description = 'add keymap',
    fre = 5,
    id = 'a2e79c4b86b533f43fe3aa5a545a5073',
    line = 10,
    updated_at = 1651580490, }




----------⚡--Which-Key⌨️ --⚡----------
local wk = require("which-key")
wk.register(mappings, opts)
wk.register({
["*"] = { mark.add_file, "Add to Harpoon" },
["<Tab>"] = { ui.toggle_quick_menu, "Toggle Quick Menu" },
["/"] = { name = "Comments",
	l = { [[i-- <Esc>]], "Insert Comment" },
	h = { [[i<!--  --> <Esc>]], "HTML Comment" },
	},
b = { name = "Bookmark",
	t = { function() vim.cmd('Telescope bookmarks') end, "Telescope Bookmarks" },
	b = { name = "Buffers",
		l = { function() vim.cmd("ls") end, "Buffer List" },
		a = { function() vim.cmd("e %") end, "Add Current File to Buffer List" },
		n = { function() vim.cmd("bnext") end, "Next Buffer" },
		p = { function() vim.cmd("bprevious") end, "Previous Buffer" },
		d = { function() vim.cmd("bufdo bd") end, "Delete All Buffers" },
	    }
    },
c = { name = "Command",
	f = { vim.lsp.buf.format, "Format Whole Documnet" }, --also works holding leader+f
	s = { function() local start_line = vim.fn.input("Start Line: ") local end_line = vim.fn.input("End Line: ") vim.cmd(start_line .. "," .. end_line .. "sort") end, "Sort Lines Within Range" },
	},
d = { name = "Delete",
	c = { [["_d]], "Delete from Cursor (Including Selection)" },
	s = { function() vim.fn.system('rmdir /s /q C:\\Users\\nahid\\AppData\\Local\\nvim-data\\swap') end, "Delete Swap Files" }},
f = { name = "File",
	a = { function() vim.cmd("edit C:/") end, "Explorer to C" },
	b = { function() vim.cmd("edit D:/") end, "Explorer to D" },
	c = { function() vim.cmd("cd D:/") end, "CD to C:/ (for grep search)" },
	d = { function() vim.cmd("cd D:/") end, "CD to D:/ (for grep search)" },
	e = { function() vim.cmd("Ex") end, "Explorer" },
	n = { function() vim.cmd("Neotree") end, "NeoTree Explorer" }},
i = { name = "Info",
	i = { function() vim.cmd("intro") end, "Intro" },
	c = { function() vim.cmd("Cheatsheet") end, "CheatSheet" },
	h = { function() vim.cmd("help") end, "Help" },
	t = { function() vim.cmd("Tutor") end, "Tutor" },
	v = { function() vim.cmd("help nvim") end, "Help Nvim" }},
m = { name = "Copy, Move, Mklink",
	i = { function() vim.fn.system('robocopy C:\\Users\\nahid\\AppData\\Local\\nvim D:\\git\\ms1\\asset\\neovim init.lua /IS') end, "Replace init.lua in D:\\git\\ms1\\asset\\neovim" }},
q = { name = "Quit",
	q = { function() vim.cmd("q") end, "Quit" },
	w = { function() vim.cmd("wq") end, "Save & Quit" }},
r = { name = "Replace",
	a = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Search and Replace" }},
s = { name = "Search",
	h = { ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', "Hidden Files" },
	f = { require('telescope.builtin').find_files, "Search Files" },
	g = { require('telescope.builtin').live_grep, "Search by Grep" },
	i = { require('telescope.builtin').help_tags, "Search Help" },
	s = {function()builtin.grep_string({search = vim.fn.input("Grep > ") }) end, "Search String" },
	w = { require('telescope.builtin').grep_string, "Search current Word" }},
t = { name = "Split",
	h = { ":split<CR>", "Horizontal Split" }, -- Horizontal split
	v = { ":vsplit<CR>", "Vertical Split" },},  -- Vertical split
X = { name = "LSP Functions",
	K = { vim.lsp.buf.hover, "Show Hover Info" },
	gD = { vim.lsp.buf.declaration, "Go to Declaration" } --error
},

}, { prefix = "<leader>" })






vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })
--dont include in which  key section--
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")  --visualmode--shift+j move selection down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")  --visualmode--shift+k move selection up
vim.keymap.set("n", "J", "mzJ`z") --shift+j Merge Next Line (Without Cursor Move)" },


--Help key suggestion--
vim.cmd([[
  function! FunctionalKeys()
    echohl Function
    echom "! = +Filter throug external progrem-->sent to a command and replace with output"
    echom "' = +Mark"
    echom "* = Highlight Similar Words"
    echom "<Ctrl-v> = Visual Block mode"
    echom "Double quotation = +registers"
    echom "V = +Visual Line mode"
    echom "[] = Go to Matched Items i.e (),{},[]"
    echom "c = +Change(Delete+Insert-Mode)"
    echom "d = +Delete"
    echom "g = +Character-Modification"
    echom "ggvG = ->Go to to first line -> insert selectmode/visualselect -> Go to Last line / Select whole Doc"
    echom "o = Isert Blank Line + Insert Mode"
    echom "v = +Visual-Mode / Select-Mode"
    echom "xGvyG:sort = Sort lines from x to y [x & y is variable]"
    echom "y = +Yank(Copy)"
    echom "z = +Fold ❤️  "
    echom "v to select mode then doublequota & + & y to copy to sysclipboard"
    echom "% on ()/{}/[]= Rotate cursor between matching () {} [] brackets"
    echohl None
  endfunction
]])
vim.keymap.set("n", "<leader><leader>", ":call FunctionalKeys()<CR>", { noremap = true, silent = true })




--⚡Lualine--
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
