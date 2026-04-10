local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", { width = 5 })

local apple = sbar.add("item", "apple", {
  icon = {
    font = { size = 16.0 },
    string = icons.apple,
    padding_right = 8,
    padding_left = 8,
  },
  label = { drawing = false },
  background = {
    color = colors.bg2,
    border_color = colors.black,
    border_width = 1,
  },
  padding_left = 1,
  padding_right = 1,
  popup = {
    align = "left",
    background = {
      color = colors.popup.bg,
      border_color = colors.popup.border,
      border_width = 2,
      corner_radius = 8,
    },
  },
})

local function apple_menu_item(name, label, script)
  return sbar.add("item", name, {
    position = "popup." .. apple.name,
    icon = { drawing = false },
    label = {
      string = label,
      color = colors.white,
      font = {
        family = settings.font.text,
        style = settings.font.style_map["Regular"],
        size = 12.0,
      },
      padding_left = 12,
      padding_right = 12,
    },
    click_script = script,
  })
end

apple_menu_item("apple.popup.about",    "About This Mac",     "open -a 'System Information'")
apple_menu_item("apple.popup.settings", "System Settings…",   "open -a 'System Preferences'")
apple_menu_item("apple.popup.lock",     "Lock Screen",        "osascript -e 'tell application \"System Events\" to keystroke \"q\" using {control down, command down}'")
apple_menu_item("apple.popup.sleep",    "Sleep",              "osascript -e 'tell application \"System Events\" to sleep'")
apple_menu_item("apple.popup.restart",  "Restart…",           "osascript -e 'tell application \"System Events\" to restart'")
apple_menu_item("apple.popup.shutdown", "Shut Down…",         "osascript -e 'tell application \"System Events\" to shut down'")

apple:subscribe("mouse.clicked", function(env)
  apple:set({ popup = { drawing = "toggle" } })
end)

apple:subscribe("mouse.exited.global", function(env)
  apple:set({ popup = { drawing = false } })
end)

-- Double border for apple using a single item bracket
sbar.add("bracket", { apple.name }, {
  background = {
    color = colors.transparent,
    height = 30,
    border_color = colors.grey,
  }
})

-- Padding item required because of bracket
sbar.add("item", { width = 7 })
