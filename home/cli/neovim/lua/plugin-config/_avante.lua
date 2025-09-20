local copilot = require("copilot")

local model = "gpt-4.1"

-- Copilot
copilot.setup({
	panel = { enabled = false },
	suggestion = {
		enabled = true,
		auto_trigger = true,
		keymap = {
			accept = "<C-e>",
			next = "<C-j>",
			prev = "<C-k>",
		},
	},
	filetypes = {
		["markdown"] = true,
		["yaml"] = true,
	},
	copilot_mode = model,
})
vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#56b6c2", italic = true })

-- MCP Hub
require("mcphub").setup({
	auto_approve = true,
})

require("avante").setup({
	system_prompt = function()
		local user_prompt = "Always respond in chinese. Prefer markdown format."
		local hub = require("mcphub").get_hub_instance()
		return hub and user_prompt .. hub:get_active_servers_prompt() or ""
	end,
	-- Using function prevents requiring mcphub before it's loaded
	custom_tools = function()
		return {
			require("mcphub.extensions.avante").mcp_tool(),
		}
	end,
	disabled_tools = {
		"list_files", -- Built-in file operations
		"search_files",
		"read_file",
		"create_file",
		"rename_file",
		"delete_file",
		"create_dir",
		"rename_dir",
		"delete_dir",
		"git_diff",
		"git_commit",
		"web_search",
	},

	provider = "copilot",
	providers = {
		copilot = {
			model = model,
			timeout = 5000, -- Timeout in milliseconds
			context_window = 64000, -- Number of tokens to send to the model for context
			extra_request_body = {
				max_tokens = 4096,
			},
		},
		deepseek = {
			__inherited_from = "openai",
			api_key_name = "DEEPSEEK_API_KEY",
			endpoint = "https://api.deepseek.com",
			model = "deepseek-coder",
			--reasoning_effort = "medium",
			timeout = 30000,
			extra_request_body = {
				temperature = 0,
				max_completion_tokens = 8192,
			},
		},
	},
})
