#!/usr/bin/env bash
main() {
    cd "$HOME" || exit 1

    sudo pacman -S --needed --noconfirm \
    base-devel \
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
    nvidia-open \
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
    breeze-icons \
    gvfs-mtp \
    exfatprogs \
    ntfs-3g \
    dosfstools \
    ffmpegthumbnailer \
    smartmontools \
    wl-clipboard \
    man-db \
    man-pages \
    gnome-software \
    vlc
    git clone https://github.com/TimerLinux/HyprArch.git
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
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
    echo "ntsync" | sudo tee /etc/modules-load.d/ntsync.conf
    xdg-mime default org.gnome.Nautilus.desktop inode/directory
    for p in quiet fbcon=vc:2-6; do grep -qw -- "$p" /etc/kernel/cmdline || sudo sed -i "1 s|\$| $p|" /etc/kernel/cmdline; done
    sudo sed -i 's/^HOOKS=.*/HOOKS=(systemd autodetect microcode modconf block filesystems)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
    sudo reboot
}

main "$@"; exit
