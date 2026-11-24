#!/usr/bin/env bash
main() {
    cd "$HOME" || exit 1
    sudo pacman -S --needed --noconfirm \
    hyprland \
    kitty \
    nautilus \
    btop \
    nwg-look \
    bazaar \
    xdg-desktop-portal-hyprland \
    power-profiles-daemon \
    fastfetch \
    fish \
    adw-gtk-theme \
    qt6-wayland \
    qt5-wayland \
    pacman-contrib \
    uwsm \
    python-pillow \
    icoextract \
    ffmpegthumbnailer \
    oxygen-cursors \
    nvidia-open \
    fuse2 \
    flatpak \
    reflector \
    base-devel \
    git \
    noctalia-greeter \
    noctalia
    git clone https://github.com/TimerLinux/HyprArch.git
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
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
    sudo systemctl enable --now btrfs-scrub@-.timer
    sudo systemctl enable --now paccache.timer
    sudo systemctl enable --now reflector.timer
    echo "ntsync" | sudo tee /etc/modules-load.d/ntsync.conf
    xdg-mime default org.gnome.Nautilus.desktop inode/directory
    for p in quiet fbcon=vc:2-6; do grep -qw -- "$p" /etc/kernel/cmdline || sudo sed -i "1 s|\$| $p|" /etc/kernel/cmdline; done
    sudo sed -i 's/^HOOKS=.*/HOOKS=(systemd autodetect microcode modconf block filesystems)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
    cd "$HOME"
    rm -rf ~/HyprArch ~/paru-bin
    sudo rm /usr/share/applications/lstopo.desktop
    sudo rm /usr/share/applications/dev.noctalia.Noctalia.desktop
    sudo rm /usr/share/applications/uuctl.desktop
    sudo rm /usr/share/applications/qv4l2.desktop
    sudo rm /usr/share/applications/qvidcap.desktop
    sudo reboot
}
main "$@"; exit
