require("config.lazy")
require("config.telescope")
require("config.lspconfig")

require('neotest').setup {
    adapters = {
      require('rustaceanvim.neotest')
    },
}


vim.opt.wrap = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.ts = 2
vim.opt.sw = 2
vim.opt.expandtab = true

vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.format()<cr>")
