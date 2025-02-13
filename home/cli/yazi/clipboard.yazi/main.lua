-- https://github.com/orhnk/system-clipboard.yazi

local selected_or_hovered = ya.sync(function()
	local current = cx.active.current.hovered
	if current then
		return tostring(current.url)
	else
		return nil
	end
end)

return {
	entry = function()
		local title = "System Clipboard"

		ya.manager_emit("escape", { visual = true })

		local url = selected_or_hovered()
		if url == nil then
			return ya.notify({ title = title, content = "No file selected", level = "warn", timeout = 2 })
		end

		local res, err = Command("bash")
			:args({ "-c", "cat " .. url .. " | wl-copy -f -o -t `xdg-mime query filetype " .. url .. "` " })
			:spawn()
		if err then
			return ya.notify({
				title = title,
				content = "Error: " .. tostring(err),
				level = "error",
				timeout = 2,
			})
		end
		ya.notify({
			title = title,
			content = "Copied: " .. url,
			level = "info",
			timeout = 1,
		})
		local res, err = res:wait_with_output()
		if err or not res.status.success then
			return ya.notify({
				title = title,
				content = "Error: " .. tostring(err or res.stderr),
				level = "error",
				timeout = 2,
			})
		end
	end,
}
