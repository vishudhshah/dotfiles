-- for code folding
return {
  "luukvbaal/statuscol.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local builtin = require("statuscol.builtin")

    -- Custom fold indicator: arrow only, no depth digits
    local function fold_indicator()
      local lnum = vim.v.lnum
      local closed = vim.fn.foldclosed(lnum)
      local foldlevel = vim.fn.foldlevel(lnum)
      local prev_foldlevel = vim.fn.foldlevel(lnum - 1)

      if foldlevel == 0 then
        return " "  -- not foldable, blank
      end

      if closed == lnum then
        return "▶"  -- fold starts here and is closed
      end

      if foldlevel > prev_foldlevel then
        return "▼"  -- fold starts here and is open
      end

      return " "  -- inside a fold, blank
    end

    -- offset current line number
    local function lnum_offset()
      if vim.v.virtnum ~= 0 then return "" end
      local width = #tostring(vim.fn.line("$")) + 2
      if vim.v.relnum == 0 then
        return string.format("%" .. (width - 1) .. "d ", vim.v.lnum)
      else
        return string.format("%" .. width .. "d", vim.v.relnum)
      end
    end

    require("statuscol").setup({
      -- don't apply custom statuscolumn to these special windows
      ft_ignore = { "NvimTree", "lazy", "mason", "help", "toggleterm", "TelescopePrompt" },
      segments = {
        { text = { fold_indicator }, click = "v:lua.ScFa" },
        { text = { " " } },  -- spacer
        { text = { "%s" }, click = "v:lua.ScSa" },
        { text = { lnum_offset, " " }, click = "v:lua.ScLa" },
      },
    })
  end,
}
