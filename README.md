# ✨ My Neovim dotfiles 🎉

## Preview

![Neovim](https://user-images.githubusercontent.com/54089360/202839491-7ab99fdf-1e97-410c-a3c3-58e4ff962363.png)
![Editor](https://user-images.githubusercontent.com/54089360/202839863-1b8b812b-9167-4bae-a393-4c34a7c38baa.png)

## ⚙️ Install

### 🪡 Prepare

* [Wallpaper](https://wallhaven.cc/w/zyxvqy)

* [Terminal: Kitty](https://sw.kovidgoyal.net/kitty/)

* [Font: input](https://input.djr.com/preview/?size=14&language=python&theme=base16-dark&family=InputSans&width=300&weight=300&line-height=1.2&a=ss&g=ss&i=serifs_round&l=serifs_round&zero=0&asterisk=height&braces=straight&preset=default&customize=please)

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

* [ ] rgrep
* [ ] fd
* [ ] lazygit
