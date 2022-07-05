local M = {}

function M.setup()
  local alpha = require("alpha")
  local dashboard = require("alpha.themes.dashboard")

  dashboard.section.header.val = {
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
  }

  local opts = { noremap = true, silent = true }
  dashboard.section.buttons.val = {
    dashboard.button("n", "  New File", ":ene! <BAR> startinsert <CR>", opts),
    dashboard.button("f", "  Find File", ":Telescope find_files <CR>", opts),
    dashboard.button("p", "  Find Project", ":Telescope projects <CR>", opts),
    dashboard.button("r", "  Recently Opened", ":Telescope oldfiles <CR>", opts),
    dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>", opts),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>", opts),
  }

  dashboard.section.footer.val = "Myles Mo"

  alpha.setup(dashboard.opts)
end

return M
