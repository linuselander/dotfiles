local dap = require("dap")

-- Adapter for Node.js
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = {
      vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
      "${port}",
    },
  },
}

-- Adapter for Chrome (frontend)
dap.adapters["pwa-chrome"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = {
      vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
      "${port}",
    },
  },
}

-- Configurations for JavaScript
dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch JS file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-chrome",
    request = "launch",
    name = "Launch Chrome against localhost",
    url = "http://localhost:4200", -- Adjust: 4200 = Angular / 3000 = React / Vite / Next
    webRoot = "${workspaceFolder}",
  },
}

-- Configurations for TypeScript
dap.configurations.typescript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch TS file (ts-node)",
    program = "${file}",
    cwd = "${workspaceFolder}",
    runtimeExecutable = "ts-node",
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    type = "pwa-chrome",
    request = "launch",
    name = "Launch Chrome against localhost",
    url = "http://localhost:4200", -- Adjust: 4200 = Angular / 3000 = React / Vite / Next
    webRoot = "${workspaceFolder}",
  },
}
