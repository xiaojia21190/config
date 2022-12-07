--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key
local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
require("go").setup()

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
			{ "sheerun/vim-polyglot" },
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
			-- debug
			["mfussenegger/nvim-dap"] = {
				config = function()
					require("user.configs.nvim-dap")
				end,
			},
			["theHamsta/nvim-dap-virtual-text"] = {},
			["rcarriga/nvim-dap-ui"] = {},
			-- node
			["mxsdev/nvim-dap-vscode-js"] = {
				config = function()
					require("user.configs.vscode-js")
				end,
			},
			["ray-x/go.nvim"] = {
				config = function()
					require("go").setup({
						go = "go", -- go command, can be go[default] or go1.18beta1
						goimport = "gopls", -- goimport command, can be gopls[default] or goimport
						fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
						gofmt = "gofumpt", -- gofmt cmd,
						max_line_len = 120, -- max line length in goline format
						tag_transform = false, -- tag_transfer  check gomodifytags for details
						test_template = "", -- default to testify if not set; g:go_nvim_tests_template  check gotests for details
						test_template_dir = "", -- default to nil if not set; g:go_nvim_tests_template_dir  check gotests for details
						comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. ﳑ       
						icons = { breakpoint = "🧘", currentpos = "🏃" },
						verbose = false, -- output loginf in messages
					})
				end,
			},
			{ "ray-x/guihua.lua" },
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
	mappings = {
		-- first key is the mode
		n = {
			-- second key is the lefthand side of the map
			["-"] = { "Nzzzv", desc = "N" },
			["H"] = { "^", desc = "^" },
			["L"] = { "$", desc = "$" },
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
							return vim.list_extend(args, { "--no-ignore" })
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
					require("telescope.builtin").find_files({ no_ignore = true })
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
		augroup("format_sync_grp", { clear = true })
		cmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				require("go.format").goimport()
			end,
			group = "format_sync_grp",
		})
	end,
}

return config
