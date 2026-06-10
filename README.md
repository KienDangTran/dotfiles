## For MacOS

- Install homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- run

```
./install
```

## For Debian
Generate ssh key https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

run:
`sudo ./install -p dotbot-apt/apt.py -c apt-packages.yml`

## For RockyLinux
Generate ssh key https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

run:
`sudo ./install -p dotbot-dnf/dnf.py -c rocky-packages.yml`

then:
`./install`

The first command installs base + EPEL packages. The second symlinks configs and runs the shell directive that enables COPR repos and installs `lazygit`, `starship`, `wezterm`, `git-delta`.

Note: `chroma` is not packaged for Rocky and is intentionally omitted; install it manually if you need it.
