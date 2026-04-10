local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("graph", "widgets.cpu", 42, {
  position = "right",
  graph = { color = colors.blue },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = icons.cpu },
  label = {
    string = "cpu ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4,
  },
  padding_right = settings.paddings + 6,
  popup = {
    background = {
      color = colors.popup.bg,
      border_color = colors.popup.border,
      border_width = 2,
      corner_radius = 8,
    },
  },
})

local cpu_popup_user = sbar.add("item", "widgets.cpu.popup.user", {
  position = "popup." .. cpu.name,
  icon = {
    string = "User",
    color = colors.grey,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 11.0,
    },
    width = 55,
    align = "left",
  },
  label = {
    string = "??%",
    color = colors.blue,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 11.0,
    },
    width = 38,
    align = "right",
  },
})

local cpu_popup_sys = sbar.add("item", "widgets.cpu.popup.sys", {
  position = "popup." .. cpu.name,
  icon = {
    string = "System",
    color = colors.grey,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 11.0,
    },
    width = 55,
    align = "left",
  },
  label = {
    string = "??%",
    color = colors.orange,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 11.0,
    },
    width = 38,
    align = "right",
  },
})

local cpu_popup_total = sbar.add("item", "widgets.cpu.popup.total", {
  position = "popup." .. cpu.name,
  icon = {
    string = "Total",
    color = colors.grey,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 11.0,
    },
    width = 55,
    align = "left",
  },
  label = {
    string = "??%",
    color = colors.white,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 11.0,
    },
    width = 38,
    align = "right",
  },
})

cpu:subscribe("cpu_update", function(env)
  local load = tonumber(env.total_load)
  cpu:push({ load / 100. })

  local color = colors.blue
  if load > 30 then
    if load < 60 then
      color = colors.yellow
    elseif load < 80 then
      color = colors.orange
    else
      color = colors.red
    end
  end

  cpu:set({
    graph = { color = color },
    label = "cpu " .. env.total_load .. "%",
  })

  cpu_popup_user:set({ label = (env.user_load or "?") .. "%" })
  cpu_popup_sys:set({ label = (env.sys_load or "?") .. "%" })
  cpu_popup_total:set({ label = env.total_load .. "%" })
end)

cpu:subscribe("mouse.clicked", function(env)
  cpu:set({ popup = { drawing = "toggle" } })
end)

cpu:subscribe("mouse.exited.global", function(env)
  cpu:set({ popup = { drawing = false } })
end)

-- Background around the cpu item
sbar.add("bracket", "widgets.cpu.bracket", { cpu.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.cpu.padding", {
  position = "right",
  width = settings.group_paddings
})
