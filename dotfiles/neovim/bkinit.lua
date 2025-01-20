-- Lazy.nvim installation path
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

-- Lazy.nvim setup with plugins
require("lazy").setup({
  {'EdenEast/nightfox.nvim' },
  {'L3MON4D3/LuaSnip'},
  {'MunifTanjim/nui.nvim'},
  {'NvChad/nvim-colorizer.lua'},
  {'ThePrimeagen/harpoon'},
  {'VonHeikemen/lsp-zero.nvim', branch = 'v2.x'},
  {'crusj/bookmarks.nvim', keys = {{ "<tab><tab>", mode = { "n" } }}, branch = 'main', config = function() 
      require("bookmarks").setup() 
      require("telescope").load_extension("bookmarks") 
    end
  },
  {'folke/neodev.nvim'},
  {'folke/tokyonight.nvim'},
  {'folke/trouble.nvim'},
  {'folke/which-key.nvim', event = "VeryLazy", init = function() 
      vim.o.timeout = true 
      vim.o.timeoutlen = 300 
    end, opts = {}
  },
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},
  {'kdheepak/lazygit.nvim'},
  {'kylechui/nvim-surround', version = "*", event = "VeryLazy", config = function() 
      require("nvim-surround").setup({ }) 
    end
  },
  {'mg979/vim-visual-multi', branch = 'master'},
  {'neovim/nvim-lspconfig'},
  {'nvim-lua/plenary.nvim'},
  {'nvim-lualine/lualine.nvim'},
  {'nvim-neo-tree/neo-tree.nvim', branch = "v3.x"},
  {'nvim-telescope/telescope.nvim', tag = '0.1.3', config = function()
      require('telescope').setup{
        defaults = {
          mappings = {
            i = { ["<C-h>"] = "which_key" } -- Example for Telescope key mappings
          },
        },
      }
    end
  },
  {'nvim-tree/nvim-web-devicons'},
  {'nvim-treesitter/nvim-treesitter', build = ":TSUpdate"},
  {'nvim-treesitter/playground'},
  {'rafamadriz/friendly-snippets'},
  {'roobert/surround-ui.nvim', config = function() 
      require("surround-ui").setup({ root_key = "S" }) 
    end
  },
  {'saadparwaiz1/cmp_luasnip'},
  {'startup-nvim/startup.nvim', config = function() require("startup").setup() end}, -- Intro
  {'sunjon/shade.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  {'williamboman/mason.nvim'},
  {'yorik1984/lualine-theme.nvim'},
  {'akinsho/bufferline.nvim', version = "*"},
})
-- Set space as the leader key
vim.g.mapleader = " "

-- Key mappings using which-key
local wk = require("which-key")

wk.register({
  [""] = {
    f = { name = "File",
        f = { "<cmd>Telescope find_files<cr>", "Find Files" },
        g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    },
    b = { name = "Buffer",
        l = { "<cmd>ls<cr>", "List Buffers" },
        d = { "<cmd>bd<cr>", "Delete Buffer" }
    },
    q = { "<cmd>q<cr>", "Quit" },
    w = { "<cmd>w<cr>", "Write" },
  },
}, { prefix = "<leader>" })
