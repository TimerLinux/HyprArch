hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
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
            enabled = true,
            range = 20,
            render_power = 4,
            scale = 1,
            color = "rgba(000000b0)",
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
