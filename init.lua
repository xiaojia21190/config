--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key
local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local config = {
  options = {
    opt = {
      cmdheight = 1,
      clipboard = "unnamedplus",
      foldmethod = "expr",
      foldexpr = "nvim_treesitter#foldexpr()",
      foldlevel = 99,
      foldenable = false,
    },
  },
  colorscheme = "carbonfox",
  dap = {
    configurations = {
      javascript = { -- set up javascript dap configuration
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = function(...) return require("dap.utils").pick_process(...) end, -- protect function
          cwd = "${workspaceFolder}",
        },
      },
      typescript = { -- set up javascript dap configuration
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = function(...) return require("dap.utils").pick_process(...) end, -- protect function
          cwd = "${workspaceFolder}",
        },
      },
    },
  },
  -- Configure plugins
  plugins = {
    init = {
      { "kana/vim-textobj-user" },
      { "kana/vim-textobj-entire" },
      { "ur4ltz/surround.nvim" },
      ["ggandor/leap.nvim"] = {
        as = "leap",
        config = function()
          -- leap config
          require("leap").add_default_mappings()
          -- Disable auto jump first match
          -- require('leap').opts.safe_labels = {}
          require("leap").opts.highlight_unlabeled_phase_one_targets = true
        end,
      },
      ["ggandor/flit.nvim"] = {
        as = "flit",
        config = function()
          require("flit").setup {
            keys = { f = "f", F = "F", t = "t", T = "T" },
            -- A string like "nv", "nvo", "o", etc.
            labeled_modes = "v",
            multiline = true,
            -- Like `leap`s similar argument (call-specific overrides).
            -- E.g.: opts = { equivalence_classes = {} }
            opts = {},
          }
        end,
      },
      ["catppuccin/nvim"] = {
        as = "catppuccin",
        config = function() require("catppuccin").setup {} end,
      },
      -- debug
      {
        "mxsdev/nvim-dap-vscode-js",
        after = "mason-nvim-dap.nvim", -- setup after mason which  installs the debugger
        config = function()
          require("dap-vscode-js").setup {
            debugger_cmd = { "js-debug-adapter" }, -- mason puts command in path
            adapters = { "pwa-node" }, -- choose adapter, only node is fully tested
          }
        end,
      },
    },
    ["mason-nvim-dap"] = {
      ensure_installed = { "js" }, -- auto install js-debug-adapter
    },
    ["telescope"] = {
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            prompt_position = "top",
            mirror = true,
            preview_cutoff = 40,
            preview_height = 0.5,
          },
          width = 0.95,
          height = 0.95,
        },
      },
      pickers = {
        find_files = {
          theme = "ivy",
        },
      },
    },
  },
  lsp = {
    formatting = {
      format_on_save = true, -- enable or disable automatic formatting on save
      timeout_ms = 3200, -- adjust the timeout_ms variable for formatting
      disabled = { "sumneko_lua" },
      filter = function(client)
        -- only enable null-ls for javascript files
        if vim.bo.filetype == "javascript" then return client.name == "null-ls" end

        -- enable all other clients
        return true
      end,
    },
  },
  mappings = {
    -- first key is the mode
    n = {
      -- second key is the lefthand side of the map
      ["-"] = { "Nzzzv", desc = "N" },
      ["<S-h>"] = { "^", desc = "^" },
      ["<S-l>"] = { "$", desc = "$" },
      ["="] = { "nzzzv", desc = "n" },
      ["<leader>tt"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" },
      ["<C-Right>"] = { "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer tab" },
      ["<C-Left>"] = { "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer tab" },
      ["<leader>m"] = { "<cmd>Neotree focus<cr>", desc = "Focus Explorer" },
      ["<leader><CR>"] = { "<cmd>nohlsearch<cr>", desc = "No Highlight" },
      ["<leader>q"] = {
        function() require("bufdelete").bufdelete(0, false) end,
        desc = "Close buffer",
      },
      ["<CS-f>"] = {
        function()
          require("telescope.builtin").live_grep {
            additional_args = function(args) return vim.list_extend(args, { "--no-ignore" }) end,
          }
        end,
        desc = "Search words in all files",
      },
      ["<C-f>"] = {
        function() require("telescope.builtin").grep_string() end,
        desc = "Search for word under cursor",
      },
      ["<C-e>"] = {
        function() require("telescope.builtin").find_files { no_ignore = true } end,
        desc = "Search all files",
      },
      ["<C-Up>"] = { "5gk", desc = "up 5" },
      ["<C-Down>"] = { "5gj", desc = "down 5" },
      ["<C-_>"] = {
        function() require("Comment.api").toggle.linewise.current() end,
        desc = "Comment line",
      },
    },
    v = {
      ["<C-_>"] = {
        "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        desc = "Toggle comment line",
      },
      ["<C-Up>"] = { "5gk", desc = "up 5" },
      ["<C-Down>"] = { "5gj", desc = "down 5" },
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
  },
  polish = function()
    augroup("astronvim_intput", { clear = true })
    cmd({ "InsertLeave" }, {
      desc = "InsertLeave",
      group = "astronvim_intput",
      callback = function() vim.cmd ":silent :!~/.config/nvim/im-select.exe 1033" end,
    })
    cmd({ "InsertEnter" }, {
      desc = "InsertEnter",
      group = "astronvim_intput",
      callback = function() vim.cmd ":silent :!~/.config/nvim/im-select.exe 2052" end,
    })
  end,
}

return config
