local wezterm = require 'wezterm'

local config = wezterm.config_builder()
  config.color_scheme = 'Solarized (dark) (terminal.sexy)'
  config.font = wezterm.font {
    family = 'Monaco',
  }
  config.font_rules = {
    {
      intensity = 'Bold',
      font = wezterm.font {
        family = 'Monaco',
        weight = 'Book',
        style = 'Italic'
      },
    }
  }
  config.font_size = 10.2
return config
