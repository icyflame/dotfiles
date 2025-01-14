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
