#!/usr/bin/env bash
# HyprArch – automatyczna instalacja (kroki 1:1 z README i pliku "installation").
#
# Uruchom w TTY jako zwykły użytkownik (nie root):
#   curl -fsSL https://raw.githubusercontent.com/TimerLinux/HyprArch/main/install.sh | bash
#
# Komendy, które się nie powiodą, trafiają do ~/hyprarch-install-errors.log
# (skrypt idzie dalej, tak jak przy ręcznym wklejaniu).

main() {
    [[ $EUID -ne 0 ]] || { echo "Uruchom jako zwykły użytkownik, nie jako root."; exit 1; }
    [[ -f /etc/arch-release ]] || { echo "To nie jest Arch Linux."; exit 1; }

    # Przy "curl ... | bash" wejściem jest potok, więc pytania (hasło sudo, pacman) czytamy z terminala
    if [[ ! -t 0 ]]; then { exec </dev/tty; } 2>/dev/null || true; fi

    # Komendy z repo zakładają, że działają w katalogu domowym (~/HyprArch)
    cd "$HOME" || exit 1

    LOG="$HOME/hyprarch-install-errors.log"
    : > "$LOG"
    trap 'echo "[linia $LINENO] $BASH_COMMAND" >> "$LOG"' ERR
    
    sudo -v
    sudo pacman -S --needed --noconfirm \
    hyprland \
    kitty \
    nautilus \
    firefox \
    xdg-desktop-portal-hyprland \
    power-profiles-daemon \
    fastfetch \
    btop \
    fish \
    adw-gtk-theme \
    nwg-look \
    qt6ct \
    qt5ct \
    qt6-wayland \
    qt5-wayland \
    pacman-contrib \
    uwsm \
    speech-dispatcher \
    python-pillow \
    icoextract \
    git \
    oxygen-cursors \
    libva-nvidia-driver \
    nvidia-settings \
    7zip \
    unrar \
    unzip \
    zip \
    fuse2 \
    flatpak \
    reflector \
    nano \
    noctalia-greeter \
    accountsservice \
    noctalia \
    gnome-text-editor \
    gnome-disk-utility \
    baobab \
    loupe \
    gnome-calculator \
    ark \
    gvfs-mtp \
    exfatprogs \
    ntfs-3g \
    dosfstools \
    ffmpegthumbnailer \
    smartmontools \
    wl-clipboard \
    man-db \
    man-pages \
    bazaar \
    vlc
    git clone https://github.com/TimerLinux/HyprArch.git
    cp -a ~/HyprArch/config/. ~/.config/
    chmod +x ~/.config/hypr/scripts/theme-reload
    sudo cp ~/HyprArch/system/reflector/reflector.conf /etc/xdg/reflector/reflector.conf
    sudo cp ~/HyprArch/system/greetd/config.toml /etc/greetd/config.toml
    sudo mkdir -p /var/lib/noctalia-greeter
    sudo cp ~/HyprArch/system/noctalia-greeter/greeter.toml /var/lib/noctalia-greeter/greeter.toml
    sudo systemctl disable getty@tty1.service
    sudo systemctl enable greetd
    sudo chsh -s /usr/bin/fish $USER
    sudo usermod -c "Arch Linux" $USER
    sudo noctalia-greeter passwordless-sync enable $USER
    sudo systemctl enable --now accounts-daemon
    sudo systemctl enable --now btrfs-scrub@-.timer
    sudo systemctl enable --now paccache.timer
    sudo systemctl enable --now reflector.timer
    sudo systemctl start reflector.service
    echo "ntsync" | sudo tee /etc/modules-load.d/ntsync.conf
    xdg-mime default org.gnome.Nautilus.desktop inode/directory
    mkdir -p ~/Obrazy/Wallpapers
    mkdir -p ~/Obrazy/Screenshots
    for p in quiet fbcon=vc:2-6; do grep -qw -- "$p" /etc/kernel/cmdline || sudo sed -i "1 s|\$| $p|" /etc/kernel/cmdline; done
    sudo sed -i 's/^HOOKS=.*/HOOKS=(systemd autodetect microcode modconf keyboard block filesystems)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
    sudo reboot
}

# Całość jest w funkcji, więc nic się nie wykona, jeśli pobieranie urwie się w połowie
main "$@"; exit
