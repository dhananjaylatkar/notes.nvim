local fu = require("notes.file_util")

local M = {}

M.opts = {
  root = os.getenv("HOME") .. "/code/notes/",
  picker = "telescope", -- "telescope" or "mini-pick"
}

local _picker = {}

local assign_picker = function()
  if M.opts.picker == "telescope" then
    _picker.find_files = function()
      require("telescope.builtin").find_files({ cwd = M.opts.root })
    end

    _picker.grep = function()
      require("telescope.builtin").live_grep({ cwd = M.opts.root })
    end
  elseif M.opts.picker == "mini-pick" then
    _picker.find_files = function()
      MiniPick.builtin.files({}, { source = { name = "Notes (find)", cwd = M.opts.root } })
    end

    _picker.grep = function()
      MiniPick.builtin.grep_live({}, { source = { name = "Notes (grep)", cwd = M.opts.root } })
    end
  else
    print("Unsupported picker is provided")
  end
end

M.setup = function(opts)
  opts = opts or {}
  M.opts = vim.tbl_deep_extend("force", M.opts, opts)
  fu.create_folder(M.opts.root)
  assign_picker()
  M.create_cmds()
end

M.create_cmds = function()
  local create_cmd = vim.api.nvim_create_user_command
  create_cmd("NotesFind", M.find, { nargs = "*" })
  create_cmd("NotesGrep", M.grep, { nargs = "*" })
  create_cmd("NotesNew", M.create, { nargs = "*" })
end

M.find = function()
  _picker.find_files()
end

M.grep = function()
  _picker.grep()
end

M.create = function()
  fu.create_file(M.opts.root)
end

return M
