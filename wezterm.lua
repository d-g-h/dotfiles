local wezterm = require 'wezterm'

local config = {}

config.color_scheme = 'Solarized (dark) (terminal.sexy)'
config.font = wezterm.font { family = 'Monaco' }
config.freetype_load_target = 'Mono'
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.colors = {
  foreground = '#E6E0D5',
}

local RETINA = {
  font_size = 20.0,
  cell_width = 0.775,
  font = wezterm.font { family = 'Monaco', weight = 'ExtraLight' },
  freetype_load_flags = nil,
  freetype_load_target = 'Light',
  font_rules = {
    {
      intensity = 'Bold',
      font = wezterm.font {
        family = 'Monaco',
        weight = 'ExtraLight',
        style = 'Italic',
      },
    },
  },
}

local EXTERNAL = {
  font_size = 13.0,
  cell_width = nil,
  font = nil,
  freetype_load_flags = 'NO_HINTING|MONOCHROME',
  freetype_load_target = 'Mono',
  font_rules = {
    {
      intensity = 'Bold',
      font = wezterm.font {
        family = 'Monaco',
        weight = 'Thin',
        style = 'Italic',
      },
    },
  },
}

local function apply_profile(window, profile_name)
  local profile = profile_name == 'RETINA' and RETINA or EXTERNAL
  local overrides = window:get_config_overrides() or {}

  overrides.font_size = profile.font_size
  overrides.cell_width = profile.cell_width
  overrides.font = profile.font
  overrides.freetype_load_flags = profile.freetype_load_flags
  overrides.freetype_load_target = profile.freetype_load_target
  overrides.font_rules = profile.font_rules

  window:set_config_overrides(overrides)
  window:set_right_status(profile_name)
  window:toast_notification('WezTerm', 'Profile: ' .. profile_name, nil, 1500)
end

local function toggle_profile(window)
  local overrides = window:get_config_overrides() or {}
  local current = 'EXTERNAL'
  if overrides.font_size == RETINA.font_size and overrides.freetype_load_target == RETINA.freetype_load_target then
    current = 'RETINA'
  end
  local next_profile = current == 'RETINA' and 'EXTERNAL' or 'RETINA'
  apply_profile(window, next_profile)
end

config.keys = {
  {
    key = 't',
    mods = 'CMD|CTRL',
    action = wezterm.action_callback(function(window, pane)
      toggle_profile(window)
    end),
  },
  {
    key = 'phys:T',
    mods = 'CMD|CTRL',
    action = wezterm.action_callback(function(window, pane)
      toggle_profile(window)
    end),
  },
  {
    key = 'r',
    mods = 'CMD|CTRL',
    action = wezterm.action_callback(function(window, pane)
      apply_profile(window, 'RETINA')
    end),
  },
  {
    key = 'phys:R',
    mods = 'CMD|CTRL',
    action = wezterm.action_callback(function(window, pane)
      apply_profile(window, 'RETINA')
    end),
  },
  {
    key = 'r',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      apply_profile(window, 'RETINA')
    end),
  },
  {
    key = 'phys:R',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      apply_profile(window, 'RETINA')
    end),
  },
  {
    key = 'e',
    mods = 'CMD|CTRL',
    action = wezterm.action_callback(function(window, pane)
      apply_profile(window, 'EXTERNAL')
    end),
  },
  {
    key = 'phys:E',
    mods = 'CMD|CTRL',
    action = wezterm.action_callback(function(window, pane)
      apply_profile(window, 'EXTERNAL')
    end),
  },
  {
    key = 'e',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      apply_profile(window, 'EXTERNAL')
    end),
  },
  {
    key = 'phys:E',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      apply_profile(window, 'EXTERNAL')
    end),
  },
}

return config
