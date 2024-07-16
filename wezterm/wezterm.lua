local wezterm = require 'wezterm';
local config = wezterm.config_builder()

-- Đặt font chữ và color scheme nếu cần
config.font = wezterm.font 'IosevkaTerm NF'
config.font_size = 11.6
-- config.color_scheme = "TokyoNight"

config.color_scheme = 'MaterialDesignColors'

-- Đặt PowerShell làm shell mặc định
config.default_prog = {"C:\\Program Files\\WindowsApps\\Microsoft.PowerShell_7.4.3.0_x64__8wekyb3d8bbwe\\pwsh.exe"}

config.window_background_opacity = 0.85
-- config.window_background_gradient = {
--   orientation = 'Vertical',
--     colors = {
--     '#142333',
--     '#273069',
--     '#6E1150',
--   },
--   interpolation = 'Linear',
--   blend = 'Rgb',
-- }

-- Thiết lập phím tắt cho việc dán
config.keys = {
  -- Dán từ clipboard với Ctrl+Shift+V
  {
    key = 'v',
    mods = 'CTRL',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  -- Dán từ clipboard với Ctrl+V (nếu không bị ứng dụng khác chiếm dụng)
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- Cấu hình hành vi chuột
config.enable_wayland = false -- Nếu bạn đang sử dụng Wayland trên Linux, thử vô hiệu hóa nó
config.use_ime = true -- Nếu bạn sử dụng bộ gõ tiếng Việt

return config
