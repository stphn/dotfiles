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
-- │                   🧱 Grid Masonry Layout                    │
-- └─────────────────────────────────────────────────────────────┘
-- Auto-tiling state
local autoTilingEnabled = true
local debounceTimer = nil
local lastWindowCount = 0

local function arrangeWindowsInGrid(showNotification)
	if showNotification == nil then showNotification = true end

	local windows = hs.window.visibleWindows()
	if #windows == 0 then
		return
	end

	local screen = hs.screen.mainScreen()
	local max = screen:frame()
	local gap = 10

	-- Filter out system windows and get actual app windows
	local appWindows = {}
	for _, win in ipairs(windows) do
		if win:isStandard() and win:application():name() ~= "Hammerspoon"
		   and not win:isMinimized() then
			table.insert(appWindows, win)
		end
	end

	local numWindows = #appWindows
	if numWindows == 0 then
		return
	end

	-- Don't rearrange if window count hasn't changed (prevents loops)
	if not showNotification and numWindows == lastWindowCount then
		return
	end
	lastWindowCount = numWindows

	-- Calculate optimal grid dimensions (masonry-style)
	local cols = math.ceil(math.sqrt(numWindows))
	local rows = math.ceil(numWindows / cols)

	-- Calculate window dimensions
	local winWidth = (max.w - (gap * (cols + 1))) / cols
	local winHeight = (max.h - (gap * (rows + 1))) / rows

	-- Arrange windows in grid with masonry layout
	for i, win in ipairs(appWindows) do
		local col = ((i - 1) % cols)
		local row = math.floor((i - 1) / cols)

		-- Add some variation in height for masonry effect
		local heightVariation = (i % 3 - 1) * 40 -- Vary by -40, 0, +40 pixels
		local adjustedHeight = winHeight + heightVariation

		-- Ensure window doesn't go out of bounds
		if row * (winHeight + gap) + adjustedHeight + gap > max.h then
			adjustedHeight = winHeight
		end

		local frame = {
			x = max.x + gap + col * (winWidth + gap),
			y = max.y + gap + row * (winHeight + gap),
			w = winWidth,
			h = adjustedHeight,
		}

		smoothResize(win, frame)
	end

	-- Show notification only when manually triggered
	if showNotification then
		hs.notify
			.new({
				title = "🧱 Grid Masonry",
				informativeText = string.format("Arranged %d windows in %dx%d grid", numWindows, cols, rows),
				withdrawAfter = 2,
			})
			:send()
	end
end

-- Debounced auto-arrangement function
local function scheduleAutoArrange()
	if not autoTilingEnabled then
		return
	end

	-- Cancel previous timer
	if debounceTimer then
		debounceTimer:stop()
	end

	-- Schedule new arrangement after a short delay
	debounceTimer = hs.timer.doAfter(0.5, function()
		arrangeWindowsInGrid(false)
	end)
end

-- Toggle auto-tiling
local function toggleAutoTiling()
	autoTilingEnabled = not autoTilingEnabled
	local status = autoTilingEnabled and "enabled" or "disabled"
	hs.notify
		.new({
			title = "🤖 Auto Grid Masonry",
			informativeText = "Auto-tiling " .. status,
			withdrawAfter = 2,
		})
		:send()
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                🚀 Hyprland-Style Tiling Setup              │
-- └─────────────────────────────────────────────────────────────┘
local HyprlandTiling = require("hyprland-tiling")
local WorkspaceIntegration = require("workspace-integration")
local DynamicGaps = require("dynamic-gaps")

-- Initialize all systems
WorkspaceIntegration.initializeMonitoring()
DynamicGaps.initialize()

-- Enhanced window focus watcher with Hyprland-style animations + auto-tiling
local windowFilter = hs.window.filter.new()

windowFilter:subscribe(hs.window.filter.windowFocused, function(window)
	if window then
		-- Create focus highlight with enhanced animation
		local frame = window:frame()
		local highlight = hs.canvas.new(frame)

		-- Dual-layer border effect (inner + outer glow)
		highlight:appendElements({
			{
				type = "rectangle",
				action = "stroke",
				strokeColor = { hex = "#A3BE8C", alpha = 0.4 },
				strokeWidth = 6,
				roundedRectRadii = { xRadius = 12, yRadius = 12 },
			},
			{
				type = "rectangle",
				action = "stroke",
				strokeColor = { hex = "#88C0D0", alpha = 0.8 },
				strokeWidth = 3,
				roundedRectRadii = { xRadius = 10, yRadius = 10 },
			},
		})

		-- Smooth fade-in
		highlight:show(0.15)

		-- Pulse effect
		hs.timer.doAfter(0.2, function()
			highlight:hide(0.1)
			hs.timer.doAfter(0.1, function()
				highlight:show(0.1)
				hs.timer.doAfter(0.6, function()
					highlight:hide(0.2)
					hs.timer.doAfter(0.2, function()
						highlight:delete()
					end)
				end)
			end)
		end)
	end
end)

-- Auto-tiling window event watchers
windowFilter:subscribe(hs.window.filter.windowCreated, scheduleAutoArrange)
windowFilter:subscribe(hs.window.filter.windowDestroyed, scheduleAutoArrange)
windowFilter:subscribe(hs.window.filter.windowMinimized, scheduleAutoArrange)
windowFilter:subscribe(hs.window.filter.windowUnminimized, scheduleAutoArrange)
windowFilter:subscribe(hs.window.filter.windowHidden, scheduleAutoArrange)
windowFilter:subscribe(hs.window.filter.windowUnhidden, scheduleAutoArrange)

-- ┌─────────────────────────────────────────────────────────────┐
-- │                ⌨️  Enhanced Keybindings                     │
-- └─────────────────────────────────────────────────────────────┘
-- Window tiling (using cmd+ctrl to avoid Aerospace conflicts)
hs.hotkey.bind({ "cmd", "ctrl" }, "H", function()
	HyprlandTiling.tileWindow("left")
end)
hs.hotkey.bind({ "cmd", "ctrl" }, "L", function()
	HyprlandTiling.tileWindow("right")
end)
hs.hotkey.bind({ "cmd", "ctrl" }, "K", function()
	HyprlandTiling.tileWindow("top")
end)
hs.hotkey.bind({ "cmd", "ctrl" }, "J", function()
	HyprlandTiling.tileWindow("bottom")
end)
hs.hotkey.bind({ "cmd", "ctrl" }, "M", function()
	HyprlandTiling.tileWindow("maximize")
end)
hs.hotkey.bind({ "cmd", "ctrl" }, "C", function()
	HyprlandTiling.tileWindow("center")
end)

-- Thirds tiling
hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "H", function()
	HyprlandTiling.tileWindow("thirds-left")
end)
hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "L", function()
	HyprlandTiling.tileWindow("thirds-right")
end)
hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "K", function()
	HyprlandTiling.tileWindow("thirds-center")
end)

-- Window resizing
hs.hotkey.bind({ "cmd", "ctrl" }, "=", function()
	HyprlandTiling.resizeWindow("wider", 60)
end)
hs.hotkey.bind({ "cmd", "ctrl" }, "-", function()
	HyprlandTiling.resizeWindow("narrower", 60)
end)
hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "=", function()
	HyprlandTiling.resizeWindow("taller", 60)
end)
hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "-", function()
	HyprlandTiling.resizeWindow("shorter", 60)
end)

-- Enhanced workspace switching (cmd+shift for quick access)
local workspaces = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "F", "G", "M", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }

for _, ws in ipairs(workspaces) do
	if ws:match("%d") then
		-- Numbered workspaces
		hs.hotkey.bind({ "cmd", "shift" }, ws, function()
			WorkspaceIntegration.switchToWorkspace(ws)
		end)
		hs.hotkey.bind({ "cmd", "shift", "ctrl" }, ws, function()
			WorkspaceIntegration.moveWindowAndFollow(ws)
		end)
	else
		-- Letter workspaces
		hs.hotkey.bind({ "cmd", "shift" }, ws:lower(), function()
			WorkspaceIntegration.switchToWorkspace(ws)
		end)
		hs.hotkey.bind({ "cmd", "shift", "ctrl" }, ws:lower(), function()
			WorkspaceIntegration.moveWindowAndFollow(ws)
		end)
	end
end

-- Workspace utilities (changed from Tab to Escape to avoid macOS conflict)
hs.hotkey.bind({ "cmd", "shift" }, "Escape", function()
	WorkspaceIntegration.togglePreviousWorkspace()
end)
hs.hotkey.bind({ "cmd", "shift" }, "Space", function()
	WorkspaceIntegration.showWorkspaceOverview()
end)
hs.hotkey.bind({ "cmd", "shift" }, "Right", function()
	WorkspaceIntegration.cycleWorkspaces("next")
end)
hs.hotkey.bind({ "cmd", "shift" }, "Left", function()
	WorkspaceIntegration.cycleWorkspaces("prev")
end)

-- Layout controls
hs.hotkey.bind({ "cmd", "ctrl" }, "F", function()
	WorkspaceIntegration.toggleFloatingMode()
end)
hs.hotkey.bind({ "cmd", "ctrl" }, "R", function()
	WorkspaceIntegration.resetWorkspaceLayout()
end)
hs.hotkey.bind({ "cmd", "ctrl" }, "T", function()
	WorkspaceIntegration.toggleWorkspaceLayout()
end)

-- Grid masonry layout
hs.hotkey.bind({ "cmd", "ctrl" }, "G", function()
	arrangeWindowsInGrid(true)
end)

-- Toggle auto-tiling
hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "G", function()
	toggleAutoTiling()
end)

-- Window cycling
hs.hotkey.bind({ "cmd", "ctrl" }, "N", function()
	HyprlandTiling.cycleWindows("next")
end)
hs.hotkey.bind({ "cmd", "ctrl" }, "P", function()
	HyprlandTiling.cycleWindows("prev")
end)

-- DISABLED: Dynamic gap controls (disable during debugging)
-- hs.hotkey.bind({ "cmd", "alt" }, "=", function()
-- 	DynamicGaps.adjustGaps("increase_all", 4)
-- end)
-- hs.hotkey.bind({ "cmd", "alt" }, "-", function()
-- 	DynamicGaps.adjustGaps("decrease_all", 4)
-- end)
-- hs.hotkey.bind({ "cmd", "alt" }, "0", function()
-- 	DynamicGaps.setGapPreset("minimal")
-- end)
-- hs.hotkey.bind({ "cmd", "alt" }, "1", function()
-- 	DynamicGaps.setGapPreset("compact")
-- end)
-- hs.hotkey.bind({ "cmd", "alt" }, "2", function()
-- 	DynamicGaps.setGapPreset("comfortable")
-- end)
-- hs.hotkey.bind({ "cmd", "alt" }, "3", function()
-- 	DynamicGaps.setGapPreset("spacious")
-- end)
-- hs.hotkey.bind({ "cmd", "alt" }, "4", function()
-- 	DynamicGaps.setGapPreset("presentation")
-- end)

-- Gap preset cycling
-- hs.hotkey.bind({ "cmd", "alt" }, "Right", function()
-- 	DynamicGaps.cycleGapPresets("next")
-- end)
-- hs.hotkey.bind({ "cmd", "alt" }, "Left", function()
-- 	DynamicGaps.cycleGapPresets("prev")
-- end)

-- Smart gap adjustment
-- hs.hotkey.bind({ "cmd", "alt" }, "S", function()
-- 	DynamicGaps.smartGapAdjustment()
-- end)
-- hs.hotkey.bind({ "cmd", "alt" }, "I", function()
-- 	DynamicGaps.showGapStatus()
-- end)

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   🔔 Enhanced Startup                       │
-- └─────────────────────────────────────────────────────────────┘
hs.notify
	.new({
		title = "🚀 Hyprland-Style Tiling",
		informativeText = "Enhanced workspace management loaded ✨",
		withdrawAfter = 3,
	})
	:send()
