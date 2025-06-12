local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local uv = vim.loop

-- Check if a folder contains a .csproj file
local function is_csproj_root(path)
  local handle = uv.fs_scandir(path)
  if not handle then return false end
  while true do
    local name = uv.fs_scandir_next(handle)
    if not name then break end
    if name:match("%.csproj$") then
      return true
    end
  end
  return false
end

-- Recursively find the closest folder upward with a .csproj
local function find_csproj_root(path)
  while path and path ~= "/" do
    if is_csproj_root(path) then
      return path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return nil
end

-- Convert relative path to dot-separated namespace
local function get_namespace()
  local file_path = vim.fn.expand("%:p:h")
  local root = find_csproj_root(file_path)

  if not root then
    return { "MyNamespace" }
  end

  local relative = file_path:sub(#root + 2)
  local parts = {}

  if relative ~= "" then
    for part in relative:gmatch("[^/]+") do
      table.insert(parts, part)
    end
  end

  table.insert(parts, 1, vim.fn.fnamemodify(root, ":t")) -- always add project folder name

  return { table.concat(parts, ".") }
end

-- Get filename without extension
local function get_class_name()
  return vim.fn.expand("%:t:r")
end

-- Check if buffer already contains a namespace
local function maybe_namespace()
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    if line:match("^%s*namespace%s+") then
      return { "" } -- already declared, just return empty
    end
  end

  local ns_parts = get_namespace()
  local ns = ns_parts and ns_parts[1] or "MyNamespace"
  return {
    "namespace " .. ns .. ";",
    "",
  }
end

-- Snippet definition
ls.add_snippets("cs", {
  s("class", {
    f(maybe_namespace, {}),
    t({ "" }), -- ⬅️ Explicit blank line between namespace and class
    i(1, "internal"), t(" class "),
    d(2, function()
      local default_name = vim.fn.expand("%:t:r")
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      for _, line in ipairs(lines) do
        if line:match("class%s+" .. vim.pesc(default_name)) then
          default_name = "ClassName"
          break
        end
      end

      return sn(nil, {
        i(1, default_name)
      })
    end, {}),
    t(" {"),
    t({ "", "    " }), i(0),
    t({ "", "}" }),
  }),
})

