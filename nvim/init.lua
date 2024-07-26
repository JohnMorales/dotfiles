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
