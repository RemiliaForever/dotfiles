local function status_seq()
	function Status:mode()
		local mode = tostring(self._tab.mode):sub(1, 3):upper()

		local style = self:style()
		return ui.Line({
			ui.Span(" " .. mode .. " "):style(style.main),
			ui.Span(""):fg(style.main.bg):bg(style.alt.bg),
		})
	end

	function Status:size()
		local h = self._current.hovered
		if not h then
			return ""
		end

		local style = self:style()
		return ui.Line({
			ui.Span(" " .. ya.readable_size(h:size() or h.cha.len) .. " "):style(style.alt),
			ui.Span(""):fg(style.alt.bg),
		})
	end

	function Status:percent()
		local percent = 0
		local cursor = self._current.cursor
		local length = #self._current.files
		if cursor ~= 0 and length ~= 0 then
			percent = math.floor((cursor + 1) * 100 / length)
		end

		if percent == 0 then
			percent = " Top "
		elseif percent == 100 then
			percent = " Bot "
		else
			percent = string.format(" %2d%% ", percent)
		end

		local style = self:style()
		return ui.Line({
			ui.Span(" "):fg(style.alt.bg),
			ui.Span(percent):style(style.alt),
		})
	end

	function Status:position()
		local cursor = self._current.cursor
		local length = #self._current.files

		local style = self:style()
		return ui.Line({
			ui.Span(""):fg(style.main.bg):bg(style.alt.bg),
			ui.Span(string.format(" %2d/%-2d ", math.min(cursor + 1, length), length)):style(style.main),
		})
	end
end

local function status()
	Status:children_add(function()
		local h = cx.active.current.hovered
		if h == nil or ya.target_family() ~= "unix" then
			return ""
		end

		return ui.Line({
			ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
			":",
			ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
			" ",
		})
	end, 500, Status.RIGHT)
end

local function hostname()
	Header:children_add(function()
		if ya.target_family() ~= "unix" then
			return ""
		end
		return ui.Span(ya.host_name() .. ": "):fg("blue")
	end, 500, Header.LEFT)
end

return {
	setup = function()
		status_seq()
		status()
		hostname()
	end,
}
