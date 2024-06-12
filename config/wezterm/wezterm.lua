local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.front_end = 'WebGpu'
config.use_ime = true
config.enable_tab_bar = false
config.window_close_confirmation = 'NeverPrompt'

config.font = wezterm.font_with_fallback {
    { family = 'VictorMono Nerd Font', weight = 'Medium' },
    { family = 'Noto Sans Mono CJK SC', weight = 'Medium' },
    'Noto Color Emoji',
}
config.font_rules = {
    {
        intensity = 'Normal',
        italic = true,
        font = wezterm.font_with_fallback { -- sdaf
            { family = 'VictorMono Nerd Font', weight = 'Medium', style = 'Oblique' },
            { family = 'Noto Sans Mono CJK SC', weight = 'Medium' },
            'Noto Color Emoji',
        },
    },
    {
        intensity = 'Bold',
        italic = true,
        font = wezterm.font_with_fallback {
            { family = 'VictorMono Nerd Font', weight = 'Medium', style = 'Oblique' },
            { family = 'Noto Sans Mono CJK SC', weight = 'Medium' },
            'Noto Color Emoji',
        },
    },
}
config.font_size = 11
config.line_height = 0.9
config.window_padding = {
    left = 5,
    right = 0,
    top = 5,
    bottom = 0,
}


config.background = {
    {
        source = { Color = '#212121' },
        width = '100%',
        height = '100%',
        opacity = 0.85,
    }
}
local scheme = wezterm.get_builtin_color_schemes()['One Half Black (Gogh)']
scheme.ansi[1] = '#555555'
scheme.brights[1] = '#555555'
config.color_schemes = { ['One Half Black (Gogh)'] = scheme }
config.color_scheme = 'One Half Black (Gogh)'

return config
