local get_cwd = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

local function entry(_, job)
	local mode = job.args[1] == "move" and "move" or "copy"

	local cwd = get_cwd()
	if not cwd then
		return
	end

	local value, event = ya.input({
		title = (mode == "move" and "Move" or "Copy") .. " (drop file here):",
		pos = { "center", w = 50, h = 3 },
	})

	if event ~= 1 then
		return
	end

	-- Strip surrounding quotes if Ghostty added them (it sometimes does)
	value = value:gsub("^'(.*)'$", "%1"):gsub('^"(.*)"$', "%1")

	local cmd_str = string.format(
		"%s %s %s",
		mode == "move" and "mv" or "cp -r",
		ya.quote(value),
		ya.quote(cwd)
	)

	local child, err = Command("sh"):arg("-c"):arg(cmd_str):spawn()
	if not child then
		ya.notify({ title = "Error", content = "Spawn failed: " .. tostring(err), level = "error" })
		return
	end

	local output, _ = child:wait()
	if output and output.success then
		ya.notify({
			title = "Success",
			content = (mode == "move" and "Moved" or "Copied") .. " successfully!",
			level = "info",
			timeout = 2.0,
		})
	else
		ya.notify({
			title = "Failed",
			content = "Operation failed — check path or permissions.",
			level = "error",
			timeout = 3.0,
		})
	end
end

return { entry = entry }
