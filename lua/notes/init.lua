local tb = require("telescope.builtin")
local fu = require("notes.file_util")

local M = {}

M.opts = {
  root = os.getenv("HOME") .. "/code/notes/",
}

M.setup = function(opts)
  opts = opts or {}
  M.opts = vim.tbl_deep_extend("force", M.opts, opts)
  fu.create_folder(M.opts.root)
  M.create_cmds()
end

M.create_cmds = function()
  local create_cmd = vim.api.nvim_create_user_command
  create_cmd("NotesFind", M.find, { nargs = "*" })
  create_cmd("NotesGrep", M.grep, { nargs = "*" })
  create_cmd("NotesNew", M.create, { nargs = "*" })
end

M.find = function()
  tb.find_files({ cwd = M.opts.root })
end

M.grep = function()
  tb.live_grep({ cwd = M.opts.root })
end

M.create = function()
  fu.create_file(M.opts.root)
end

return M
