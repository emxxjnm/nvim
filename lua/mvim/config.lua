---@class mvim.config
local M = {}

---@class mvim.Palette
---@field pink string
---@field lavender string
---@field sapphire string
---@field yellow string
---@field green string
---@field red string
---@field blue string
---@field teal string
---@field peach string
---@field mauve string
---@field muted string
---@field subtle string

---@type mvim.Palette
M.palette = {}

---@class mvim.Theme
---@field lualine string
---@field bufferline_highlights fun(overrides: table): table

---@type mvim.Theme
M.theme = {
  lualine = "auto",
  bufferline_highlights = function(overrides) return overrides end,
}

M.transparent = true

M.border = M.transparent and "rounded" or "none"

-- stylua: ignore
M.icons = {
  diagnostics = {
    error = "󰃤 ",
    warn  = "󰚑 ",
    info  = "󰂚 ",
    hint  = "󱠂 ",
  },
  kinds = {
    Array         = " ",
    Boolean       = "󰨙 ",
    Class         = " ",
    Color         = " ",
    Constant      = "󰏿 ",
    Constructor   = " ",
    Enum          = " ",
    EnumMember    = " ",
    Event         = " ",
    Field         = " ",
    File          = " ",
    Folder        = " ",
    Function      = "󰊕 ",
    Interface     = " ",
    Keyword       = " ",
    Method        = " ",
    Module        = " ",
    Namespace     = "󰦮 ",
    Null          = "󰟢 ",
    Number        = "󰎠 ",
    Object        = " ",
    Operator      = " ",
    Package       = " ",
    Property      = " ",
    Reference     = " ",
    Snippet       = " ",
    String        = " ",
    Struct        = " ",
    Text          = " ",
    TypeParameter = " ",
    Unit          = " ",
    Value         = " ",
    Variable      = " ",
    Copilot       = " ",
  },
}

return M
