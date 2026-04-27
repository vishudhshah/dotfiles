local capabilities = require('blink.cmp').get_lsp_capabilities()

local servers = { "html", "cssls", "ts_ls", "clangd", "texlab", "jsonls" }

for _, server in ipairs(servers) do
  vim.lsp.config(server, { capabilities = capabilities })
end

-- turn off type checking for Python
vim.lsp.config("basedpyright", {
  capabilities = capabilities,
  settings = {
    basedpyright = {
      typeCheckingMode = "off",
    },
  },
})

vim.lsp.enable(servers)
vim.lsp.enable("basedpyright")

-- read :h vim.lsp.config for changing options of lsp servers 
