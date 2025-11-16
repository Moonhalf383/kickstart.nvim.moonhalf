-- lua/custom/plugins/dap.lua

return {
  -- 主插件 nvim-dap
  'mfussenegger/nvim-dap',
  ft = { 'c', 'cpp', 'rust', 'go', 'python' },
  dependencies = {
    -- 一个美观的 DAP UI 界面
    'rcarriga/nvim-dap-ui',

    -- 提供悬浮窗口查看变量等信息的功能
    'nvim-telescope/telescope-dap.nvim',

    -- Mason 可以帮你安装调试器（Debug Adapter）
    'mason-org/mason.nvim',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- 启用 dap-ui
    dapui.setup()

    -- 当DAP启动和结束时，自动打开和关闭dap-ui
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- ====================================================================
    -- 关键：配置调试器（Debug Adapters）
    -- ====================================================================
    -- nvim-dap 需要知道用什么程序来调试你的代码。这些程序被称为 "Debug Adapter"。
    -- 不同的语言需要不同的 Adapter。例如：
    -- C/C++/Rust: codelldb
    -- Go: delve
    -- Python: debugpy
    --
    -- 最简单的方式就是使用 Mason 来安装它们。例如运行 :MasonInstall codelldb

    -- C/C++/Rust 的调试器配置 (需要先用 :MasonInstall codelldb 安装)
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        -- 注意：你需要将 'codelldb' 替换成你系统中 codelldb 的实际路径
        -- Mason 会把它安装在 Neovim 的数据目录下，下面的代码会自动寻找
        command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
        args = { '--port', '${port}' },
      },
    }

    -- 调试配置：告诉DAP如何启动一个调试会话
    -- 这里我们为 C/C++/Rust 设置一个通用的启动配置
    dap.configurations.cpp = {
      {
        name = 'Launch file',
        type = 'codelldb',
        request = 'launch',
        program = function()
          -- 让用户输入要调试的可执行文件名
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    -- 如果文件类型一致，自动应用配置
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    -- ====================================================================
    -- 设置快捷键
    -- ====================================================================
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug: Toggle [B]reakpoint' })
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug: [C]ontinue' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = '[D]ebug: Step [I]nto' })
    vim.keymap.set('n', '<leader>do', dap.step_over, { desc = '[D]ebug: Step [O]ver' })
    vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = '[D]ebug: Step [O]ut' })
    vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = '[D]ebug: Open [R]EPL' })
    vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = '[D]ebug: [L]aunch Last' })
    vim.keymap.set('n', '<leader>dui', dapui.toggle, { desc = '[D]ebug: Toggle [UI]' })
  end,
}
