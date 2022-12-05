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
                },
        },
        colorscheme = "carbonfox",
        -- Configure plugins
        plugins = {
                init = {
                        ["kana/vim-textobj-user"] = { as = "textobj-user" },
                        ["kana/vim-textobj-entire"] = { as = "textobj-entire" },
                        ["ur4ltz/surround.nvim"] = { as = "ur4ltz" },
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
                                        require("flit").setup({
                                                keys = { f = "f", F = "F", t = "t", T = "T" },
                                                -- A string like "nv", "nvo", "o", etc.
                                                labeled_modes = "v",
                                                multiline = true,
                                                -- Like `leap`s similar argument (call-specific overrides).
                                                -- E.g.: opts = { equivalence_classes = {} }
                                                opts = {},
                                        })
                                end,
                        },
                        ["catppuccin/nvim"] = {
                                as = "catppuccin",
                                config = function()
                                        require("catppuccin").setup({})
                                end,
                        },
                        ["EdenEast/nightfox.nvim"] = { as = "EdenEast" },
                        -- debug
                        ["mfussenegger/nvim-dap"] = {
                                as = "mfussenegger",
                                config = function()
                                        require("user.configs.nvim-dap")
                                end,
                        },
                        ["theHamsta/nvim-dap-virtual-text"] = { as = "theHamsta" },
                        ["rcarriga/nvim-dap-ui"] = { as = "rcarriga" },
                        -- node
                        ["mxsdev/nvim-dap-vscode-js"] = {
                                config = function()
                                        require("user.configs.vscode-js")
                                end,
                        },
                },
        },
        mappings = {
                -- first key is the mode
                n = {
                        -- second key is the lefthand side of the map
                        -- mappings seen under group name "Buffer"
                        -- ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
                        -- ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
                        -- ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
                        -- ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
                        -- quick save
                        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
                        ["-"] = { "Nzzzv", desc = "N" },
                        ["="] = { "nzzzv", desc = "n" },
                        ["<A-Right>"] = { "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer tab" },
                        ["<A-Left>"] = { "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer tab" },
                        ["<A-m>"] = { "<cmd>Neotree focus<cr>", desc = "Focus Explorer" },
                        ["<leader><CR>"] = { "<cmd>nohlsearch<cr>", desc = "No Highlight" },
                        ["<leader>q"] = {
                                function()
                                        require("bufdelete").bufdelete(0, false)
                                end,
                                desc = "Close buffer",
                        },
                        ["<CS-f>"] = {
                                function()
                                        require("telescope.builtin").live_grep({
                                                additional_args = function(args)
                                                        return vim.list_extend(args, { "--hidden", "--no-ignore" })
                                                end,
                                        })
                                end,
                                desc = "Search words in all files",
                        },
                        ["<C-f>"] = {
                                function()
                                        require("telescope.builtin").grep_string()
                                end,
                                desc = "Search for word under cursor",
                        },
                        ["<C-e>"] = {
                                function()
                                        require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
                                end,
                                desc = "Search all files",
                        },
                        ["<C-Up>"] = { "5gk", desc = "up 5" },
                        ["<C-Down>"] = { "5gj", desc = "down 5" },
                        ["<C-_>"] = {
                                function()
                                        require("Comment.api").toggle.linewise.current()
                                end,
                                desc = "Comment line",
                        },
                },
                v = {
                        ["<C-_>"] = {
                                "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
                                desc = "Toggle comment line",
                        },
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
                        callback = function()
                                vim.cmd(":silent :!~/.config/nvim/im-select.exe 1033")
                        end,
                })
                cmd({ "InsertEnter" }, {
                        desc = "InsertEnter",
                        group = "astronvim_intput",
                        callback = function()
                                vim.cmd(":silent :!~/.config/nvim/im-select.exe 2052")
                        end,
                })
        end,
}

return config
