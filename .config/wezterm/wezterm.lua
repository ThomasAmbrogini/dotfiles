local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = ""

config.font_size = 13
config.font = wezterm.font(
    {
        family = "JuliaMono Nerd Font Mono",
        weight="Regular",
        stretch="Normal",
        style="Normal",
        -- Disable ligatures
        harfbuzz_features = {"calt=0", "clig=0", "liga=0"}
    }
)

config.colors = {
    foreground = "#a8a8a8",
    background = "#141012",

    ansi = {
        "#000000", -- black
        "#a80000", -- red
        "#00a800", -- green
        "#a85400", -- yellow
        "#0000a8", -- blue
        "#a800a8", -- magenta
        "#00a8a8", -- cyan
        "#a8a8a8", -- white
    },
    brights = {
        "#545454", -- bright black
        "#fc5454", -- bright red
        "#54fc54", -- bright green
        "#fcfc54", -- bright yellow
        "#5454fc", -- bright blue
        "#fc54fc", -- bright magenta
        "#54fcfc", -- bright cyan
        "#fcfcfc", -- bright white
    },

    cursor_bg = "#a8a8a8",
    cursor_border = "#a8a8a8"
}

return config

