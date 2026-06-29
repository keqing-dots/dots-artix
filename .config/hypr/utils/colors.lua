-- COLORS

local path = os.getenv("HOME") .. "/.config/keqing-shell/colors.json"
local f = io.open(path, "r")
local _c = {}

if f then
	local content = f:read("*a")
	f:close()
	local current = content:match('"current"%s*:%s*(%b{})')
	if current then
		for key, value in current:gmatch('"(%w+)"%s*:%s*"(#[%x]+)"') do
			_c[key] = value
		end
	end
end

return {
	-- dark range (color0–7)
	base = _c.base or "#0A0614",
	surface = _c.surface or "#110B22",
	surfaceAlt = _c.surfaceAlt or "#1A1238",
	accentAltContainer = _c.accentAltContainer or "#2B1D5C",
	accentContainer = _c.accentContainer or "#3D1878",
	lavender = _c.lavender or "#5E50A0",
	textDim = _c.lavender or "#5E50A0",
	rose = _c.rose or "#7A4A58",
	textMuted = _c.textMuted or "#A896C8",
	-- bright range (color8–15)
	fieldBg = _c.fieldBg or "#0F1535",
	overlay = _c.overlay or "#1C1848",
	overlayAlt = _c.overlayAlt or "#252060",
	accentAlt = _c.accentAlt or "#C8942A",
	accentDim = _c.accentDim or "#5535B8",
	accent = _c.accent or "#7B2FE8",
	lavenderLight = _c.lavenderLight or "#C87EFF",
	text = _c.text or "#F0ECF8",
}
