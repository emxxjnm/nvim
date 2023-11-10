mo.styles = {
  transparent = true,
  icons = {
    git = {
      git = "",
      added = "",
      modified = "",
      deleted = "",
      renamed = "",
      ignored = "",
      untracked = "",
      unstaged = "",
      staged = "",
      megred = "",
      conflict = "",
      branch = "",
    },
    dap = {
      bug = "",
      signs = {
        breakpoint = "󰄛", -- md
        stopped = "󰋇", -- md
      },
      controls = {
        pause = "",
        play = "",
        step_into = "",
        step_over = "",
        step_out = "",
        step_back = "",
        restart = "",
        stop = "",
        disconnect = "",
      },
    },
    diagnostics = {
      error = "",
      warn = "",
      info = "",
      hint = "",
    },
    documents = {
      collapsed = "",
      expanded = "",
      new_file = "",
      file = "",
      files = "",
      file_symlink = "",
      folder = "󰉋", -- md
      folder_open = "󰝰", -- md
      root_folder = "",
      folder_symlink = "",
      empty_folder = "󰉖", -- md
      empty_folder_open = "󰷏", -- md

      modified = "●",
      close = "",
    },
    todo = {
      fix = "",
      todo = "",
      hack = "",
      warn = "",
      perf = "",
      note = "",
      test = "",
    },
    indent = {
      dash = "┊",
      solid = "│",
      last = "└",
    },
    plugin = {
      plugin = "",
      installed = "",
      uninstalled = "",
      pedding = "",
    },
    navigation = {
      indicator = "▎",
      breadcrumb = "",
      triangle_left = "",
      triangle_right = "",
      arrows = "",
      left_half_circle_thick = "",
      right_half_circle_thick = "",
    },
    misc = {
      flash = "󰉂",
      code = "",
      repo = "",
      buffer = "",
      treesitter = "",
      telescope = "",
      fish = "󰈺", -- md
      creation = "󰙴", --md
      search = "",
      star = "",
      history = "",
      vim = "",
      exit = "",
      ellipsis = "",
      snow = "",
      palette = "",
      plus = "",
      pulse = "",
      lazy = "󰒲 ",
      milestone = "",
      terminal = "",
      key = "",
      setting = "",
      task = "",
      markdown = "",
      clock = "",
      option = "󰘵",
      spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" },
      scrollbar = {
        "██",
        "▇▇",
        "▆▆",
        "▅▅",
        "▄▄",
        "▃▃",
        "▂▂",
        "▁▁",
        "  ",
      },
    },
    lsp = {
      lsp = "",
      kinds = {
        text = "",
        method = "",
        ["function"] = "",
        constructor = "",
        field = "",
        variable = "",
        class = "",
        interface = "",
        module = "", --
        property = "",
        unit = "", --
        value = "", --
        enum = "",
        keyword = "",
        -- snippet = "",
        snippet = "",
        color = "",
        file = "", --
        reference = "",
        folder = "", --
        enummember = "",
        constant = "",
        struct = "",
        event = "",
        operator = "",
        typeparameter = "", --

        namespace = "",
        package = "?",
        string = "",
        number = "",
        boolean = "",
        array = "",
        object = "?",
        key = "?",
        null = "?",
        codeium = "󰘦",
      },
    },
  },
  banner = [[
         .-') _     ('-.                      (`-.              _   .-')      
        ( OO ) )  _(  OO)                   _(OO  )_           ( '.( OO )_    
    ,--./ ,--,'  (,------.  .-'),-----. ,--(_/   ,. \  ,-.-')   ,--.   ,--.)  
    |   \ |  |\   |  .---' ( OO'  .-.  '\   \   /(__/  |  |OO)  |   `.'   |   
    |    \|  | )  |  |     /   |  | |  | \   \ /   /   |  |  \  |         |   
    |  .     |/  (|  '--.  \_) |  |\|  |  \   '   /,   |  |(_/  |  |'.'|  |   
    |  |\    |    |  .--'    \ |  | |  |   \     /__) ,|  |_.'  |  |   |  |   
    |  | \   |    |  `---.    `'  '-'  '    \   /    (_|  |     |  |   |  |   
    `--'  `--'    `------'      `-----'      `-'       `--'     `--'   `--'   
  ]],
  palettes = {},
}

mo.styles.border = mo.styles.transparent and "rounded" or "none"
