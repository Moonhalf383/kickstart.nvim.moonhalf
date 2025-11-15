return {
  {
    'olimorris/onedarkpro.nvim',
    priority = 1000,
    config = function()
      require('onedarkpro').setup {
        highlights = {
          Comment = { italic = false },
          Directory = { bold = true },
          ErrorMsg = { italic = false, bold = true },
        },
      }
      vim.cmd 'colorscheme onedark'
    end,
  },
}
