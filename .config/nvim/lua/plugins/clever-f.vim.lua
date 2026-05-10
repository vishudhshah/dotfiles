-- clever f/F/t/T motions
return {
  "rhysd/clever-f.vim",
  event = "VeryLazy",
  init = function()
    -- vim.g.clever_f_across_no_line = 1  -- search only in current line
    vim.g.clever_f_fix_key_direction = 1  -- always f forward, F backward
    vim.g.clever_f_mark_direct = 1  -- highlight directly reachable chars
    vim.g.clever_f_chars_match_any_signs = ";"  -- match any symbol with ;
  end,
}
