-- file util
-- Extracted from nvim-tree
M = {}

local a = vim.api
local uv = vim.loop
local path_separator = package.config:sub(1, 1)
function M.file_exists(path)
  local _, error = vim.loop.fs_stat(path)
  return error == nil
end

function M.get_input(folder)
  local ans = vim.fn.input("Create note ", folder)
  vim.api.nvim_command("normal! :")
  if not ans or #ans == 0 then
    return
  end
  return ans
end

function M.path_remove_trailing(path)
  local p, _ = path:gsub(path_separator .. "$", "")
  return p
end

function M.path_join(paths)
  return table.concat(vim.tbl_map(M.path_remove_trailing, paths), path_separator)
end

function M.path_split(path)
  return path:gmatch("[^" .. path_separator .. "]+" .. path_separator .. "?")
end

local function _create_file(file)
  if M.file_exists(file) then
    -- print(file .. " already exists")
    return
  end
  local ok, fd = pcall(uv.fs_open, file, "w", 420)
  if not ok then
    a.nvim_err_writeln("Couldn't create note " .. file)
    return
  end
  uv.fs_close(fd)
end

function M.get_num_nodes(iter)
  local i = 0
  for _ in iter do
    i = i + 1
  end
  return i
end

function string:endswith(ending)
  return ending == "" or self:sub(-#ending) == ending
end

function M.create_file(file_name)
  local file = M.get_input(file_name)
  if not file then
    print("Note name not provided.")
    return
  end

  if not file:endswith(".md") then
    file = file .. ".md"
  end

  -- create a folder for each path element if the folder does not exist
  -- if the answer ends with a /, create a file for the last path element
  local is_last_path_file = not file:match(path_separator .. "$")
  local path_to_create = ""
  local idx = 0
  local num_nodes = M.get_num_nodes(M.path_split(M.path_remove_trailing(file)))

  local is_error = false
  for path in file:gmatch("[^" .. path_separator .. "]+" .. path_separator .. "?") do
    idx = idx + 1
    local p = M.path_remove_trailing(path)
    if #path_to_create == 0 and vim.fn.has("win32") == 1 then
      path_to_create = M.path_join({ p, path_to_create })
    else
      path_to_create = M.path_join({ path_to_create, p })
    end
    if is_last_path_file and idx == num_nodes then
      _create_file(path_to_create)
    elseif not M.file_exists(path_to_create) then
      if not M.create_folder(path_to_create) then
        a.nvim_err_writeln("Could not create folder " .. path_to_create)
        is_error = true
        break
      end
    end
  end
  if not is_error then
    vim.api.nvim_command("normal! :e " .. file .. "\n")
    -- a.nvim_out_write(file .. " was properly created\n")
  end
end

M.create_folder = function(folder)
  local success = uv.fs_mkdir(folder, 493)
  return success
end

return M
