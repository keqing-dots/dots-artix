-- VARIABLES

local V = {}

-- Palette
V.col = require("utils.colors")

-- Home
V.home = os.getenv("HOME")

-- Core
V.root = V.home .. "/keqing-dots"
V.wpm = 10

-- Applications
V.terminal = "kitty"
V.browser = "zen-browser"
V.browser_private = "zen-browser --private"
V.editor = "code"
V.filemanager = V.terminal .. " yazi"
V.screenshot = "bash -c 'mkdir -p $HOME/Pictures/screenshots/ && hyprshot -m region -o $HOME/Pictures/screenshots/'"

-- Hyprtile
V.tile = "hyprtile "
V.fw = V.tile .. "fw "
V.mw = V.tile .. "mw "
V.cw = V.tile .. "cw "
V.sw = V.tile .. "sw "

-- Keqing-shell IPC Calls
V.qs = "keqing-shell "
V.launcher = V.qs .. "launcher"
V.lock = V.qs .. "lock"
V.logout = V.qs .. "logout"
V.overview = V.qs .. "overview"
V.settings = V.qs .. "settings"

return V
