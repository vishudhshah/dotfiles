require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- Transparent lazygit window in Neovim
autocmd("TermOpen", {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if not bufname:match("lazygit") then
      vim.opt_local.winhighlight = "Normal:TermNormal"
    end
  end
})

-- Conceal in TeX files
autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.conceallevel = 2
    pcall(vim.treesitter.stop)  -- let VimTeX own syntax, not Treesitter
  end,
})

-- Change underline style to squiggle
autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd("highlight DiagnosticUnderlineError gui=undercurl")
    vim.cmd("highlight DiagnosticUnderlineWarn gui=undercurl")
    vim.cmd("highlight DiagnosticUnderlineInfo gui=undercurl")
    vim.cmd("highlight DiagnosticUnderlineHint gui=undercurl")
  end,
})

-- VSCode-style LaTeX SymPy evaluation
local function sympy_eval(mode)
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
  if #lines == 0 then return end
  lines[#lines] = lines[#lines]:sub(1, end_pos[3])
  lines[1] = lines[1]:sub(start_pos[3])
  local expr = table.concat(lines, " "):match("^%s*(.-)%s*$")
  if expr == "" then return end

  local script = "/tmp/sympy_eval.py"
  local fh = io.open(script, "w")
  fh:write(string.format([[
from sympy.parsing.latex import parse_latex
from sympy import latex, N
import re
expr = r"""%s"""
expr = re.sub(r'\\,\s*\\mathrm\{d\}', 'd', expr)
expr = re.sub(r'\\,\s*d', 'd', expr)
parsed = parse_latex(expr).doit()
if '%s' in ('numerical', 'numerical_equal'):
    print(latex(N(parsed)), end='')
else:
    print(latex(parsed), end='')
]], expr, mode))
  fh:close()
  local result = vim.fn.system("python3 " .. script):gsub("%s+$", "")

  if result == "" or result:match("^Traceback") then
    vim.notify("SymPy error: " .. result, vim.log.levels.ERROR)
    return
  end

  if mode == "replace" or mode == "numerical" then
    vim.api.nvim_buf_set_text(0, start_pos[2]-1, start_pos[3]-1, end_pos[2]-1, end_pos[3], { result })
  else -- equal or numerical_equal
    vim.api.nvim_buf_set_text(0, end_pos[2]-1, end_pos[3], end_pos[2]-1, end_pos[3], { " = " .. result })
  end
end

autocmd("FileType", {
  pattern = { "tex", "markdown" },
  callback = function()
    local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
    local function eval(mode)
      vim.api.nvim_feedkeys(esc, 'nx', false)
      sympy_eval(mode)
    end
    vim.keymap.set("x", "<leader>sr", function() eval("replace")         end, { desc = "SymPy replace",         buffer = true })
    vim.keymap.set("x", "<leader>se", function() eval("equal")           end, { desc = "SymPy equal",           buffer = true })
    vim.keymap.set("x", "<leader>sn", function() eval("numerical")       end, { desc = "SymPy numerical",       buffer = true })
    vim.keymap.set("x", "<leader>sm", function() eval("numerical_equal") end, { desc = "SymPy numerical equal", buffer = true })
  end,
})

-- Continue \item on <CR> within latex lists
autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.keymap.set("i", "<CR>", function()
      local indent = vim.api.nvim_get_current_line():match("^(%s*)\\item")
      if indent then
        return "\r\\item "
      end
      return "\r"
    end, { buffer = true, expr = true, desc = "Continue \\item on <CR>" })
  end,
})
