-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.font_size = 18
-- Cursor styles
-- config.default_cursor_style = "BlinkingBlock" -- solid block that blinks
-- config.default_cursor_style = "SteadyBlock" -- solid block, no blink
-- config.default_cursor_style = "BlinkingBar"  -- thin bar, blinks
config.default_cursor_style = "SteadyBar" -- thin bar, no blink
-- config.default_cursor_style = "BlinkingUnderline"
-- config.default_cursor_style = "SteadyUnderline"

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

-- 🎨 Theme
config.color_scheme = "Nord (Gogh)"

-- and finally, return the configuration to wezterm
config.keys = {
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b\r"}},
}

return config
