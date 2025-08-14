## @icyflame's dotfiles

> Configuration files to setup any new computer in a few minutes

### Setup experiences - computers

- [2019-07 Setting up Ubuntu 18.04][1]

[1]: https://gist.github.com/icyflame/1399a7462f4c56103f8417b26875f5c5

## Usage

Generate an SSH key and add the following configuration into the `~/.ssh/config` file:

```conf
Host github.com
    IdentityFile /home/kannan.siddharth/.ssh/id_temp_id25519
```

Then, clone the repository:

```sh
git clone git@github.com:icyflame/dotfiles.git
```

Then, clone all submodules recursively:

```sh
git submodule update --init --recursive
```

Install `zsh` and change the default shell to `zsh` using:

```sh
chsh -s `which zsh`
```

Now, run the `bootstrap-dotfiles.sh` to put all the configuration files in
place:

```sh
# Check dry-run output:
bash bootstrap-dotfiles.sh

# After checking dry-run output:
bash bootstrap-dotfiles.sh --go
```

Now, opening a new shell, you should see the zsh shell, with all your zprezto plugins included. You
might have to logout and login in order to get the `chsh` to take effect.

In order to apply color schemes, run the appropriate script inside the `color-schemes` directory.

## Keybindings

### Gnome Shell Extension - PaperWM

PaperWM's keybindings are stored in the `dconf` database. They can be fetched using `dconf dump`,
read individually using `dconf read`, written individually using `dconf write`, and set to the
default values using `dconf reset -f`.

See the script inside the `scripts/keybindings/` directory to use my preferred keys

Note that PaperWM does not store its default keybindings anywhere. This means that for a new version
of the PaperWM extension, there might be new actions that have gained keybindings. However, these
will not show up in the `dconf` database. One would have to go to the extension's settings, and in
the keybindings tab, manually update all the unnecessary keybindings to `Disabled`.

``` sh
$ export KEYBINDINGS_KEY="/org/gnome/shell/extensions/paperwm/keybindings/"; dconf reset -f "${KEYBINDINGS_KEY}"
```

## [Unmaintained] Setting up an Apple computer

> I used to use a Macbook at work. But I don't use one anymore. So, these setup instructions are old
> and unmaintained. I am keeping them around in case I need to use a Macbook again at some point in
> the future.

1. Import your vimrc.
2. Install zsh. Install zsh-syntax-highlighting and zsh-autosuggestions using
   git clone. Import zshrc and configure everything
3. Install iTerm 2. Import the colorscheme file inside the `color-schemes`
   directory with the extension `itermcolors`
4. Install `golang`

### IntelliJ IDEA

[Solarized dark color scheme](https://github.com/jkaving/intellij-colors-solarized)
