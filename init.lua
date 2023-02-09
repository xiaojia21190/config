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
    g = {
      copilot_no_tab_map = true,
      copilot_assume_mapped = true,
      copilot_tab_fallback = "",
    },
  },
  colorscheme = "default_theme",
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
    {
      "dstein64/vim-startuptime",
      -- lazy-load on a command
      cmd = "StartupTime",
    },
    -- { "github/copilot.vim", event = "InsertEnter" },
    ["zbirenbaum/copilot.lua"] = {
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup {
          panel = {
            enabled = true,
            auto_refresh = false,
            keymap = {
              jump_prev = "[[",
              jump_next = "]]",
              accept = "<CR>",
              refresh = "gr",
              open = "<M-CR>",
            },
            layout = {
              position = "bottom", -- | top | left | right
              ratio = 0.4,
            },
          },
          suggestion = {
            enabled = true,
            auto_trigger = false,
            debounce = 75,
            keymap = {
              accept = "<M-l>",
              accept_word = false,
              accept_line = false,
              next = "<M-]>",
              prev = "<M-[>",
              dismiss = "<C-]>",
            },
          },
          filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
          },
          copilot_node_command = "node", -- Node.js version must be > 16.x
          server_opts_overrides = {},
        }
      end,
    },
    { "ur4ltz/surround.nvim" },
    ["kevinhwang91/nvim-ufo"] = {
      lazy = false,
      requires = { "kevinhwang91/promise-async" },
      config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
        local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
        for _, ls in ipairs(language_servers) do
          require("lspconfig")[ls].setup {
            capabilities = capabilities,
            -- you can add other fields for setting up lsp server in this table
          }
        end

        local handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ("  %d "):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              -- str width returned from truncate() may less than 2nd argument, need padding
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, "MoreMsg" })
          return newVirtText
        end
        require("ufo").setup {
          fold_virt_text_handler = handler,
        }
      end,
    },

    ["ggandor/leap.nvim"] = {
      as = "leap",
      config = function()
        -- leap config
        require("leap").add_default_mappings()
        -- Disaule auto jump first match
        -- require('leap').opts.safe_labels = {}
        require("leap").opts.highlight_unlabeled_phase_one_targets = true
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
      ["<C-Right>"] = { function() astronvim.nav_buf(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" },
      ["<C-Left>"] = {
        function() astronvim.nav_buf(-(vim.v.count > 0 and vim.v.count or 1)) end,
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
