local M = {}

function M.parse(path)

  local file = io.open(path, "r")
  if not file then
    print("Could not open " .. path)
    return nil
  end

  local content = file:read("*a")
  file:close()

  -- Strip UTF-8 BOM if present
  if content:sub(1,3) == '\239\187\191' or content:sub(1,3) == '\xEF\xBB\xBF' then
    content = content:sub(4)
  end

  local ok, data = pcall(vim.json.decode, content)
  if not ok or not data then
    print("Could not parse " .. path)
    return nil
  end

  return data
end

return M
