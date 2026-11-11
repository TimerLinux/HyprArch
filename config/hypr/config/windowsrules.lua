hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name             = "firefox-fullscreen",
    match            = { class = "^firefox$", float = false },
    fullscreen_state = "0 2",
})

hl.window_rule({
    name  = "calculator-float",
    match = { class = "^org\\.gnome\\.Calculator$" },
    float = true,
    center = true,
})
