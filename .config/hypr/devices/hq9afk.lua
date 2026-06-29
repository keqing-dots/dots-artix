local V, F = require("utils.variables"), require("utils.functions")

F.setup_displays({
	{ "DP-3", "5120x1440@120", "0x0" },
	{ "DP-2", "3440x1440@120", "840x-1440" },
	{ "HEADLESS", "1920x1080", "1600x1440" },
	{ "DP-1", "2560x688@60", "5120x0", nil, 3 },
}, V.wpm)

hl.layout.register("columns", {
	recalculate = function(ctx)
		local n = #ctx.targets
		if n == 0 then
			return
		end

		for i, target in ipairs(ctx.targets) do
			target:place(ctx:column(i, n))
		end
	end,
})

hl.config({
	general = {
		layout = "lua:columns",
	},

	cursor = {
		default_monitor = "DP-3",
	},
})

F.auto_start({
	"sunshine",
})
