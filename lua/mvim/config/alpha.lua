local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

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

dashboard.section.buttons.val = {
  dashboard.button("n", "  New File", ":ene! <BAR> startinsert <CR>"),
  dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
  dashboard.button("p", "  Find Project", ":Telescope projects <CR>"),
  dashboard.button("r", "  Recently Opened", ":Telescope oldfiles <CR>"),
  dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
  dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

dashboard.section.footer.val = "Myles Mo"

alpha.setup(dashboard.opts)
