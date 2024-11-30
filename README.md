<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=24&pause=1000&color=B4BEFE&center=true&vCenter=true&width=435&lines=My+PDE+with+neovim" alt="Typing SVG" />
</p>

Personalized Development Environment(PDE)

* Transparency first.
* For coding `Rust`, `Vue3`, `Go`, `Python`.

| Language  | LSP           | Formatter            | Linter               |
| ---       | ---           | ---                  | ---                  |
| Go        | gopls         | goimports & gopls    | -                    |
| Rust      | rust-analyzer | rustfmt              | clippy               |
| Python    | pyright       | ruff                 | ruff                 |
| Vue/TS/JS | Volar         | eslint_d & stylelint | eslint_d & stylelint |

## Preview

![image](https://github.com/emxxjnm/nvim/assets/54089360/8876a392-c803-42cf-9793-46101e94e15a)
![image](https://github.com/emxxjnm/nvim/assets/54089360/d715070d-dabf-468a-b242-d9233fad5008)
![image](https://github.com/emxxjnm/nvim/assets/54089360/4c7892d6-6a24-4e5e-8ccb-12270654ad61)
![image](https://github.com/emxxjnm/nvim/assets/54089360/c973ff75-d4b4-4fad-b485-c515a61728ae)
![image](https://github.com/emxxjnm/nvim/assets/54089360/44b31fc1-fb2c-4e47-bf7a-b756d16e0837)

## Try it with docker

```bash
docker run -w /root -it --rm alpine:edge sh -uelic '
  apk add git lazygit neovim ripgrep fd fzf sqlite-dev python3 go npm alpine-sdk --update
  git clone https://github.com/emxxjnm/nvim.git ~/.config/nvim
  cd ~/.config/nvim
  nvim
'
```

## Prepare

### Terminal

* [Alacritty](https://alacritty.org/): my configuration [here](https://github.com/emxxjnm/dotfiles/tree/main/home/dot_config/alacritty)
* [Wezterm](https://wezfurlong.org/wezterm/): my configuration [here](https://github.com/emxxjnm/dotfiles/tree/main/home/dot_config/wezterm)

### Terminal Multiplexers

* [Tmux](https://github.com/tmux/tmux)
* [Zellij](https://github.com/zellij-org/zellij): My configuration [here](https://github.com/emxxjnm/dotfiles/tree/main/home/dot_config/zellij)

### Font
A few fonts that I personally like.

* [INPUT](https://input.djr.com/)

* [Monaspace](https://monaspace.githubnext.com/)

#### Patch the font(Nerd fonts)

```bash
docker run --rm \
    -v /path/to/font:/in \
    -v /path/for/output:/out \
    nerdfonts/patcher \
    --careful \
    --complete \
    --progressbars
```

### Text to ASCII

* [ASCII Art Generator](https://patorjk.com/software/taag/#p=display&f=Soft&t=Type%20Something%20)

### Dependencies

* [x] [fd](https://github.com/sharkdp/fd)
* [x] [fzf](https://github.com/junegunn/fzf)
* [x] [ripgrep](https://github.com/BurntSushi/ripgrep)
* [x] [lazygit](https://github.com/jesseduffield/lazygit)
* [x] [bat](https://github.com/sharkdp/bat)
* [x] [delta](https://github.com/dandavison/delta)

### Keymaps

#### General

| Key         | Description                   | Mode                |
| ------      | ---                           | ---                 |
| H           | To the first char of the line | **n**, **v**        |
| L           | To the end of the line        | **n**, **v**        |
| jj          | Exit insert mode              | **i**               |
| Up          | Increase window height        | **n**               |
| Down        | Decrease window height        | **n**               |
| Left        | Decrease window width         | **n**               |
| Right       | Increase window width         | **n**               |
| C-h         | Go to left window             | **n**               |
| C-j         | Go to lower window            | **n**               |
| C-k         | Go to upper window            | **n**               |
| C-l         | Go to right window            | **n**               |
| M-j         | Move down                     | **n**, **i**, **v** |
| M-k         | Move up                       | **n**, **i**, **v** |
| leader + w  | Save file                     | **n**               |
| leader + W  | Save files                    | **n**               |
| leader + q  | Quit                          | **n**               |
| leader + Q  | Force quit                    | **n**               |
| leader + _  | Split below                   | **n**               |
| leader + \| | Split right                   | **n**               |


### LSP

| Key            | Description           | Mode           |
| -------------- | --------------        | -------------- |
| gd             | Goto Definition       | **n**          |
| gD             | Goto Declaration      | **n**          |
| gr             | References            | **n**          |
| gi             | Goto Implementation   | **n**          |
| gt             | Goto Type Definition  | **n**          |
| K              | Hover                 | **n**          |
| gK             | Signature Help        | **n**          |
| C-k            | Signature Help        | **i**          |
| [d             | Next Diagnostic       | **n**          |
| ]d             | Prev Diagnostic       | **n**          |
| leader + ca    | Code Action           | **n**          |
| leader + cd    | Line Diagnostic       | **n**          |
| leader + cf    | Format Document/Range | **n**, **v**   |
| leader + cr    | Rename                | **n**          |
| leader + ll    | Lsp log               | **n**          |
| leader + li    | Lsp info              | **n**          |
| leader + lr    | Lsp restart           | **n**          |


### Finder: leader + f

| Key            | Description             | Mode           |
| -------------- | --------------          | -------------- |
| leader + fb    | List buffers            | **n**          |
| leader + fc    | Fuzzy search            | **n**          |
| leader + fd    | List diagnostics        | **n**          |
| leader + ff    | Find files              | **n**          |
| leader + fg    | Find in files (grep)    | **n**          |
| leader + fn    | Neovim Config file      | **n**          |
| leader + fr    | Recent files            | **n**          |
| leader + fR    | Resume                  | **n**          |
| leader + fs    | Find symbols            | **n**          |
| leader + fS    | Find symbols(workspace) | **n**          |
| leader + fT    | Find todos              | **n**          |
| leader + fw    | Find word               | **n**          |


### Buffer: leader + b

| Key            | Description        | Mode           |
| -------------- | --------------     | -------------- |
| [b             | Prev buffer        | **n**          |
| ]b             | Next buffer        | **n**          |
| leader + bc    | Pick close         | **n**          |
| leader + bd    | Delete buffer      | **n**          |
| leader + bD    | Delete other       | **n**          |
| leader + bH    | Close to the left  | **n**          |
| leader + bL    | Close to the right | **n**          |
| leader + bp    | Buffer pick        | **n**          |


### Git: leader + g

| Key            | Description    | Mode           |
| -------------- | -------------- | -------------- |
| [g             | Prev hunk      | **n**          |
| ]g             | Next hunk      | **n**          |
| leader + gb    | Blame line     | **n**          |
| leader + gd    | Diff this      | **n**          |
| leader + gg    | Lazygit        | **n**          |
| leader + gp    | Preview hunk   | **n**          |
| ig             | Select hunk    | **o**, **x**   |


### Debugger: leader + d

| Key            | Description       | Mode           |
| -------------- | --------------    | -------------- |
| leader + db    | Toggle breakpoint | **n**          |
| leader + dc    | Continue          | **n**          |
| leader + dC    | Run to cursor     | **n**          |
| leader + dt    | Terminate         | **n**          |
| leader + dr    | Restart           | **n**          |
| leader + dp    | Pause             | **n**          |
| leader + dO    | Step over         | **n**          |
| leader + di    | Step into         | **n**          |
| leader + do    | Step out          | **n**          |
| leader + du    | Toggle DAP UI     | **n**          |


### Options: leader + o

| Key            | Description     | Mode           |
| -------------- | --------------  | -------------- |
| leader + od    | Diagnostic      | **n**          |
| leader + of    | Format(Global)  | **n**          |
| leader + oF    | Format(Buffer)  | **n**          |
| leader + oh    | Hints           | **n**          |
| leader + ol    | Line Number     | **n**          |
| leader + oL    | Relative Number | **n**          |
| leader + os    | Spell           | **n**          |
| leader + ot    | Treesitter      | **n**          |
| leader + ow    | Wrap      | **n**          |


### Explorer

| Key            | Description          | Mode           |
| -------------- | --------------       | -------------- |
| C-n            | Toggle file explorer | **n**          |


### Tester: leader + t

| Key            | Description         | Mode           |
| -------------- | --------------      | -------------- |
| leader + tn    | Run                 | **n**          |
| leader + ta    | Attach              | **n**          |
| leader + tf    | Run file            | **n**          |
| leader + tl    | Run last            | **n**          |
| leader + tx    | Stop                | **n**          |
| leader + to    | Toggle output       | **n**          |
| leader + ts    | Toggle summaryu     | **n**          |
| leader + tp    | Toggle output panel | **n**          |
| [t             | Prev failed test    | **n**          |
| ]t             | Next failed test    | **n**          |


### LuaSnip

| Key            | Description     | Mode           |
| -------------- | --------------  | -------------- |
| C-o            | Select  options | **i**          |
