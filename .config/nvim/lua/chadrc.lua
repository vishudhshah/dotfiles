-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "bearded-arc",

	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },
	},
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

-- Added by VS

-- Customize statusline
M.ui = {
  statusline = {
    theme = "default",  -- "default" | "vscode" | "vscode_colored" | "minimal"
    separator_style = "arrow",  -- "default" | "round" | "block" | "arrow"
  },
}

return M
