# notes.nvim

Simple Note Taking Plugin

- No overwhelmingly extra features.
- Uses Markdown because that's more than enough. (And why would you want to learn something just to take notes)
- Configure root directory and start being productive.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{

  "dhananjaylatkar/notes.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- for picker="telescope"
    "echasnovski/mini.pick", -- for picker="mini-pick"
  },
  opts = {
    -- USE EMPTY FOR DEFAULT OPTIONS
    -- DEFAULTS ARE LISTED BELOW
  },
}
```

## Configuration

_**You must run `require("notes").setup()` to initialize the plugin.**_

_notes.nvim_ comes with following defaults:

```lua
{
  -- notes root dir
  root = os.getenv("HOME") .. "/code/notes/",
  -- picker
  picker = "telescope", -- "telescope" or "mini-pick"
}
```

## Commands

| Command      | Action                      |
| ------------ | --------------------------- |
| `:NotesFind` | Find notes in root dir      |
| `:NotesGrep` | Grep notes in root dir      |
| `:NotesNew`  | Create new note in root dir |
