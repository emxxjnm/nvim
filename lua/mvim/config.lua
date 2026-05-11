---@class mvim.config
local M = {}

---@type CtpColors<string> | CtpColor
M.palette = {}

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
