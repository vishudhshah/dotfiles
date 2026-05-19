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
    theme = "default",  -- default | vscode | vscode_colored | minimal
    separator_style = "arrow",  -- default | round | block | arrow
    modules = {
      file = function()
        local utils = require "nvchad.stl.utils"
        local config = require("nvconfig").ui.statusline
        local sep_style = config.separator_style
        local separators = (type(sep_style) == "table" and sep_style) or utils.separators[sep_style]
        local sep_r = separators["right"]
        local x = utils.file()
        -- local indicator = " ●"
        local indicator = " *"
        local modified = vim.bo[utils.stbufnr()].modified and indicator or ""
        return "%#St_file# " .. x[1] .. " " .. x[2] .. modified .. "%#St_file_sep#" .. sep_r
      end,
    },
    -- enabled = false,  -- if using lualine
  },
  tabufline = {
    -- enabled = false  -- if using bufferline
    modules = {
      gitbranch = (function()
        local cache = ""
        local function update()
          local head = io.open(vim.fn.getcwd() .. "/.git/HEAD", "r")
          if head then
            local line = head:read("*l")
            head:close()
            cache = line and line:match("ref: refs/heads/(.+)") or ""
          else
            cache = ""
          end
        end
        update()
        vim.api.nvim_create_autocmd({ "DirChanged", "BufEnter" }, {
          callback = update,
        })
        return function()
          return cache ~= "" and ("%#Comment#  " .. cache .. " ") or ""
        end
      end)(),
    },
    order = { "treeOffset", "buffers", "tabs", "gitbranch", "btns" }
  },
}

return M
