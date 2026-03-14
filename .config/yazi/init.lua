-- git plugin
th.git = th.git or {}
th.git.untracked_sign = "✗"
th.git.updated_sign = "C"
th.git.clean_sign = "✓"
th.git.clean = ui.Style():fg("green")
require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}

-- full-border plugin
require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}

-- Show symlink in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)
