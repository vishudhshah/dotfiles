-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "bearded-arc",
  
  -- transparent background for all themes everywhere
  transparency = true,

	hl_override = {
    -- make comments italic
		Comment = { italic = true },
		["@comment"] = { italic = true },

    -- control where background is transparent
    -- Normal = { bg = "NONE" },
    -- NormalNC = { bg = "NONE" },
    -- NormalFloat = { bg = "NONE" },
    -- EndOfBuffer = { bg = "NONE" },
	},

  hl_add = {
    TermNormal = { bg = "#1c2028", fg = "#ffffff" },  -- new group, needs hl_add
  },
}

-- Added by VS

-- Customize statusline
M.ui = {
  statusline = {
    theme = "default",  -- "default" | "vscode" | "vscode_colored" | "minimal"
    separator_style = "arrow",  -- "default" | "round" | "block" | "arrow"
    -- enabled = false,  -- if using lualine
  },
  -- tabufline = { enabled = false }, -- if using bufferline
}

return M
