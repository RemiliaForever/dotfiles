{ pkgs, wezterm, ... }:

{
  programs.wezterm = {
    enable = true;
    package = wezterm.packages.x86_64-linux.default;
    enableBashIntegration = true;
    extraConfig = ''
      local config = wezterm.config_builder()

      config.front_end = 'OpenGL'
      config.use_ime = true
      config.enable_tab_bar = false
      config.window_close_confirmation = 'NeverPrompt'

      config.font = wezterm.font_with_fallback {
          { family = 'VictorMono Nerd Font', weight = 'Regular' },
          { family = 'Noto Sans Mono CJK SC', weight = 'Regular' },
          'Noto Color Emoji',
      }

      config.font_size = 11
      config.line_height = 0.9
      config.window_padding = {
          left = 5,
          right = 5,
          top = 5,
          bottom = 5,
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


      -- Change mouse scroll amount
      config.mouse_bindings = {
          {
              event = { Down = { streak = 1, button = { WheelUp = 1 } } },
              mods = 'NONE',
              action = wezterm.action.ScrollByLine(-3),
          },
          {
              event = { Down = { streak = 1, button = { WheelDown = 1 } } },
              mods = 'NONE',
              action = wezterm.action.ScrollByLine(3),
          },
      }

      return config
    '';
  };
}
