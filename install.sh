#!/usr/bin/env bash
main() {
    [[ $EUID -ne 0 ]] || { echo "Run this as a regular user, not as root."; exit 1; }
    [[ -f /etc/arch-release ]] || { echo "This is not Arch Linux."; exit 1; }

    if [[ ! -t 0 ]]; then { exec </dev/tty; } 2>/dev/null || true; fi

    cd "$HOME" || exit 1

    LOG="$HOME/hyprarch-install-errors.log"
    : > "$LOG"
    trap 'echo "[line $LINENO] $BASH_COMMAND" >> "$LOG"' ERR
    
    echo "Which graphics card do you have?"
    echo "  1) NVIDIA"
    echo "  2) AMD"
    while true; do
        read -r -p "Choose 1 or 2: " gpu
        case "$gpu" in
            1) GPU_PKGS=(libva-nvidia-driver nvidia-settings); break ;;
            2) GPU_PKGS=(); break ;;
            *) echo "Please enter 1 or 2." ;;
        esac
    done

    while true; do
        read -r -p "Is your root filesystem Btrfs? (y/n): " fs
        case "$fs" in
            y|Y) BTRFS=1; break ;;
            n|N) BTRFS=0; break ;;
            *) echo "Please enter y or n." ;;
        esac
    done

    sudo -v
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
    "${GPU_PKGS[@]}" \
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
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
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
    if [[ $BTRFS -eq 1 ]]; then
        sudo systemctl enable --now btrfs-scrub@-.timer
    fi
    sudo systemctl enable --now paccache.timer
    sudo systemctl enable --now reflector.timer
    echo "ntsync" | sudo tee /etc/modules-load.d/ntsync.conf
    xdg-mime default org.gnome.Nautilus.desktop inode/directory
    sudo reboot
}

main "$@"; exit
