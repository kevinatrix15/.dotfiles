-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.g.have_nerd_font = true

-- Set <leader> to <space>
vim.g.mapleader = " "

require('lazy').setup({
  'SmiteshP/nvim-navic',
  'sindrets/diffview.nvim',
  'voldikss/vim-floaterm',  -- Floating terminal buffers
  'mg979/vim-visual-multi', -- Multiple cursors

  { -- Telescope: Quickly search through files, integrate with LSP, etc.
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
          'nvim-telescope/telescope-fzf-native.nvim',

          -- `build` is used to run some command when the plugin is installed/updated.
          -- This is only run then, not every time Neovim starts up.
          build = 'make',

          -- `cond` is a condition used to determine whether this plugin should be
          -- installed and loaded.
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },

        -- Pretty icons; requires a Nerd Font.
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },

        -- live_grep_args
        {
          "nvim-telescope/telescope-live-grep-args.nvim" ,
          -- This will not install any breaking changes.
          -- For major updates, this must be adjusted manually.
          version = "^1.0.0",
        },
      },

      config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'live_grep_args')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,


  },

  {
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      dependencies = {
        { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
        { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
      },
      build = "make tiktoken", -- Only on MacOS or Linux
      opts = {
        -- See Configuration section for options
      },
      -- See Commands section for default commands if you want to lazy load on them
    },
  },


  -- ==== Code Completion ==========================================
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  -- For vsnip users. Do I use this?? idk
  'hrsh7th/vim-vsnip',
  'hrsh7th/cmp-vsnip',

  -- ==== Doxygen Generation =======================================
  "Zeioth/dooku.nvim",

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = { 'nvim-treesitter/playground' },
  },
  'tpope/vim-fugitive', -- Nice Git integration
  -- 'tpope/vim-commentary'

  -- NvimTree - Excellet, configurable file browswer written in Lua
  'nvim-tree/nvim-tree.lua',

  -- Integration with Kitty for window navigation
  {
    'knubie/vim-kitty-navigator',
    build = 'cp ./*.py ~/.config/kitty/',
  },

  -- nvim v0.8.0
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },

  -- ==== Style Customization ======================================
  -- Color Schemes
  -- 'sainnhe/forest-night'
  'EdenEast/nightfox.nvim',
  'navarasu/onedark.nvim',
  'marko-cerovac/material.nvim',
  'catppuccin/nvim', -- { 'as': 'catppuccin' },
  'drewtempelmeyer/palenight.vim',
  'folke/tokyonight.nvim',
  'rmehri01/onenord.nvim',

  -- Fonts, icons, statusbars
  'nvim-lualine/lualine.nvim', -- Fancy status bar. Like Vim-Airline, but better
  'nvim-tree/nvim-web-devicons', -- Requires a NerdFont to be in use

  -- Keep Window, Close Buffer
  'rgarver/Kwbd.vim',

  -- ==== Debugging Support ========================================
  -- 'puremourning/vimspector'
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  'nvim-neotest/nvim-nio', -- nvim-dap-ui says it's needed
  'nvim-telescope/telescope-dap.nvim',
  -- 'theHamsta/nvim-dap-virtual-text', -- didn't really like it; slows things down a lot
  'jacobcrabill/nvim-dap-utils',

  { -- Open-Windows Tab bar
    'romgrk/barbar.nvim',

    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
  },

  -- Highlight trailing whitespace
  'ntpeters/vim-better-whitespace',

  -- Escape ANSI sequences and colorize output
  'powerman/vim-plugin-AnsiEsc',

  -- ==== Language Support ========================================
  -- Language Servers Provider and other language suppport plugins
  'ziglang/zig.vim', -- Zig language support
  'simrat39/rust-tools.nvim', -- Rust language support
  'neovim/nvim-lspconfig',
  'rhysd/vim-clang-format',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'aklt/plantuml-syntax',
  'jjo/vim-cue',
  'fladson/vim-kitty', -- Kitty config syntax highlighting
  'folke/neodev.nvim' ,-- Lua & NeoVim API LSP support

  'dhruvasagar/vim-pairify' ,-- Find mismatched parentheses (<C-J>

  -- ==== Misc Tools ==============================================
  -- Render code to a PNG image
  -- Prerequisites: See https://crates.io/crates/silicon
  --   cargo install silicon
  'segeljakt/vim-silicon',

  -- In-buffer Markdown rendering
  'jacobcrabill/glow.nvim',


  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = true },  -- Disable inline suggestions (we use cmp)
        panel = { enabled = false },  -- Disable Copilot floating panel
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
})

-- Add our Lua folder to the runtime path, and source its init.lua
local nvimrc = vim.fn.stdpath('config')
vim.opt.rtp:append(nvimrc .. 'lua')
require('init')
