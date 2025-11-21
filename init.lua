
-- ~/.config/nvim/init.lua
-- Complete configuration based on your requirements
--
--
--


pcall(require, 'impatient')
-- ============================================================================
-- PLUGIN MANAGER SETUP (lazy.nvim)
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end


vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- GENERAL SETTINGS
-- ============================================================================
vim.keymap.set("", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.hidden = true                    -- Keep buffers alive when switching
vim.opt.number = true                    -- Line numbers
vim.opt.relativenumber = true            -- Relative line numbers
vim.opt.signcolumn = "yes"               -- Always show sign column
vim.opt.scrollback = 10000               -- Large terminal scrollback
vim.opt.lazyredraw = true                -- Better performance
vim.opt.termguicolors = true             -- True colors
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
-- vim.opt.ttimeoutlen = 10
vim.opt.clipboard = "unnamed"
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.list = false

vim.opt.background=dark 
-- vim.opt.colorscheme=gruvbox

-- ===============================
-- Session options
-- ==============================
vim.opt.sessionoptions = {
  "buffers",   -- open buffers
  "curdir",    -- current directory
  "tabpages",  -- *** this is what you’re missing ***
  "winsize",   -- window sizes
  "help",
  "terminal",  -- persist terminals if you want
  "folds",
  "globals",   -- (optional) global vars
}

-- ============================================================================
-- PLUGINS
-- ============================================================================
-- require('impatient')

require("lazy").setup({

--- IMPATIENT
---
{
    'lewis6991/impatient.nvim',
    config = function()
      require('impatient')
    end,
  },


  -- Session Management

{
  "olimorris/persisted.nvim",
  lazy = false,
  config = function()
    local persisted = require("persisted")

    -- Basic setup; tweak flags as you like
    persisted.setup({
      autostart = true,   -- auto-start saving sessions
      autoload  = false,  -- don't auto-load on startup
      use_git_branch = false,
      follow_cwd = true,
      -- save_dir defaults to stdpath("data") .. "/sessions/"
    })

    -- Load last session quickly
    vim.keymap.set("n", "<leader>ql", function()
      persisted.load({ last = true })
    end, { desc = "Load last session" })

    -- Interactive session selector (built-in, uses vim.ui.select)
    vim.keymap.set("n", "<leader>Sl", function()
      persisted.select()
    end, { desc = "Select and load session" })

    -- Save the current session (no name prompt; plugin decides filename)
    vim.keymap.set("n", "<leader>Ss", "<cmd>SessionSave<CR>", {
      desc = "Save session",
    })

    -- Delete the *current* session (for this cwd/branch)
    vim.keymap.set("n", "<leader>Sd", "<cmd>SessionDelete<CR>", {
      desc = "Delete current session",
    })

  end,
},



  -- Terminal Buffer Management
  {
    'boltlessengineer/bufterm.nvim',
    config = function()
      require('bufterm').setup({
        save_native_terms = true,
        start_in_insert = false,
        remember_mode = true,
        enable_ctrl_w = true,
	  terminal = {              -- default terminal settings
	  buflisted         = true, -- whether to set 'buflisted' option
	  termlisted        = true,  -- list terminal in termlist (similar to buflisted)
	  fallback_on_exit  = true,  -- prevent auto-closing window on terminal exit
	  auto_close        = true,  -- auto close buffer on terminal job ends
  }
      })
      
      -- Commands
      vim.keymap.set('n', '<leader>ta', ':BufTermEnter<CR>', { desc = 'Enter terminal buffer' })
      -- vim.keymap.set('n', '<M-t>', ':terminal<CR>', { desc = 'New terminal buffer' })
      vim.api.nvim_set_keymap('n', '<M-t>', ':terminal<CR><C-\\><C-n>:stopinsert<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>t]', ':BufTermNext<CR>', { desc = 'Next terminal' })
      vim.keymap.set('n', '<leader>t[', ':BufTermPrev<CR>', { desc = 'Previous terminal' })
    end
  },

  -- Buffer Switching - Harpoon2
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add" })
      vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
      
      -- Quick access to first 5 buffers
      for i = 1, 5 do
        vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "Harpoon " .. i })
      end
    end,
  },

  -- Fast Buffer Switching - Snipe
  {
    "leath-dub/snipe.nvim",
    keys = {
      { ",", function() require("snipe").open_buffer_menu() end, desc = "Buffer menu" }
    },
    opts = {}
  },

  -- Fuzzy Finding (snacks_picker + fzf)
{
  'folke/snacks.nvim',
  config = function()
    require('snacks').setup({
      picker = { enabled = true }
    })
    
    -- Simple multi-file search
    vim.keymap.set('n', '<leader>fg', function()
      require('snacks').picker.grep()
    end)
    
    -- File search
    vim.keymap.set('n', '<leader>ff', function()
      require('snacks').picker.files()
    end)

    -- Find buffers

    vim.keymap.set('n', '<leader>,', function()
      require('snacks').picker.buffers()
    end)

    vim.keymap.set('n', '<leader>gb', function()
      require('snacks').picker.git_branches()
    end)

    vim.keymap.set('n', '<leader>gd', function()
      require('snacks').picker.git_diff()
    end)


    vim.keymap.set('n', '<leader>fl', function()
      require('snacks').picker.lines()
    end)

    vim.keymap.set('n', '<leader>fb', function()
      require('snacks').picker.grep_buffers()
    end)

    vim.keymap.set('n', '<leader>sh', function()
      require('snacks').picker.search_history()
    end)
    
    vim.keymap.set('n', '<leader>sd', function()
      require('snacks').picker.diagnostics()
    end)

     vim.keymap.set('n', '<leader>sD', function()
      require('snacks').picker.diagnostics_buffer()
    end)


     vim.keymap.set('n', '<leader>su', function()
      require('snacks').picker.undo()
    end)

  end
},

  -- Buffer/Tab Line Optimization

  -- OIL nvim for file viewing
  {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
    })
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
},



  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "yaml", "go", "bash", "json", "dockerfile", "lua" },
        highlight = { enable = true },
        incremental_selection = { enable = true },
        auto_install = true,
        indent = { enable = true },
      })
    end,
  },

 -- =========================================================================
  -- Mason: Package Manager for LSP/DAP/Linters/Formatters
  -- =========================================================================
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- =========================================================================
  -- Mason Tool Installer: Auto-install all tools
  -- =========================================================================
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Go
          "gopls",           -- LSP
          "delve",           -- Debugger
          "golangci-lint",   -- Linter
          "gofumpt",         -- Formatter (stricter than gofmt)
          
          -- Add other languages here as needed:
          "lua-language-server",  -- Lua LSP
          -- "stylua",               -- Lua formatter
          -- "pyright",              -- Python LSP
          -- "debugpy",              -- Python debugger
          -- "ruff",                 -- Python linter
          -- "black",                -- Python formatter
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000, -- 3 second delay on startup
      })
    end,
  },

  -- Neovim LSP
{
    "neovim/nvim-lspconfig",
    dependencies = { 
      "williamboman/mason.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Get blink.cmp capabilities
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Configure gopls using vim.lsp.config (Neovim 0.11+)
      vim.lsp.config('gopls', {
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedvars = true,
              unusedwrite = true,
              useany = true,
            },
            staticcheck = true,
            semanticTokens = true,
          },
        },
      })

      -- Add other language servers here:
      -- vim.lsp.config('lua_ls', { capabilities = capabilities })
      -- vim.lsp.config('pyright', { capabilities = capabilities })

      -- Enable language servers
      vim.lsp.enable('gopls')
      -- vim.lsp.enable('lua_ls')
      -- vim.lsp.enable('pyright')

      -- LSP Keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf, noremap = true, silent = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<Leader>cf", vim.lsp.buf.format, opts)
        end,
      })

      -- Diagnostics configuration
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Diagnostic keymaps
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
      vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })
    end,
  },


  -- =========================================================================
  -- Blink.cmp: Completion Engine
  -- =========================================================================
  {
    "saghen/blink.cmp",
    version = "v0.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "enter",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<C-y>"] = { "select_and_accept" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = false,
        },
      },
      signature = {
        enabled = true,
      },
    },
  },

 -- =========================================================================
  -- DAP: Debugging
  -- =========================================================================
  {
    "mfussenegger/nvim-dap",
    event = 'VeryLazy',
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 10,
            position = "bottom",
          },
        },
      })

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Setup nvim-dap-go (auto-configures delve)
      require("dap-go").setup()

      -- DAP Keymaps
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<Leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Conditional Breakpoint" })
      vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
      vim.keymap.set("n", "<Leader>dd", dapui.toggle, { desc = "Debug: Toggle UI" })

      -- Breakpoint signs
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "", linehl = "", numhl = "" })
    end,
  },

  {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = {
    { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
    { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
    { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
    { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
  },
},

{
  'kungfusheep/snipe-lsp.nvim',
  event = 'VeryLazy',
  dependencies = 'leath-dub/snipe.nvim',
  opts = {
    keymap = {
      open_symbols_menu = '<Leader>ds',
      open_symbols_menu_for_split = '<Leader>sds',
      open_symbols_menu_for_vsplit = '<Leader>vds',
    },
  },
},

{
  'numToStr/Comment.nvim',
  event = 'VeryLazy',
  config = function()
    require('Comment').setup()
    
    -- Map to <Leader>/
    vim.keymap.set('n', '<Leader>/', 'gcc', { remap = true, desc = 'Toggle comment' })
    vim.keymap.set('v', '<Leader>/', 'gc', { remap = true, desc = 'Toggle comment' })
  end,
},

{
  'jiaoshijie/undotree',
  config = function()
    require('undotree').setup({
      float_diff = true,      -- Show diff in float window
      layout = 'left_bottom', -- Layout: 'left_bottom', 'left_left_bottom'
      position = 'left',      -- Position: 'left', 'right', 'bottom'
      window = {
        winblend = 30,        -- Transparency
        border = 'rounded',   -- Border style
      },
      keymaps = {
        j = 'move_next',
        k = 'move_prev',
        gj = 'move2parent',
        J = 'move_change_next',
        K = 'move_change_prev',
        ['<cr>'] = 'action_enter',
        p = 'enter_diffbuf',
        q = 'quit',
      },
    })
  end,
  keys = {
    { '<Leader>u', '<cmd>lua require("undotree").toggle()<cr>', desc = 'Toggle undotree' },
  },
},

{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},

})

-- ============================================================================
-- TERMINAL BUFFER SETTINGS
-- ============================================================================
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('terminal_settings', { clear = true }),
  callback = function()
    -- Enable line numbers in terminal buffers
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
    vim.opt_local.signcolumn = 'yes'
    vim.opt_local.scrollback = 10000
    
    -- Start in insert mode
    vim.cmd('startinsert')
  end,
})

-- ============================================================================
-- TERMINAL MODE KEYBINDINGS
-- ============================================================================
-- Exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', '<C-e>', '<C-\\><C-n>', { noremap = true })

-- Navigate from terminal mode
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true })

-- ============================================================================
-- TERMINAL CREATION COMMANDS
-- ============================================================================
vim.api.nvim_create_user_command('Term', function()
  vim.cmd('terminal')
  vim.cmd('startinsert')
end, { desc = "Open terminal in current window" })

vim.api.nvim_create_user_command('Termtab', function()
  vim.cmd('tabnew')
  vim.cmd('terminal')
  vim.cmd('startinsert')
end, { desc = "Open terminal in new tab" })

vim.api.nvim_create_user_command('Termsplit', function()
  vim.cmd('split')
  vim.cmd('terminal')
  vim.cmd('startinsert')
end, { desc = "Open terminal in horizontal split" })

vim.api.nvim_create_user_command('Termvsplit', function()
  vim.cmd('vsplit')
  vim.cmd('terminal')
  vim.cmd('startinsert')
end, { desc = "Open terminal in vertical split" })

-- ============================================================================
-- BUFFER SWITCHING (Native Fast Method)
-- ============================================================================
-- Quick buffer command
vim.keymap.set('n', '<leader>b', ':b ', { noremap = true, desc = "Buffer switch" })

-- Cycle through buffers
vim.keymap.set('n', '<Tab>', ':bnext!<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', ':bprevious!<CR>', { noremap = true, silent = true })

-- Toggle last buffer
vim.keymap.set('n', '<leader><leader>', '<C-^>', { noremap = true, desc = "Toggle last buffer" })

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================
-- Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true })

-- Resize windows
vim.keymap.set('n', '<M-h>', '<C-w><', { noremap = true })
vim.keymap.set('n', '<M-l>', '<C-w>>', { noremap = true })
vim.keymap.set('n', '<M-j>', '<C-w>-', { noremap = true })
vim.keymap.set('n', '<M-k>', '<C-w>+', { noremap = true })

-- Split creation
vim.keymap.set('n', '<leader>vs', ':vsplit<CR>', { noremap = true, desc = "Vertical split" })
vim.keymap.set('n', '<leader>hs', ':split<CR>', { noremap = true, desc = "Horizontal split" })

-- ============================================================================
-- WINDOW ZOOM TOGGLE
-- ============================================================================
local zoom_state = {}

function _G.toggle_zoom()
  if zoom_state.zoom_enabled then
    vim.cmd(zoom_state.restore_cmd)
    zoom_state.zoom_enabled = false
  else
    zoom_state.restore_cmd = vim.fn.winrestcmd()
    zoom_state.zoom_enabled = true
    vim.cmd('wincmd |')
    vim.cmd('wincmd _')
  end
end

vim.keymap.set('n', '<leader>z', toggle_zoom, { noremap = true, silent = true, desc = "Toggle zoom" })

-- Tab-based zoom (alternative)
vim.keymap.set('n', '<leader>wz', ':tab split<CR>', { noremap = true, desc = "Zoom in new tab" })

-- Equalize windows
vim.keymap.set('n', '<leader>=', '<C-w>=', { noremap = true, desc = "Equalize windows" })

-- ============================================================================
-- CONTEXT-BASED TERMINAL MANAGEMENT
-- ============================================================================
-- Helper function for named contexts
local create_context_terminal = function(context_name)
  return function()
    vim.cmd('tabnew')
    vim.cmd('terminal')
    vim.cmd('startinsert')
    -- Optionally set buffer name
    vim.api.nvim_buf_set_name(0, 'term://' .. context_name)
  end
end

-- Context commands
vim.api.nvim_create_user_command('ContextDev', create_context_terminal('dev'), { desc = "Dev terminal" })
vim.api.nvim_create_user_command('ContextK8s', create_context_terminal('k8s'), { desc = "K8s terminal" })
vim.api.nvim_create_user_command('ContextGit', create_context_terminal('git'), { desc = "Git terminal" })
vim.api.nvim_create_user_command('ContextDocker', create_context_terminal('docker'), { desc = "Docker terminal" })

-- ============================================================================
-- ADDITIONAL OPTIMIZATIONS
-- ============================================================================
-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 1000

-- Better search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Clear search highlight
vim.keymap.set('n', '<leader>/', ':noh<CR>', { noremap = true, silent = true, desc = "Clear highlight" })

-- Quick save
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, desc = "Save" })
-- vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, desc = "Quit" })

-- ============================================================================
-- LEADER KEY
-- ============================================================================
vim.keymap.set("", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.maplocalleader = ' '

vim.keymap.set('t', '<C-;>', function()
  vim.api.nvim_feedkeys('clear\n', 't', false)
end, { noremap = true, silent = true })

-- Custom multi grep
local snacks_multigp = require("snacks_multigp")
vim.keymap.set('n', '<leader>fw', snacks_multigp.multi_grep, { desc = "Multi-grep" })
