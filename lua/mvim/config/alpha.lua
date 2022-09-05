local M = {}

function M.setup()
  local format = string.format
  local alpha = require("alpha")
  local dashboard = require("alpha.themes.dashboard")

  local function button(hl, ...)
    local btn = dashboard.button(...)
    local details = select(2, ...)
    local icon = details:match("[^%w%s]+")
    btn.opts.hl = { { hl, 0, #icon + 1 } }
    btn.opts.hl_shortcut = "MatchParen"
    return btn
  end

  local version = vim.version()
  local plugins = #vim.tbl_keys(packer_plugins)
  local nvim_version_info = format(
    " Neovim v%d.%d.%d",
    version.major,
    version.minor,
    version.patch
  )
  local nvim_information = {
    type = "text",
    val = format("---  %d plugins installed, %s ---", plugins, nvim_version_info),
    opts = { position = "center", hl = "Conceal" },
  }

  dashboard.section.header.opts.hl = "Type"
  dashboard.section.header.val = {
    [[                                                                            ]],
    [[       .-') _     ('-.                      (`-.              _   .-')      ]],
    [[      ( OO ) )  _(  OO)                   _(OO  )_           ( '.( OO )_    ]],
    [[  ,--./ ,--,'  (,------.  .-'),-----. ,--(_/   ,. \  ,-.-')   ,--.   ,--.)  ]],
    [[  |   \ |  |\   |  .---' ( OO'  .-.  '\   \   /(__/  |  |OO)  |   `.'   |   ]],
    [[  |    \|  | )  |  |     /   |  | |  | \   \ /   /   |  |  \  |         |   ]],
    [[  |  .     |/  (|  '--.  \_) |  |\|  |  \   '   /,   |  |(_/  |  |'.'|  |   ]],
    [[  |  |\    |    |  .--'    \ |  | |  |   \     /__) ,|  |_.'  |  |   |  |   ]],
    [[  |  | \   |    |  `---.    `'  '-'  '    \   /    (_|  |     |  |   |  |   ]],
    [[  `--'  `--'    `------'      `-----'      `-'       `--'     `--'   `--'   ]],
    [[                                                                            ]],
  }

  dashboard.section.buttons.val = {
    button("Statement", "n", "  New File", ":ene! <BAR> startinsert <CR>"),
    button("Include", "f", "  Find File", ":Telescope find_files <CR>"),
    button("Structure", "p", "  Find Project", ":Telescope projects <CR>"),
    button("Operator", "r", "  Recently Opened", ":Telescope oldfiles <CR>"),
    button("String", "c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
    button("Conditional", "q", "  Quit Neovim", ":qa<CR>"),
  }

  dashboard.section.footer.val = "Myles Mo"
  dashboard.section.footer.opts.hl = "CursorLineNr"

  alpha.setup({
    layout = {
      { type = "padding", val = 4 },
      dashboard.section.header,
      { type = "padding", val = 1 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
      { type = "padding", val = 1 },
      nvim_information,
    },
    opts = { margin = 5 },
  })
end

return M
