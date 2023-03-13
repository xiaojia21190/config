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
      foldlevelstart = 99,
      foldcolumn = "1",
      foldlevel = 99,
      foldenable = false,
    },
    -- g = {
    --   copilot_no_tab_map = true,
    --   copilot_assume_mapped = true,
    --   copilot_tab_fallback = "",
    -- },
  },
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
          request = "{attach",
          name = "Attach",
          processId = function(...) return require("dap.utils").pick_process(...) end, -- protect function
          cwd = "${workspaceFolder}",
        },
      },
    },
  },
  -- Configure plugins
  plugins = {
        {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require "astronvim.utils.status"

        opts.winbar = {
                         -- create custom winbar
          static = {
            disabled = {
                         -- set buffer and file types to disable winbar
              buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
              filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
            },
          },
          -- store the current buffer number
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          fallthrough = false, -- pick the correct winbar based on condition
          {
                               -- disabled buffer/file winbar
            condition = function(self)
              return vim.opt.diff:get() or status.condition.buffer_matches(self.disabled or {})
            end,
            init = function() vim.opt_local.winbar = nil end,
          },
          {
            -- inactive winbar
            condition = function() return not status.condition.is_active() end,
            -- show the path to the file relative to the working directory
            status.component.separated_path { path_func = status.provider.filename { modify = ":.:h" } },
            -- add the file name and icon
            status.component.file_info {
              file_icon = { hl = status.hl.file_icon "winbar", padding = { left = 0 } },
              file_modified = false,
              file_read_only = false,
              hl = status.hl.get_attributes("winbarnc", true),
              surround = false,
              update = "BufEnter",
            },
          },
          { -- active winbar
            -- show the path to the file relative to the working directory
            status.component.separated_path { path_func = status.provider.filename { modify = ":.:h" } },
            -- add the file name and icon
            status.component.file_info { -- add file_info to breadcrumbs
              file_icon = { hl = status.hl.filetype_color, padding = { left = 0 } },
              file_modified = false,
              file_read_only = false,
              hl = status.hl.get_attributes("winbar", true),
              surround = false,
              update = "BufEnter",
            },
            -- show the breadcrumbs
            status.component.breadcrumbs {
              icon = { hl = true },
              hl = status.hl.get_attributes("winbar", true),
              prefix = true,
              padding = { left = 0 },
            },
          },
        }

        return opts
      end,
    },

    {
      "dstein64/vim-startuptime",
      -- lazy-load on a command
      cmd = "StartupTime",
    },
    { "catppuccin/nvim", name = "catppuccin" },
    {
      "zbirenbaum/copilot.lua",
      event = "InsertEnter",
      config = function()
        require("copilot").setup {
          suggestion = { enabled = false },
          panel = { enabled = false },
        }
      end,
    },
    {
      "zbirenbaum/copilot-cmp",
      dependencies = { "copilot.lua" },
      config = function() require("copilot_cmp").setup() end,
    },
    { "ur4ltz/surround.nvim", event = "InsertEnter" },
    {
      "ggandor/leap.nvim",
      lazy = false,
      config = function()
        -- leap config
        require("leap").add_default_mappings()
        -- Disaule auto jump first match
        -- require('leap').opts.safe_labels = {}
        require("leap").opts.highlight_unlabeled_phase_one_targets = true
      end,
    },
    -- debug
    {
      "mxsdev/nvim-dap-vscode-js",
      dependencies = "mason-nvim-dap.nvim", -- setup after mason which  installs the debugger
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
      ["<C-Right>"] = {
        function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        desc = "Next buffer",
      },
      ["<C-Left>"] = {
        function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
        desc = "Previous buffer",
      },
      ["<A-1>"] = { "<cmd>Neotree focus<cr>", desc = "Focus Explorer" },
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
      ["<C-Up>"] = { "8gk", desc = "up 8" },
      ["<C-Down>"] = { "8gj", desc = "down 8" },
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
