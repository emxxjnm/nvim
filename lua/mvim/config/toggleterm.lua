local M = {}

function M.setup()
  require("toggleterm").setup({
    size = 10,
    open_mapping = [[<c-\>]],
    -- on_open = fun(t: Terminal), -- function to run when the terminal opens
    -- on_close = fun(t: Terminal), -- function to run when the terminal closes
    -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string)
    -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string)
    -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string)
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    highlights = {
      Normal = {
        -- guibg = <VALUE-HERE>,
      },
      NormalFloat = {
        link = "Normal",
      },
      FloatBorder = {
        -- guifg = <VALUE-HERE>,
        -- guibg = <VALUE-HERE>,
      },
    },
    shade_terminals = true,
    shading_factor = 1,
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = true,
    direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float',
    close_on_exit = true, -- close the terminal window when the process exits
    -- shell = vim.o.shell, -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
      -- The border key is *almost* the same as 'nvim_open_win'
      -- see :h nvim_open_win for details on borders however
      -- the 'curved' border is a custom border type
      -- not natively supported but implemented in this plugin.
      border = "curved", -- 'single' | 'double' | 'shadow' | 'curved' |
      -- width = <value> -- number | function,
      -- height = <value> -- number | function,
      winblend = 0,
    },
  })
end

return M
