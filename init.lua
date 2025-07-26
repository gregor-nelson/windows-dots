-- Custom Theme Configuration for Neovim
-- Based on the provided color scheme

-- Color definitions
local colors = {
  black = "#1e222a",
  white = "#abb2bf",
  gray2 = "#2e323a", -- unfocused window border
  gray3 = "#545862",
  gray4 = "#6d8dad",
  blue = "#61afef",  -- focused window border
  green = "#7EC7A2",
  red = "#e06c75",
  orange = "#caaa6a",
  yellow = "#EBCB8B",
  pink = "#c678dd",
  border = "#1e222a" -- inner border
}

-- Basic Neovim settings
vim.opt.termguicolors = true    -- Enable 24-bit RGB colors
vim.opt.background = "dark"     -- Set dark background
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers
vim.opt.cursorline = true       -- Highlight current line
vim.opt.signcolumn = "yes"      -- Always show sign column

-- Additional visual improvements
vim.opt.scrolloff = 8           -- Keep 8 lines above/below cursor when scrolling
vim.opt.sidescrolloff = 8       -- Keep 8 columns to the left/right of cursor
vim.opt.wrap = false            -- Don't wrap lines
vim.opt.showmode = false        -- Don't show mode (like -- INSERT --) in command line
vim.opt.showcmd = true          -- Show partial commands in the last line
vim.opt.showmatch = true        -- Highlight matching brackets when cursor is over one
vim.opt.matchtime = 3           -- How many tenths of a second to show the match for
vim.opt.laststatus = 2          -- Always show statusline
vim.opt.shortmess:append("c")   -- Don't pass messages to |ins-completion-menu|
vim.opt.wildmenu = true         -- Enhanced command-line completion
vim.opt.cmdheight = 1           -- Height of the command bar
vim.opt.conceallevel = 0        -- Show text normally
vim.opt.pumheight = 10          -- Maximum number of items to show in popup menu

-- Indent settings (only visual - doesn't affect file content)
vim.opt.smartindent = true      -- Smart autoindenting when starting a new line
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.shiftwidth = 2          -- Number of spaces to use for autoindent
vim.opt.tabstop = 2             -- Number of spaces a tab counts for
vim.opt.softtabstop = 2         -- Edit as if tabs are this many spaces

-- Remove visual distraction
vim.opt.fillchars = {
  eob = " ",                    -- No ~ for empty lines at end of buffer
  vert = "│",                   -- Prettier window separator (instead of |)
  fold = "·",                   -- Prettier fold indicator
  foldopen = "▾",               -- Prettier fold open indicator
  foldsep = "│",                -- Prettier fold separator
  foldclose = "▸",              -- Prettier fold closed indicator
}

-- Define the custom colorscheme
local function create_custom_theme()
  -- Clear any existing highlights
  vim.cmd("highlight clear")

  -- Set the colorscheme name
  vim.g.colors_name = "custom_theme"

  -- Define highlight groups
  local highlights = {
    -- UI elements
    Normal = { fg = colors.white, bg = colors.black },
    NormalFloat = { fg = colors.white, bg = colors.gray2 },
    LineNr = { fg = colors.gray3 },
    CursorLine = { bg = colors.gray2 },
    CursorLineNr = { fg = colors.blue, bold = true },

    -- Window borders
    VertSplit = { fg = colors.border, bg = colors.border },

    -- Status line
    StatusLine = { fg = colors.white, bg = colors.gray3 },
    StatusLineNC = { fg = colors.gray4, bg = colors.gray2 },

    -- Search
    Search = { fg = colors.black, bg = colors.yellow },
    IncSearch = { fg = colors.black, bg = colors.orange },

    -- Syntax highlighting
    Comment = { fg = colors.gray4, italic = true },
    String = { fg = colors.green },
    Number = { fg = colors.orange },
    Function = { fg = colors.blue },
    Keyword = { fg = colors.pink },
    Identifier = { fg = colors.white },
    Statement = { fg = colors.pink },
    Type = { fg = colors.yellow },
    Special = { fg = colors.orange },
    Constant = { fg = colors.orange },
    Operator = { fg = colors.blue },
    PreProc = { fg = colors.pink },

    -- Diagnostics
    DiagnosticError = { fg = colors.red },
    DiagnosticWarn = { fg = colors.yellow },
    DiagnosticInfo = { fg = colors.blue },
    DiagnosticHint = { fg = colors.green },

    -- Diff
    DiffAdd = { fg = colors.green },
    DiffChange = { fg = colors.blue },
    DiffDelete = { fg = colors.red },
    DiffText = { fg = colors.white, bg = colors.blue },

    -- Pmenu (completion menu)
    Pmenu = { fg = colors.white, bg = colors.gray2 },
    PmenuSel = { fg = colors.black, bg = colors.blue },
    PmenuSbar = { bg = colors.gray3 },
    PmenuThumb = { bg = colors.gray4 },
  }

  -- Apply highlights
  for group, settings in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

-- Apply the custom theme
create_custom_theme()


-- Define command to refresh the theme
vim.api.nvim_create_user_command('RefreshTheme', function()
  create_custom_theme()
  vim.notify('Theme refreshed!')
end, {})

