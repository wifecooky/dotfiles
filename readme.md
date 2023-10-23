
# What

My dotfiles for development environment on M1 Mac,
using [chezmoi](https://www.chezmoi.io/) as dotfiles management tool.

# Getting Started

## 1. Install chezmoi

```bash
brew install chezmoi
```

## 2. Fetch dotfiles

```bash
export GITHUB_USERNAME=wifecooky
chezmoi init git@github.com:$GITHUB_USERNAME/dotfiles.git
```

## 3. Apply dotfiles

```bash
chezmoi init
chezmoi diff # check the difference
chezmoi apply -v # apply the difference
```

## 4. Update dotfiles

* Pull and apply the latest changes from your repo

```bash
chezmoi update -v
```

* Add new dotfiles

```bash
chezmoi add ~/.{YOUR_FILE}
chezmoi cd
git add .
git commit -m "add {YOUR_FILE}"
git push origin main
```
