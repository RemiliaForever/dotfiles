local copilot = require("copilot")

local model = "gpt-4.1"

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

-- load api key
local function load_api_key(name)
	local f = io.open("/run/secrets/api/" .. name, "r")
	if f then
		local content = f:read("a")
		vim.fn.setenv(string.upper(name) .. "_API_KEY", content)
		f:close()
	end
end

load_api_key("deepseek")

require("avante").setup({
	system_prompt = "Always respond in chinese. Prefer markdown format.",
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
