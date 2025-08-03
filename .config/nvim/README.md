# LightBoat.starter

The starter for [LightBoat](https://github.com/Kaiser-Yang/LightBoat).

Requirements:

- `rg`

Usage:

1. Backup your old configuration:

```bash
# run in bash
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

2. Clone the repository:

```bash
git clone https://github.com/Kaiser-Yang/LightBoat.starter.git ~/.config/nvim
```

3. Run `nvim` to download the plugins.

4. You can remove the `.git` directory in the repository so that you can create your own
git repository.

**NOTE**: When running `nvim` at the first time, you may encounter many errors. You just
need to restart `nvim` many times, and wait for the plugins intallation.

Check [LightBoat](https://github.com/Kaiser-Yang/LightBoat) to learn how to customize.
