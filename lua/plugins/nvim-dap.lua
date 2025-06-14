-- nvim-dap.lua

return {
    "mfusseneggar/nvim-dap",

    dependencies = {
        -- Creates a beautiful debugger UI
        "rcarriga/nvim-dap-ui",
    },

    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dap.adapters.coreclr = {
            type = 'executable',
            command = "C:/Users/ckhan/scoop/apps/netcoredbg/3.0.0-1018/netcoredbg.exe",
            args = { '--interpreter=vscode' }
        }
        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "launch - netcoredbg",
                request = "launch",
                program = function()
                    vim.opt.shellslash = false
                    return vim.fn.input('Path to dll ', vim.fn.getcwd(), 'file')
                end,
            }
        }

        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>B", function()
            dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
        end, { desc = "Debug: Set Breakpoint" })

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup {
            -- Set icons to characters that are more likely to work in every terminal.
            --    Feel free to remove or use ones that you like more! :)
            --    Don"t feel like these are good choices.
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            controls = {
                icons = {
                    pause = "⏸",
                    play = "▶",
                    step_into = "⏎",
                    step_over = "⏭",
                    step_out = "⏮",
                    step_back = "b",
                    run_last = "▶▶",
                    terminate = "⏹",
                    disconnect = "⏏",
                },
            },
        }

        -- Toggle to see last session result. Without this, you can"t see session output in case of unhandled exception.
        vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        -- dap.listeners.before.event_exited["dap:h dap-launch.jsonui_config"] = dapui.close
    end,
}
