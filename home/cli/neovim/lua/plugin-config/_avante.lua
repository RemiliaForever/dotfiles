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
	provider = "copilot",
	behaviour = {
		enable_cursor_planning_mode = true,
	},
	providers = {
		copilot = {
			model = "gpt-5",
			timeout = 30000, -- Timeout in milliseconds
			context_window = 64000, -- Number of tokens to send to the model for context
			extra_request_body = {
				temperature = 0.75,
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
	},
})
