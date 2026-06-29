local TITLE = "Clipboard"

local GET_TARGETS = ya.sync(function()
	local urls = {}

	if cx.yanked then
		for k, v in pairs(cx.yanked) do
			local u = type(v) == "userdata" and v or k
			urls[#urls + 1] = tostring(u)
		end
	end

	if #urls == 0 and cx.active.selected then
		for _, u in pairs(cx.active.selected) do
			urls[#urls + 1] = tostring(u)
		end
	end

	if #urls == 0 then
		local hovered = cx.active.current.hovered
		if hovered then
			urls[1] = tostring(hovered.url)
		end
	end

	return urls
end)

local HAS_YANKED = ya.sync(function()
	if cx.yanked then
		for _ in pairs(cx.yanked) do
			return true
		end
	end
	return false
end)

local CURRENT_CWD = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

local function notify(level, content, timeout)
	local entry = { title = TITLE, content = content, timeout = timeout or 2 }
	if level then
		entry.level = level
	end
	ya.notify(entry)
end

local function normalize_path(s)
	if s == nil then
		return nil
	end
	s = tostring(s):gsub("\r", ""):gsub("\n", "")
	s = s:gsub("^file://localhost", "")
	s = s:gsub("^file://", "")
	s = s:gsub("%%(%x%x)", function(h)
		return string.char(tonumber(h, 16))
	end)
	return s
end

local function basename(path)
	return (path or ""):gsub("/+$", ""):match("([^/]+)$")
end

local function state_path()
	local home = os.getenv("HOME") or "."
	local state_home = os.getenv("XDG_STATE_HOME") or (home .. "/.local/state")
	return state_home .. "/yazi/clipboard.yazi"
end

local function ensure_state_dir(path)
	local dir = path:match("^(.*)/[^/]+$")
	if not dir then
		return
	end
	pcall(function()
		fs.create("dir_all", Url(dir))
	end)
end

local function write_mode(mode)
	local path = state_path()
	ensure_state_dir(path)
	fs.write(Url(path), tostring(mode) .. "\n")
end

local function read_mode()
	local path = state_path()
	local out, _ = Command("cat"):arg(path):output()
	if not out or not out.status.success then
		return "copy"
	end
	local mode = (out.stdout or ""):match("^(%S+)")
	if mode ~= "cut" and mode ~= "copy" then
		return "copy"
	end
	return mode
end

local function clear_state()
	local path = state_path()
	Command("rm"):arg({ "-f", path }):status()
end

local function wl_copy(text)
	local status, err = Command("wl-copy"):arg({ "--type", "text/plain", "--", text }):status()
	if not status then
		return false, err
	end
	return status.success, nil
end

local function wl_paste()
	local output, err = Command("wl-paste"):arg({ "--no-newline" }):output()
	if not output then
		return nil, err
	end
	if not output.status.success then
		if (output.stdout == nil or output.stdout == "") and (output.stderr == nil or output.stderr == "") then
			return "", nil
		end
		return nil, output.stderr
	end
	return output.stdout, nil
end

local function copy_or_cut(action)
	local urls = GET_TARGETS()
	if not urls or #urls == 0 then
		notify("warn", "No files to " .. action)
		return
	end

	local norm = {}
	for _, u in ipairs(urls) do
		local p = normalize_path(u)
		if p and p ~= "" then
			norm[#norm + 1] = p
		end
	end
	if #norm == 0 then
		notify("warn", "No valid path")
		return
	end

	write_mode(action == "cut" and "cut" or "copy")
	local ok, err = wl_copy(table.concat(norm, "\n"))
	if not ok then
		notify("error", "wl-copy failed: " .. tostring(err), 3)
		return
	end

	notify(nil, (action == "cut") and "Path cut to clipboard" or "Path copied to clipboard")
end

local function paste()
	if HAS_YANKED() then
		ya.manager_emit("paste", {})
		return
	end

	local content, perr = wl_paste()
	content = content and content:gsub("\n+$", "") or ""
	if perr then
		notify("error", "wl-paste failed: " .. tostring(perr), 3)
		return
	end
	if content == "" then
		notify("warn", "Nothing to paste")
		return
	end

	local srcs = {}
	for line in (content .. "\n"):gmatch("(.-)\n") do
		local p = normalize_path(line)
		if p and p ~= "" then
			srcs[#srcs + 1] = p
		end
	end
	if #srcs == 0 then
		notify("warn", "Nothing to paste")
		return
	end

	local mode = read_mode()
	local dest = normalize_path(CURRENT_CWD())
	local cmd = (mode == "cut") and "mv" or "cp"

	local argv = {}
	if cmd == "cp" then
		argv[#argv + 1] = "-a"
	end
	argv[#argv + 1] = "--"
	for _, src in ipairs(srcs) do
		argv[#argv + 1] = src
	end
	argv[#argv + 1] = dest

	local out, err = Command(cmd):arg(argv):output()
	if not out then
		notify("error", cmd .. " failed: " .. tostring(err), 4)
		return
	end

	local success = out.status.success
	if not success and mode == "cut" then
		success = true
		for _, src in ipairs(srcs) do
			if fs.metadata(Url(src)) then
				success = false; break
			end
		end
	end

	if not success then
		local msg = (out.stderr and out.stderr:gsub("\n+$", "") or "unknown")
		notify("error", cmd .. " failed: " .. msg, 4)
		return
	end

	if mode == "cut" then
		local new_paths = {}
		local dest_dir = (dest or ""):gsub("/+$", "")
		for _, src in ipairs(srcs) do
			local name = basename(src)
			if name and name ~= "" then
				new_paths[#new_paths + 1] = dest_dir .. "/" .. name
			end
		end
		if #new_paths > 0 then
			wl_copy(table.concat(new_paths, "\n"))
			write_mode("cut")
		else
			clear_state()
		end
	end

	notify("info", (cmd == "mv") and "Moved" or "Copied")
end

local function setup(_, _)
end

local entry = function(_, job)
	local args = job and job.args or {}
	local action = args[1] or args.action or args.args or "copy"

	if action == "copy" or action == "cut" then
		copy_or_cut(action)
	elseif action == "paste" then
		paste()
	else
		notify("error", "Unknown action: " .. tostring(action), 2)
	end
end

return { entry = entry, setup = setup }
