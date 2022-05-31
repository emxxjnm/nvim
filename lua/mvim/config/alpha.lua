local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local dashboard = require("alpha.themes.dashboard")

local section = {
  header = {
    type = "text",
    val = {
      [[                                                                            ]],
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
      [[                                                                            ]],
    },
    opts = {
      position = "center",
      hl = "Type",
    }
  },
  buttons = {
    type = "group",
    val = {
      dashboard.button("n", "  New file", ":ene! <BAR> startinsert <CR>"),
      dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
      dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
      dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
      dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
      dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
    },
    opts = {
      spacing = 1,
    },
  },
  footer = {
    type = "text",
    val = "A ship in harbor is safe, but that is not what ships are built for.",
    opts = {
      position = "center",
      hl = "Label",
    },
  },
}


alpha.setup({
  layout = {
    { type = "padding", val = 2 },
    section.header,
    { type = "padding", val = 2 },
    section.buttons,
    { type = "padding", val = 1 },
    section.footer,
  },
  opts = {
    margin = 5,
    positon = "center",
  }
})
