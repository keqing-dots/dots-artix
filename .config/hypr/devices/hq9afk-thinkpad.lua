local V, F = require("utils.variables"), require("utils.functions")

F.setup_displays({
	{ "eDP-1", "1920x1080@60", "0x0" },
	{ "HDMI-A-2", "1920x1080@60", "1920x0" },
}, V.wpm)

