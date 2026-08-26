--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
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
    name  = "brave-opaque",
    match = { class = "brave-browser" },
    opacity = 100,
    border_size = 0,
})

hl.window_rule({
    name  = "obs-opaque",
    match = { class = "com.obsproject.Studio" },
    opacity = 100,
    border_size = 0,
})