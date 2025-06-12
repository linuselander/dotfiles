return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio", -- required by dap-ui
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Global keymap for dap
    local keymap = vim.keymap.set
    local del_keymap = vim.keymap.del

    keymap("n", "<F5>", function() dap.continue() end, { desc = "Start/Continue Debugging" })
    keymap("n", "<F9>", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })

    -- Functions to manage session keymaps
    local function safe_del_keymap(mode, lhs)
      pcall(del_keymap, mode, lhs)
    end

    local function clear_dap_session_keymaps()
      safe_del_keymap("n", "<leader>s")
      safe_del_keymap("n", "<leader>i")
      safe_del_keymap("n", "<leader>o")
      safe_del_keymap("n", "<leader>B")
      safe_del_keymap("n", "<leader>q")
    end

    local function set_dap_session_keymaps()
      keymap("n", "<leader>s", function() dap.step_over() end, { desc = "Step Over" })
      keymap("n", "<leader>i", function() dap.step_into() end, { desc = "Step Into" })
      keymap("n", "<leader>o", function() dap.step_out() end, { desc = "Step Out" })
      keymap("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Set Conditional Breakpoint" })
      keymap("n", "<leader>q", function()
        dap.disconnect({ terminateDebuggee = true })
        dap.close()
        dapui.close() -- <--- force-close dap-ui window
        clear_dap_session_keymaps() -- <--- also explicitly clear keymaps (safe)
      end, { desc = "Stops and exits the debugger" })
    end

    -- Unified event handler for dap-ui and keymaps
    dap.listeners.after.event_initialized["dap_config"] = function()
      dapui.open()
      set_dap_session_keymaps()
    end

    dap.listeners.before.event_terminated["dap_config"] = function()
      dapui.close()
      clear_dap_session_keymaps()
    end

    dap.listeners.before.event_exited["dap_config"] = function()
      dapui.close()
      clear_dap_session_keymaps()
    end
  end,
}
