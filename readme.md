# What

M1 Mac 向けの dotfiles を使った環境構築。
dotfiles の管理ツールは [chezmoi](https://www.chezmoi.io/) を使用。

* chezmoiのインストールおよび簡単な使い方

```bash
brew install chezmoi
chezmoi init

chezmoi add ~/.bashrc
chezmoi cd
git add .
git commit -m "add .bashrc"
git remote add origin https://github.com/$GITHUB_USERNAME/dotfiles.git
git branch -M main
git push -u origin main
```
