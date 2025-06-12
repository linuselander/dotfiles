local json = require("utils.json")
local M = {}


function M.get_project_dotnet_version()
    local uv = vim.loop
    local path_sep = package.config:sub(1,1)

    -- Helper: join paths
    local function join_paths(...)
        return table.concat({...}, path_sep)
    end

    -- Helper: check if file exists
    local function file_exists(path)
        local stat = uv.fs_stat(path)
        return stat and stat.type == 'file'
    end

    -- Helper: get parent directory
    local function parent_dir(path)
        return path:match("(.*" .. path_sep .. ")") or path
    end

    -- Setup start paths
    local current_file = vim.api.nvim_buf_get_name(0)
    local start_dir = vim.fn.fnamemodify(current_file, ":p:h")
    local cwd = vim.fn.getcwd()

    local dir = start_dir
    local csproj_file = nil

    while true do
        -- Look for .csproj file in this directory
        local csproj_pattern = join_paths(dir, "*.csproj")
        local matches = vim.fn.glob(csproj_pattern, false, true)

        if #matches > 0 then
            csproj_file = matches[1]  -- pick first match
            break
        end

        -- If reached CWD or root, stop
        if dir == cwd or dir == parent_dir(dir) then
            break
        end

        -- Go up one directory
        dir = parent_dir(dir):gsub(path_sep .. "$", "")
    end

    -- If no .csproj found
    if not csproj_file then
        print("No .csproj file found between current file and CWD.")
        return
    end

    print("Found .csproj: " .. csproj_file)

    -- Read .csproj contents
    local file = io.open(csproj_file, "r")
    if not file then
        print("Failed to open " .. csproj_file)
        return
    end

    local content = file:read("*all")
    file:close()

    -- Extract TargetFramework or TargetFrameworks
    local target_framework = content:match("<TargetFramework>(.-)</TargetFramework>")
    local target_frameworks = content:match("<TargetFrameworks>(.-)</TargetFrameworks>")

    if target_framework then
        print("Target Framework: " .. target_framework)
        return target_framework
    elseif target_frameworks then
        print("Target Frameworks: " .. target_frameworks)
        return target_frameworks
    else
        print("Could not find TargetFramework or TargetFrameworks in the .csproj.")
        return
    end
end


function M.get_launch_profile()
  local json_path = vim.fn.getcwd() .. "/Properties/launchSettings.json"
  local launch_settings = json.parse(json_path)
  if not launch_settings then
      return nil
  end
  if launch_settings.profiles["https"] then
    return launch_settings.profiles["https"]
  elseif launch_settings.profiles["http"] then
    return launch_settings.profiles["http"]
  else
    for _, profile in pairs(launch_settings.profiles) do
      return profile
    end
  end


end

function M.get_env_and_args()
    local profile = M.get_launch_profile()

    if not profile then
        return nil
    end
  local env_table = {}
  local args_table = {}

  -- Environment variables from profile
  local env_vars = profile.environmentVariables or {}
  for k, v in pairs(env_vars) do
    env_table[k] = v
  end

  -- applicationUrl -> ASPNETCORE_URLS and --urls arg
  if profile.applicationUrl then
    env_table["ASPNETCORE_URLS"] = profile.applicationUrl
    args_table["--urls"] = profile.applicationUrl
    -- table.insert(args_table, "--urls=" .. profile.applicationUrl)
  end

  -- Ensure DOTNET_ENVIRONMENT is set
  if not env_table["DOTNET_ENVIRONMENT"] then
    env_table["DOTNET_ENVIRONMENT"] = env_table["ASPNETCORE_ENVIRONMENT"] or "Development"
  end

  return env_table, args_table
end

local function split(inputstr, sep)
  if sep == nil then sep = "%s" end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function M.get_port_numbers()
    local _, args_table = M.get_env_and_args()

    if not args_table then
        return nil
    end

    if not args_table["--urls"] then
        return nil
    end

    local application_url = args_table["--urls"]
    local application_urls = split(application_url, ";")


    local ports = {}
    for _, url in pairs(application_urls) do
        local url_parts = split(url, ":")
        local port_number = url_parts[3]
        table.insert(ports, port_number)
    end

    return ports
end

function M.kill_listening_processes_on_ports()
  local ports = M.get_port_numbers()

  if not ports then
      return nil
  end

  for _, port in ipairs(ports) do
    os.execute("lsof -tiTCP:" .. port .. " -sTCP:LISTEN | xargs --no-run-if-empty kill -9 >/dev/null 2>&1")
  end
end


return M
