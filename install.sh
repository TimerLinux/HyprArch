#!/usr/bin/env bash
# HyprArch – instaluje pakiety i dotfiles na świeżym Archu (kroki z pliku "Arch Packages").
#
# Uruchom jako zwykły użytkownik (nie root):
#   bash <(curl -fsSL https://raw.githubusercontent.com/TimerLinux/HyprArch/main/install.sh)

set -euo pipefail

REPO="https://github.com/TimerLinux/HyprArch.git"
DEST="$HOME/.local/share/hyprarch"                       # kopia repo z dotfiles
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"   # tu trafiają nadpisane pliki

info() { printf '\e[1;32m==>\e[0m \e[1m%s\e[0m\n' "$*"; }
warn() { printf '\e[1;33m==> UWAGA:\e[0m %s\n' "$*"; }

# Kopiuje pliki z $1 do $2; inne, już istniejące pliki przenosi do kopii zapasowej
copy_tree() {
    local src=$1 dst=$2 f rel target
    while IFS= read -r -d '' f; do
        rel=${f#"$src"/}
        target="$dst/$rel"
        if { [[ -e $target ]] || [[ -L $target ]]; } && ! cmp -s "$f" "$target"; then
            mkdir -p "$(dirname "$BACKUP/${target#"$HOME"/}")"
            mv "$target" "$BACKUP/${target#"$HOME"/}"
        fi
        mkdir -p "$(dirname "$target")"
        cp "$f" "$target"
    done < <(find "$src" -type f -print0)
}

main() {
    [[ $EUID -ne 0 ]] || { echo "Uruchom jako zwykły użytkownik, nie jako root."; exit 1; }
    [[ -f /etc/arch-release ]] || { echo "To nie jest Arch Linux."; exit 1; }

    # Przy "curl ... | bash" wejściem jest potok, więc pytania pacmana/paru czytamy z terminala
    if [[ ! -t 0 ]]; then { exec </dev/tty; } 2>/dev/null || true; fi

    # ---------- AUR HELPER ----------
    info "AUR HELPER"
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si

    # ---------- CORE ----------
    info "CORE"
    paru -S \
    hyprland \
    kitty \
    nautilus \
    zen-browser-bin \
    xdg-desktop-portal-hyprland \
    power-profiles-daemon \
    fastfetch \
    btop \
    fish \
    adw-gtk-theme \
    nwg-look \
    qt6ct \
    qt6-wayland \
    qt5-wayland \
    pacman-contrib \
    ly \
    uwsm \
    speech-dispatcher \
    python-pillow \
    icoextract \
    bibata-cursor-theme-bin \
    newaita-reborn-icons-git \
    noctalia

    # ---------- APPS ----------
    info "APPS"
    paru -S \
    gnome-text-editor  \
    gnome-disk-utility \
    baobab \
    loupe \
    gnome-calculator \
    vlc

    # ---------- CONFIG ----------
    info "CONFIG"
    xdg-user-dirs-update
    sudo systemctl disable getty@tty1.service
    sudo systemctl enable ly@tty1.service
    chsh -s /usr/bin/fish
    sudo usermod -c "Arch Linux" $USER
    echo "ntsync" | sudo tee /etc/modules-load.d/ntsync.conf
    sudo systemctl enable --now paccache.timer
    xdg-mime default org.gnome.Nautilus.desktop inode/directory

    # ---------- DOTFILES ----------
    info "DOTFILES"
    if [[ -d $DEST/.git ]]; then
        git -C "$DEST" pull --ff-only
    else
        mkdir -p "$(dirname "$DEST")"
        git clone --depth 1 "$REPO" "$DEST"
    fi
    copy_tree "$DEST/dotfiles/config" "$HOME/.config"
    copy_tree "$DEST/dotfiles/local"  "$HOME/.local"
    chmod +x "$HOME"/.config/hypr/scripts/*          # w repo theme-reload nie ma prawa wykonywania
    [[ -d $BACKUP ]] && warn "Poprzednie wersje nadpisanych plików są w $BACKUP"

    info "Gotowe! Zrestartuj komputer: sudo reboot"
}

# Całość jest w funkcji, więc nic się nie wykona, jeśli pobieranie urwie się w połowie
main "$@"; exit
