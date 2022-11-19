# ✨ My Neovim dotfiles 🎉

## Preview

![Neovim](https://user-images.githubusercontent.com/54089360/192091625-0e9fbcf5-457a-4c99-9ea0-ddc8b20b9437.png)
![Editor](https://user-images.githubusercontent.com/54089360/194812133-d5b3cee0-fc6a-4bff-840c-eb8cbf0b4320.png)
![DAP](https://user-images.githubusercontent.com/54089360/194811741-987dd681-f5ce-4b2d-a625-30cd42faf1bd.png)

## ⚙️ Install

### 🪡 Prepare

* Font([INPUT](https://input.djr.com/preview/?size=14&language=python&theme=base16-dark&family=InputSans&width=300&weight=300&line-height=1.2&a=ss&g=ss&i=serifs_round&l=serifs_round&zero=0&asterisk=height&braces=straight&preset=default&customize=please))

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
