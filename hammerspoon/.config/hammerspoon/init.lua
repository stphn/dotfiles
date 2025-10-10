-- ╭─────────────────────────────────────────────────────────────╮
-- │              🔨 Hammerspoon Configuration                   │
-- │          Hammerflow + Smooth Animations                     │
-- ╰─────────────────────────────────────────────────────────────╯

-- ┌─────────────────────────────────────────────────────────────┐
-- │                    ⚡ Animation Settings                     │
-- └─────────────────────────────────────────────────────────────┘
-- Smooth window animations (Omarchy/Hyprland style)
hs.window.animationDuration = 0.2

-- ┌─────────────────────────────────────────────────────────────┐
-- │                  🎨 Hammerflow Configuration                │
-- └─────────────────────────────────────────────────────────────┘
hs.loadSpoon("Hammerflow")

-- Nord-inspired theme with smooth animations
spoon.Hammerflow.registerFormat({
	atScreenEdge = 2,
	fillColor = { alpha = 0.875, hex = "2D3441" },
	padding = 18,
	radius = 12,
	strokeColor = { alpha = 0.875, hex = "9CBF87" },
	textColor = { alpha = 1, hex = "77C2D2" },
	textStyle = {
		paragraphStyle = { lineSpacing = 6 },
		shadow = { offset = { h = -1, w = 1 }, blurRadius = 10, color = { alpha = 0.50, white = 0 } },
	},
	strokeWidth = 6,
	textFont = "JetBrains Mono",
	textSize = 18,
})

spoon.Hammerflow.loadFirstValidTomlFile({
	"home.toml",
	"work.toml",
	"Spoons/Hammerflow.spoon/sample.toml",
})

-- Auto-reload configuration
if spoon.Hammerflow.auto_reload then
	hs.loadSpoon("ReloadConfiguration")
	spoon.ReloadConfiguration.watch_paths = { hs.configDir, "~/dotfiles/hammerspoon/" }
	spoon.ReloadConfiguration:start()
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │            🎯 Window Focus Highlight Animation              │
-- └─────────────────────────────────────────────────────────────┘
-- Flash focused window border (like Hyprland's border animation)
-- Uses Nord theme colors to match your existing setup

local function flashFocusedWindow()
	local focusedWin = hs.window.focusedWindow()
	if not focusedWin then
		return
	end

	local frame = focusedWin:frame()
	local highlight = hs.canvas.new(frame)

	-- Nord-inspired accent color (matches your theme)
	highlight:appendElements({
		type = "rectangle",
		action = "stroke",
		strokeColor = { hex = "9CBF87", alpha = 0.8 }, -- Nord green
		strokeWidth = 4,
		roundedRectRadii = { xRadius = 10, yRadius = 10 },
	})

	-- Smooth fade-in
	highlight:show(0.15)

	-- Smooth fade-out
	hs.timer.doAfter(0.15, function()
		highlight:hide(0.15)
		hs.timer.doAfter(0.2, function()
			highlight:delete()
		end)
	end)
end

-- Optional: Enable automatic window focus highlighting
-- Uncomment the lines below to flash border when focus changes
--
-- local windowFilter = hs.window.filter.new()
-- windowFilter:subscribe(hs.window.filter.windowFocused, function()
--     flashFocusedWindow()
-- end)

-- ┌─────────────────────────────────────────────────────────────┐
-- │                 🪟 Smooth Window Movements                  │
-- └─────────────────────────────────────────────────────────────┘
-- Helper function for animated window positioning

local function smoothResize(win, frame)
	win:setFrame(frame, hs.window.animationDuration)
	flashFocusedWindow()
end

-- Window positioning with gaps (Aerospace-style)
local function moveWindowToPosition(position)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local screen = win:screen()
	local max = screen:frame()
	local gap = 10 -- Matches Aerospace gap setting
	local frame = {}

	if position == "left" then
		frame = {
			x = max.x + gap,
			y = max.y + gap,
			w = (max.w / 2) - (gap * 1.5),
			h = max.h - (gap * 2),
		}
	elseif position == "right" then
		frame = {
			x = max.x + (max.w / 2) + (gap / 2),
			y = max.y + gap,
			w = (max.w / 2) - (gap * 1.5),
			h = max.h - (gap * 2),
		}
	elseif position == "top" then
		frame = {
			x = max.x + gap,
			y = max.y + gap,
			w = max.w - (gap * 2),
			h = (max.h / 2) - (gap * 1.5),
		}
	elseif position == "bottom" then
		frame = {
			x = max.x + gap,
			y = max.y + (max.h / 2) + (gap / 2),
			w = max.w - (gap * 2),
			h = (max.h / 2) - (gap * 1.5),
		}
	elseif position == "max" then
		frame = {
			x = max.x + gap,
			y = max.y + gap,
			w = max.w - (gap * 2),
			h = max.h - (gap * 2),
		}
	elseif position == "center" then
		frame = {
			x = max.x + (max.w * 0.15),
			y = max.y + (max.h * 0.15),
			w = max.w * 0.7,
			h = max.h * 0.7,
		}
	end

	smoothResize(win, frame)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │              ⌨️  Optional Window Management Keys            │
-- └─────────────────────────────────────────────────────────────┘
-- Uncomment if you want window positioning shortcuts
-- Using ctrl+cmd to avoid conflicts with Aerospace
--
-- hs.hotkey.bind({"ctrl", "cmd"}, "H", function() moveWindowToPosition("left") end)
-- hs.hotkey.bind({"ctrl", "cmd"}, "L", function() moveWindowToPosition("right") end)
-- hs.hotkey.bind({"ctrl", "cmd"}, "K", function() moveWindowToPosition("top") end)
-- hs.hotkey.bind({"ctrl", "cmd"}, "J", function() moveWindowToPosition("bottom") end)
-- hs.hotkey.bind({"ctrl", "cmd"}, "M", function() moveWindowToPosition("max") end)
-- hs.hotkey.bind({"ctrl", "cmd"}, "C", function() moveWindowToPosition("center") end)

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   🔔 Startup Notification                   │
-- └─────────────────────────────────────────────────────────────┘
hs.notify
	.new({
		title = "Hammerspoon",
		informativeText = "Configuration loaded ✨",
		withdrawAfter = 2,
	})
	:send()
