local copilot = require("copilot")

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
})
vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#56b6c2", italic = true })

require("avante").setup({
	system_prompt = "Always respond in chinese. Prefer markdown format.",

	provider = "copilot",
	providers = {
		copilot = {
			model = "gpt-5-mini",
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
	web_search_engine = {
		provider = "google",
	},
	shortcuts = {
		{
			name = "resp",
			description = "translate to english and refine",
			details = "Translate to English and refine for clarity and coherence",
			prompt = "Please translate the following text to English and refine it for clarity and coherence:\n",
		},
		{
			name = "2en",
			description = "translate to english",
			details = "Translate to English",
			prompt = "Please translate the following text to English:\n",
		},
		{
			name = "2cn",
			description = "translate to chinese",
			details = "Translate to Chinese",
			prompt = "Please translate the following text to Chinese:\n",
		},
	},
})
