# Usage

```bash
git clone git@github.com:SITIOKLONG/dotfiles.git
```

# SSH play video

```bash
ssh -X -C -c chacha20-poly1305@openssh.com <ip>
sudo apt install mpv vlc
mpv video.mp4
```


```bash
ssh -L 6006:localhost:6006 <hostname@ip>
```

# nerdfront
```shell
brew install wget
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/0xProto.zip
```

# conda 
```shell
conda config --set auto_activate false
```

# ssh

install ssh

```bash
sudo apt update
sudo apt install openssh-server
```

check ssh service

```bash
sudo systemctl status ssh
```

allow ssh service

```
sudo ufw allow ssh
sudo ufw enable
```

# Zerotier

```
sudo apt install openssh-server   # Ubuntu/Debian
sudo systemctl enable --now ssh
sudo ufw status
sudo ufw allow 22
```
