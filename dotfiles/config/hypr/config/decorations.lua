hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
    general = {
        gaps_in          = 10,
        gaps_out         = 20,
        border_size      = 2,
        allow_tearing    = false,
        layout           = "dwindle",
    },
    dwindle = {
        preserve_split = false,
    },
    decoration = {
        rounding         = 20,
        rounding_power   = 2,
    shadow = {
        enabled = false,
        },
    blur = {
        enabled = true,
        size = 4,
        passes = 4,
        xray = false,
        new_optimizations = true
    },
    },
})
