return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "leoluz/nvim-dap-go",
    "rcarriga/nvim-dap-ui",
    -- "thaHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
  },
  config = function()
    local dap = require "dap"
    local ui = require "dapui"

    require("dapui").setup()
    require("dap-go").setup()
    -- require("nvim-dap-virutal-text").setup()

    local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
    if elixir_ls_debugger ~= "" then
      dap.adapters.mix_task = {
        type = "executable",
        command = elixir_ls_debugger,
      }

      dap.configurations.elixir = {
        {
          type = "mix_task",
          name = "phoenix server",
          task = "phx.server",
          request = "launch",
          projectDir = "${workspaceFolder}",
          exitAfterTaskReturns = false,
          debugAutoInterpretAllModules = false,
        },
      }
    end

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    ui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "",
          play = "",
          step_into = "󰓏",
          step_over = "",
          step_out = "󱆮",
          step_back = "",
          run_last = "",
          terminate = "",
          disconnect = "",
        },
      },
    })

    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
    end

    dap.adapters.ocamlearlybird = {
      type = 'executable',
      command = 'ocamlearlybird',
      args = { 'debug' }
    }

    dap.configurations.ocaml = {
      {
        name = 'OCaml Debug test.bc',
        type = 'ocamlearlybird',
        request = 'launch',
        program = '${workspaceFolder}/_build/default/test/test.bc',
      },
      {
        name = 'OCaml Debug main.bc',
        type = 'ocamlearlybird',
        request = 'launch',
        program = '${workspaceFolder}/_build/default/bin/main.bc',
      },
    }
  end
}
