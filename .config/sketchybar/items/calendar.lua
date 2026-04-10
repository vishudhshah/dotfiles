local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", "cal", {
  icon = {
    color = colors.white,
    padding_left = 8,
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
  },
  label = {
    color = colors.white,
    padding_right = 8,
    width = "dynamic",
    align = "right",
    font = { family = settings.font.numbers },
  },
  position = "right",
  update_freq = 1,
  padding_left = 1,
  padding_right = 1,
  background = {
    color = colors.bg2,
    border_color = colors.black,
    border_width = 1,
  },
  popup = {
    align = "right",
    background = {
      color = colors.popup.bg,
      border_color = colors.popup.border,
      border_width = 2,
      corner_radius = 8,
    },
  },
})

-- Popup: full weekday + date
local cal_popup_date = sbar.add("item", "cal.popup.date", {
  position = "popup." .. cal.name,
  icon = { drawing = false },
  label = {
    string = os.date("%A, %B %d %Y"),
    color = colors.white,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 12.0,
    },
    padding_left = 12,
    padding_right = 12,
    align = "center",
  },
})

-- Popup: large clock (ticks every second via update_freq)
local cal_popup_time = sbar.add("item", "cal.popup.time", {
  position = "popup." .. cal.name,
  update_freq = 1,
  icon = { drawing = false },
  label = {
    string = os.date("%H:%M:%S"),
    color = colors.blue,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 26.0,
    },
    padding_left = 12,
    padding_right = 12,
    align = "center",
  },
})

-- Double border for calendar using a single item bracket
sbar.add("bracket", { cal.name }, {
  background = {
    color = colors.transparent,
    height = 30,
    border_color = colors.grey,
  }
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local function update()
  cal:set({ icon = os.date("%a %d %b"), label = os.date("%H:%M:%S") })
  cal_popup_date:set({ label = os.date("%A, %B %d %Y") })
  cal_popup_time:set({ label = os.date("%H:%M:%S") })
end

cal:subscribe({ "forced", "routine", "system_woke" }, update)

-- Tick the popup clock every second (only active when update_freq fires)
cal_popup_time:subscribe("routine", function(env)
  cal_popup_time:set({ label = os.date("%H:%M:%S") })
end)

cal:subscribe("mouse.clicked", function(env)
  update()
  cal:set({ popup = { drawing = "toggle" } })
end)

cal:subscribe("mouse.exited.global", function(env)
  cal:set({ popup = { drawing = false } })
end)
