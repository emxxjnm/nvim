setlocal nobuflisted " dap repl buffers should not pop up when doing :bn or :bp
setlocal nonumber norelativenumber cc=-1 nocuc

" Add autocompletion
lua require('dap.ext.autocompl').attach()
