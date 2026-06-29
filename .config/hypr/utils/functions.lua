-- FUNCTIONS

local F = {}

function F.assign_workspaces(monitor_names, wpm)
	for mon_idx, monitor_name in ipairs(monitor_names) do
		local base = (mon_idx - 1) * wpm
		for i = 1, wpm do
			hl.workspace_rule({
				workspace = base + i,
				monitor = monitor_name,
				persistent = true,
			})
		end
	end
end

function F.auto_start(cmds)
	return hl.on("hyprland.start", function()
		for _, cmd in ipairs(cmds) do
			hl.exec_cmd(cmd)
		end
	end)
end

function F.exec(cmd)
	return hl.dsp.exec_cmd(cmd)
end

function F.load(modules)
	for _, v in ipairs(modules) do
		require("modules." .. v)
	end
end

function F.load_device()
	local f = io.open("/etc/hostname")
	local device = f and f:read("*l")
	if f then f:close() end
	return require("devices." .. (device or "hq9afk"))
end

function F.map_anim(anims)
	for _, anim in ipairs(anims) do
		if anim.enabled == nil then
			anim.enabled = true
		end
		hl.animation(anim)
	end
end
function F.map_curves(curves)
	for name, points in pairs(curves) do
		hl.curve(name, { type = "bezier", points = points })
	end
end

function F.map_env(env)
	for k, v in pairs(env) do
		hl.env(k, v)
	end
end

function F.map_keybinds(opts, keys)
	for k, v in pairs(keys) do
		hl.bind(k, v, opts)
	end
end

function F.set_monitor(mon, mode, pos, scale, rot)
	hl.monitor({
		output = mon or "",
		mode = mode or "preferred",
		position = pos or "0x0",
		scale = scale or 1,
		transform = rot or 0,
	})
end

function F.setup_displays(monitors, wpm)
	local monitor_names = {}

	for _, monitor in ipairs(monitors) do
		table.insert(monitor_names, monitor[1])
		F.set_monitor(monitor[1], monitor[2], monitor[3], monitor[4], monitor[5])
	end

	F.assign_workspaces(monitor_names, wpm)
end

return F
