-- Rex config — reload with `rex config reload`, validate with `rex config check`
-- Docs: https://www.superlogical.com/rex/docs/customize/config

-- ——— Keybindings ———

-- Option+Delete Hermes hack. Remove once PR #152193 is merged and Hermes is updated.
rex.bind("alt+backspace", "pane.send_key", { key = "ctrl+w" })
