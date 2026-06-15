local capabilities = require('blink.cmp').get_lsp_capabilities()

local servers = { "html", "cssls", "ts_ls", "clangd", "texlab", "jsonls", "pyrefly" }

for _, server in ipairs(servers) do
  vim.lsp.config(server, { capabilities = capabilities })
end

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
