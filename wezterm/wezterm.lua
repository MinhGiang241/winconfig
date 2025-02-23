local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Đặt font chữ và color scheme nếu cần
config.font = wezterm.font("Iosevka Nerd Font")
config.font_size = 11.6
-- config.color_scheme = "TokyoNight"

-- Tránh giật khi kéo màn hình
-- config.window_decorations = 'RESIZE'

-- Hình nền
math.randomseed(os.time()) -- Khởi tạo bộ sinh số ngẫu nhiên (chỉ cần gọi 1 lần)
local random_number = math.random(1, 3)
local path = string.format("C:\\Users\\Admin\\.config\\wezterm\\bg\\%s.jpg", random_number)

config.background = {
	{
		source = {
			File = path,
		},
		opacity = 1,
		hsb = {
			brightness = 0.07, -- Giảm độ sáng
		},
	},
	-- {
	-- 	source = {
	-- 		Color = "#000000", -- Lớp màu đen phủ bên trên
	-- 	},
	-- 	opacity = 0.8,
	-- },
}

config.color_scheme = "MaterialDesignColors"
-- Đặt PowerShell làm shell mặc định
config.default_prog = { "C:/Program Files/WindowsApps/Microsoft.PowerShell_7.5.0.0_x64__8wekyb3d8bbwe/pwsh.exe" }

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
		key = "v",
		mods = "CTRL",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	-- Dán từ clipboard với Ctrl+V (nếu không bị ứng dụng khác chiếm dụng)
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

-- Cấu hình hành vi chuột
config.enable_wayland = false -- Nếu bạn đang sử dụng Wayland trên Linux, thử vô hiệu hóa nó
config.use_ime = true -- Nếu bạn sử dụng bộ gõ tiếng Việt

return config
