local root = ya.sync(function() return cx.active.current.cwd end)

local function entry(_, opt)
  local cwd_url = root()
  local root_str = tostring(cwd_url)

  local child = Command("mdfind")
    :arg({ "-0", "-onlyin", root_str, "kMDItemContentTypeTree == '" .. opt.args[1] .. "'" })
    :stdout(Command.PIPED)
    :stderr(Command.PIPED)
    :spawn()

  if not child then
    ya.notify({ title = "filter-type", content = "Failed to spawn mdfind", timeout = 3 })
    return
  end

  local output, err = child:wait_with_output()
  if not output then
    ya.notify({ title = "filter-type", content = "mdfind error: " .. tostring(err), timeout = 3 })
    return
  end

  local id = ya.id("ft")
  local search_cwd = cwd_url:into_search("mdfind: " .. opt.args[1])
  ya.emit("cd", { Url(search_cwd) })
  ya.emit("update_files", { op = fs.op("part", { id = id, url = Url(search_cwd), files = {} }) })

  local files = {}
  for line in output.stdout:gmatch("[^\0]+") do
    line = line:match("^%s*(.-)%s*$")  -- trim whitespace
    if line ~= "" then
      local filename = line:match("^" .. root_str:gsub("([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1") .. "/([^/]+)$")
      if filename then
        local url = Url(line)
        local cha = fs.cha(url, true)
        if cha then
          files[#files + 1] = File { url = url, cha = cha }
        end
      end
    end
  end

  ya.emit("update_files", { op = fs.op("part", { id = id, url = Url(search_cwd), files = files }) })
  ya.emit("update_files", { op = fs.op("done", { id = id, url = search_cwd, cha = Cha { mode = tonumber("100644", 8) } }) })
end

return { entry = entry }