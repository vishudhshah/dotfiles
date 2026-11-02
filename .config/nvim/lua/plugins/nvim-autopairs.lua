-- plugin for automatically closing brackets, quotes, etc.
return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  config = function()
    local autopairs = require('nvim-autopairs')
    local Rule = require('nvim-autopairs.rule')
    local cond = require('nvim-autopairs.conds')

    autopairs.setup({
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    })

    autopairs.state.rules = vim.tbl_filter(function(r)
      return r.start_key ~= '`'
    end, autopairs.state.rules)

    autopairs.add_rules({
      Rule('`', '`'):with_pair(function()
        return vim.bo.filetype ~= 'tex' and vim.bo.filetype ~= 'latex'
      end),
      Rule('`', "'", { 'tex', 'latex' }),
      -- * auto-pairs only when not right after a word char (start emphasis, not in-word *)
      Rule('*', '*', { 'markdown' })
        :with_pair(cond.not_before_regex('[%w\\-]'))
        :with_move(cond.move_right()),
    })
  end,
}
