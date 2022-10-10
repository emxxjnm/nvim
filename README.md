# ✨ Myles's Neovim dotfiles 🎉

## Preview
![Neovim](https://user-images.githubusercontent.com/54089360/192091625-0e9fbcf5-457a-4c99-9ea0-ddc8b20b9437.png)
![Editor](https://user-images.githubusercontent.com/54089360/194812133-d5b3cee0-fc6a-4bff-840c-eb8cbf0b4320.png)
![DAP](https://user-images.githubusercontent.com/54089360/194811741-987dd681-f5ce-4b2d-a625-30cd42faf1bd.png)

## TODO

- [ ] install script
- [ ] null-ls/lspconfig config

## ⚙️ Install

### 🪡 Prepare

create directories `swap`, `backup` and `undo` in vim cache directory.

font

```bash
docker run --rm -v /path/to/font:/in -v /path/for/output:/out nerdfonts/patcher --careful --complete --progressbars
```

### 🔗 Dependencies

- [ ] rgrep
- [ ] fd
- [ ] lazygit

## ⌨️  keymaps

### 📁 File Explorer(nvim-tree)

| key         | command                | description                         |
|-------------|------------------------|-------------------------------------|
| \<leader\>e | NvimTreeFindFileToggle | Toggle explorer for current bufname |
| \<leader\>E | NvimTreeToggle         | Toggle explorer                     |

for more keymapping information, see [nvim-tree](https://github.com/kyazdani42/nvim-tree.lua#defaults)

### 🚀 LSP(lspconf)

### Telescope

## 🔑 LICENSE
