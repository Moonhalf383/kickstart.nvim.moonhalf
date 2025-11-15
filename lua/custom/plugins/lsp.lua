return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        lua_ls = {
          cmd = { 'lua-language-server' }, -- 使用 Termux 的系统版本
        },
      },
    },
  },
}
