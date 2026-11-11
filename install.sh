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
            1) GPU_PKGS=(libva-nvidia-driver nvidia-settings); NVIDIA=1; break ;;
            2) GPU_PKGS=(); NVIDIA=0; break ;;
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
    while true; do sudo -n true; sleep 60; done 2>/dev/null &
    SUDO_KEEPALIVE=$!
    trap 'kill $SUDO_KEEPALIVE 2>/dev/null' EXIT
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
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cp -a ~/HyprArch/config/. ~/.config/
    if [[ $NVIDIA -eq 1 ]]; then
        sed -i 's/^# export \(LIBVA_DRIVER_NAME\|__GL_GSYNC_ALLOWED\)=/export \1=/' ~/.config/uwsm/env
    fi
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
    for p in quiet fbcon=vc:2-6; do grep -qw -- "$p" /etc/kernel/cmdline || sudo sed -i "1 s|\$| $p|" /etc/kernel/cmdline; done
    sudo sed -i 's/^HOOKS=.*/HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
    sudo reboot
}

main "$@"; exit
