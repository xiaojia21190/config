-- local dap_install = require("dap-install")
-- dap_install.setup({
--   installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
-- })
local map = vim.api.nvim_set_keymap

local opt = {
	noremap = true,
	silent = true,
}

local status, dap = pcall(require, "dap")
if not status then
	return
end

local status, dapui = pcall(require, "dapui")
if not status then
	return
end

local status, vt = pcall(require, "nvim-dap-virtual-text")
if not status then
	return
end

vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

--
vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointCondition",
	{ text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointRejected",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapLogPoint",
	{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

vt.setup({
	commented = true,
})

-- https://github.com/rcarriga/nvim-dap-ui
dapui.setup({
	element_mappings = {
		scopes = {
			open = "<CR>",
			edit = "e",
			expand = "o",
			repl = "r",
		},
	},

	layouts = {
		{
			elements = {
				-- Elements can be strings or table with id and size keys.
				{ id = "scopes", size = 0.4 },
				"stacks",
				"watches",
				"breakpoints",
				"console",
			},
			size = 0.35, -- 40 columns
			position = "left",
		},
		{
			elements = {
				"repl",
			},
			size = 0.25, -- 25% of total lines
			position = "bottom",
		},
	},

	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "rounded", -- Border style. Can be "single", "double" or "rounded"
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
}) -- use default
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
-- 开始
map("n", "<leader>dd", ":RustDebuggables<CR>", opt)
-- 结束
map(
	"n",
	"<leader>de",
	":lua require'dap'.close()<CR>"
		.. ":lua require'dap'.terminate()<CR>"
		.. ":lua require'dap.repl'.close()<CR>"
		.. ":lua require'dapui'.close()<CR>"
		.. ":lua require('dap').clear_breakpoints()<CR>"
		.. "<C-w>o<CR>",
	opt
)
-- 继续
map("n", "<F5>", ":lua require'dap'.continue()<CR>", opt)
-- 设置断点
map("n", "<leader>dt", ":lua require('dap').toggle_breakpoint()<CR>", opt)
map("n", "<leader>dT", ":lua require('dap').clear_breakpoints()<CR>", opt)
--  stepOver, stepOut, stepInto
map("n", "<F10>", ":lua require'dap'.step_over()<CR>", opt)
map("n", "<F11>", ":lua require'dap'.step_out()<CR>", opt)
map("n", "<F12>", ":lua require'dap'.step_into()<CR>", opt)
-- 弹窗
map("n", "<leader>dh", ":lua require'dapui'.eval()<CR>", opt)
