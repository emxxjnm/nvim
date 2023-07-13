# ✨ My Neovim dotfiles 🎉

## Preview

|                                                                                                                               |                                                                                                                                |                                                                                                                                     |
| :---------------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------: |
| <img alt="Home" src="https://user-images.githubusercontent.com/54089360/219844972-3e47bb03-29fa-458a-975d-82822a8fabba.png">  | <img alt="Editor" src="https://user-images.githubusercontent.com/54089360/213395915-e1aadfc9-2e3b-403f-8258-a6cf43563b87.jpg"> | <img alt="Completion" src="https://user-images.githubusercontent.com/54089360/213395968-a5dad009-2bd0-4182-b76e-eef33e4fbe2d.jpg">  |
| <img alt="" src="https://user-images.githubusercontent.com/54089360/235862263-e560e35b-9124-47ce-b7d4-336386312cd8.jpg"> | <img alt="" src="https://user-images.githubusercontent.com/54089360/235862634-47ad1da2-261d-464e-aa89-3c66bee59e93.jpg"> | <img alt="" src="https://user-images.githubusercontent.com/54089360/235862747-8061ea3e-658a-409e-8efc-2e12b1dea2d7.jpg"> |

## ⚙️ Install

### Try it with docker

```bash
docker run -w /root -it --rm alpine:edge sh -uelic '
  apk add git lazygit neovim ripgrep fd fzf sqlite python3 go npm alpine-sdk --update
  git clone https://github.com/emxxjnm/nvim.git ~/.config/nvim
  cd ~/.config/nvim
  ./bootstrap.sh
  nvim
'
```

### 🪡 Prepare

* [Wallpaper](https://wallhaven.cc/w/zyxvqy)

* [Terminal: Kitty](https://sw.kovidgoyal.net/kitty/)

* [Font: INPUT](https://input.djr.com/preview/?size=14&language=python&theme=solarized-dark&family=InputMono&width=300&weight=300&line-height=1.2&a=ss&g=ss&i=topserif&l=topserif&zero=0&asterisk=height&braces=straight&preset=default&customize=please)

* [ASCII Art Generator](https://patorjk.com/software/taag/#p=display&f=Soft&t=Type%20Something%20)

```bash
# patch font
docker run --rm \
    -v /path/to/font:/in \
    -v /path/for/output:/out \
    nerdfonts/patcher \
    --careful \
    --complete \
    --progressbars
```

### 🔗 Dependencies

* [ ] ripgrep
* [ ] fd
* [ ] fzf
* [ ] lazygit

### ⌨️  Keymaps

#### General

| Key              | Description                   | Mode                |
| ------           | ---                           | ---                 |
| H                | To the first char of the line | **n**, **v**        |
| L                | To the end of the line        | **n**, **v**        |
| jj               | Exit insert mode              | **i**               |
| &lt;Up&gt;       | Increase window height        | **n**               |
| &lt;Down&gt;     | Decrease window height        | **n**               |
| &lt;Left&gt;     | Decrease window width         | **n**               |
| &lt;Right&gt;    | Increase window width         | **n**               |
| &lt;C-h&gt;      | Go to left window             | **n**               |
| &lt;C-j&gt;      | Go to lower window            | **n**               |
| &lt;C-k&gt;      | Go to upper window            | **n**               |
| &lt;C-l&gt;      | Go to right window            | **n**               |
| &lt;M-j&gt;      | Move down                     | **n**, **i**, **v** |
| &lt;M-k&gt;      | Move up                       | **n**, **i**, **v** |
| &lt;leader&gt;w  | Save file                     | **n**               |
| &lt;leader&gt;W  | Save files                    | **n**               |
| &lt;leader&gt;q  | Quit                          | **n**               |
| &lt;leader&gt;Q  | Force quit                    | **n**               |
| &lt;leader&gt;p  | Past clipboard text           | **n**               |
| &lt;leader&gt;y  | Copy to clipboard             | **v**               |
| &lt;leader&gt;-  | Split below                   | **n**               |
| &lt;leader&gt;\| | Split right                   | **n**               |

### LSP

| Key              | Description           | Mode           |
| --------------   | --------------        | -------------- |
| gd               | Goto Definition       | **n**          |
| gD               | Goto Declaration      | **n**          |
| gr               | References            | **n**          |
| gi               | Goto Implementation   | **n**          |
| gt               | Goto Type Definition  | **n**          |
| K                | Hover                 | **n**          |
| gK               | Signature Help        | **n**          |
| &lt;C-k&gt;      | Signature Help        | **i**          |
| [d               | Next Diagnostic       | **n**          |
| ]d               | Prev Diagnostic       | **n**          |
| &lt;leader&gt;ca | Signature Help        | **n**          |
| &lt;leader&gt;cr | Rename                | **n**          |
| &lt;leader&gt;cf | Format Document/Range | **n**, **v**   |
| &lt;leader&gt;cl | Lsp info              | **n**          |

### DAP

| Key              | Description       | Mode           |
| --------------   | --------------    | -------------- |
| &lt;leader&gt;db | Toggle breakpoint | **n**          |
| &lt;F5&gt;       | Continue          | **n**          |
| &lt;S-F5&gt;     | Terminate         | **n**          |
| &lt;M-S-F5&gt;   | Restart           | **n**          |
| &lt;F6&gt;       | Pause             | **n**          |
| &lt;F10&gt;      | Step over         | **n**          |
| &lt;F11&gt;      | Step into         | **n**          |
| &lt;F12&gt;      | Step out          | **n**          |
| &lt;leader&gt;du | Toggle DAP UI     | **n**          |

### Neo-tree

| Key            | Description          | Mode           |
| -------------- | --------------       | -------------- |
| &lt;C-n&gt;    | Toggle file explorer | **n**          |

### Telescope

| Key              | Description          | Mode           |
| --------------   | --------------       | -------------- |
| &lt;leader&gt;ff | Find files           | **n**          |
| &lt;leader&gt;fg | Find in files (grep) | **n**          |
| &lt;leader&gt;fr | Recent files         | **n**          |
| &lt;leader&gt;fp | Recent projects      | **n**          |
| &lt;leader&gt;fc | Fuzzy search         | **n**          |
| &lt;leader&gt;fb | List buffers         | **n**          |
| &lt;leader&gt;fd | List diagnostics     | **n**          |
| &lt;leader&gt;fs | List symbols         | **n**          |
| &lt;leader&gt;ft | List todos           | **n**          |

### Gitsings

| Key              | Description    | Mode           |
| --------------   | -------------- | -------------- |
| [g               | Prev hunk      | **n**          |
| ]g               | Next hunk      | **n**          |
| &lt;leader&gt;gp | Preview hunk   | **n**          |
| ig               | Select hunk    | **o**, **x**   |

### Toggleterm

| Key               | Description         | Mode           |
| --------------    | --------------      | -------------- |
| &lt;C-\&gt;       | Toggle terminal     | **n**          |
| &lt;leader&gt;t=  | Float terminal      | **n**          |
| &lt;leader&gt;t\| | Vertical terminal   | **n**          |
| &lt;leader&gt;t-  | Horizontal terminal | **n**          |
| &lt;leader&gt;gg  | Lazygit             | **n**          |

### LuaSnip

| Key            | Description     | Mode           |
| -------------- | --------------  | -------------- |
| &lt;C-o&gt;    | Select  options | **i**          |

### Bufferline

| Key              | Description        | Mode           |
| --------------   | --------------     | -------------- |
| [b               | Prev buffer        | **n**          |
| ]b               | Next buffer        | **n**          |
| &lt;leader&gt;bp | Buffer pick        | **n**          |
| &lt;leader&gt;bc | Pick close         | **n**          |
| &lt;leader&gt;bD | Close others       | **n**          |
| &lt;leader&gt;bL | Close to the left  | **n**          |
| &lt;leader&gt;bR | Close to the right | **n**          |

### Neotest

| Key              | Description         | Mode           |
| --------------   | --------------      | -------------- |
| &lt;leader&gt;nn | Run                 | **n**          |
| &lt;leader&gt;na | Attach              | **n**          |
| &lt;leader&gt;nf | Run file            | **n**          |
| &lt;leader&gt;nx | Stop                | **n**          |
| &lt;leader&gt;no | Toggle output       | **n**          |
| &lt;leader&gt;ns | Toggle summaryu     | **n**          |
| &lt;leader&gt;np | Toggle output panel | **n**          |
| [n               | Prev failed test    | **n**          |
| ]n               | Next failed test    | **n**          |
