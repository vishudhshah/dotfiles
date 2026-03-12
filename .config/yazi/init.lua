-- git.yazi plugin
th.git = th.git or {}
th.git.untracked_sign = "U"
th.git.updated_sign = "C"
th.git.clean_sign = "✓"
th.git.clean = ui.Style():fg("green")
require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}
