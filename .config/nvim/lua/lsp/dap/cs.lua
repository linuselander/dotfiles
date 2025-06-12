local dap = require("dap")
local dotnet = require("utils.dotnet")


dap.adapters.coreclr = {
  type = 'executable',
  command = os.getenv("HOME") .. '/.local/share/netcoredbg/netcoredbg',
  args = { '--interpreter=vscode' }
}


local config = {
  {
    type = "coreclr",
    name = "Launch - .NET Core",
    request = "launch",
    program = function()
      local path = vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/' .. dotnet.get_project_dotnet_version() .. '/', 'file')
      -- Force absolute path to avoid netcoredbg args bug
      local abs_path = vim.fn.fnamemodify(path, ':p')
      print("Killing previous processes")
      dotnet.kill_listening_processes_on_ports()
      print("Launching: " .. abs_path)
      return abs_path
    end,
    cwd = vim.fn.getcwd(),
    env = function()
        local env_table, _ = dotnet.get_env_and_args()
      return env_table
    end,
    args = function()
        local _, arg_table = dotnet.get_env_and_args()
        if not arg_table then
            return nil
        end
        local args = {}
        for key, value in pairs(arg_table) do
            table.insert(args, key .. "=" .. value)
        end
      return args
    end,
    stopAtEntry = false,
  },
}

dap.configurations.cs = config
dap.configurations.csharp = config
