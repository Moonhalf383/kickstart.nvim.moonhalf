return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      -- 设置终端窗口大小
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
      -- 打开终端的快捷键，这里设置为 Ctrl + \
      open_mapping = [[<A-t>]],
      -- 隐藏 toggleterm buffer 中的行号
      hide_numbers = true,
      -- 当 Neovim 目录切换时，终端下次打开也会切换到相应目录
      autochdir = true,
      -- 设置终端窗口的背景色，可以根据你的主题进行调整
      highlights = {
        Normal = {
          guibg = 'none', -- 这里设置为 "none" 表示使用默认背景
        },
        NormalFloat = {
          link = 'Normal',
        },
      },
      -- 阴影效果，如果设置了上面的 highlights 中的 Normal，建议将此项设为 false
      shade_terminals = true,
      -- 阴影的强度，数值越小越深
      shading_factor = -30,
      -- 启动时进入插入模式
      start_in_insert = true,
      -- 在插入模式下也可以使用 open_mapping 打开终端
      -- insert_mappings = true,
      -- 在终端窗口中也可以使用 open_mapping (会覆盖一些终端默认行为)
      -- terminal_mappings = true,
      -- 保持上次终端的大小
      -- persist_size = true,
      -- 终端进程退出时自动关闭窗口
      direction = 'float', -- 设置默认打开方式为浮动窗口
      close_on_exit = true,
      -- 使用 Neovim 的默认 shell
      shell = vim.o.shell,
      -- 自动滚动到底部
      auto_scroll = true,
      -- 浮动窗口的设置
      float_opts = {
        -- 边框样式
        border = 'curved', -- 使用圆角边框
        -- 窗口透明度
        winblend = 20,
      },
    }

    -- 设置一个函数，用于在 normal 模式下按下 <esc> 时退出终端
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts) -- jk 也可以退出
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    -- 当打开终端时，自动应用上面的快捷键设置
    vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'

    -- 定义一个快捷键，方便地打开一个 LazyGit 终端
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new {
      cmd = 'lazygit',
      hidden = true,
      direction = 'float',
    }

    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end

    vim.keymap.set('n', '<leader>gg', '<cmd>lua _LAZYGIT_TOGGLE()<CR>', {
      noremap = true,
      silent = true,
      desc = 'Lazygit',
    })
  end,
}
