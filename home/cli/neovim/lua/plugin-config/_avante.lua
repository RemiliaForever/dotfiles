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
load_api_key("anthropic")
load_api_key("gemini")

require("avante").setup({
	provider = "gemini",
	behaviour = {
		enable_cursor_planning_mode = true,
	},
	providers = {
		claude = {
			endpoint = "https://api.anthropic.com",
			model = "claude-3-7-sonnet-20250219",
			timeout = 30000, -- Timeout in milliseconds
			extra_request_body = {
				temperature = 0,
				max_tokens = 20480,
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
		gemini = {},
	},
})
