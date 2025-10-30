hs.loadSpoon("Hammerflow")

-- Window cycling with Tab/Shift-Tab
local function focusNextWindow()
  local win = hs.window.focusedWindow()
  if not win then return end

  local currentSpace = hs.spaces.focusedSpace()
  local allWindows = hs.window.orderedWindows()

  local spaceWindows = {}
  for _, w in ipairs(allWindows) do
    local windowSpaces = hs.spaces.windowSpaces(w)
    if windowSpaces then
      for _, space in ipairs(windowSpaces) do
        if space == currentSpace and not w:isMinimized() then
          table.insert(spaceWindows, w)
          break
        end
      end
    end
  end

  if #spaceWindows <= 1 then return end

  local currentIndex = nil
  for i, w in ipairs(spaceWindows) do
    if w:id() == win:id() then
      currentIndex = i
      break
    end
  end

  if currentIndex then
    local nextIndex = (currentIndex % #spaceWindows) + 1
    spaceWindows[nextIndex]:focus()
  end
end

local function focusPreviousWindow()
  local win = hs.window.focusedWindow()
  if not win then return end

  local currentSpace = hs.spaces.focusedSpace()
  local allWindows = hs.window.orderedWindows()

  local spaceWindows = {}
  for _, w in ipairs(allWindows) do
    local windowSpaces = hs.spaces.windowSpaces(w)
    if windowSpaces then
      for _, space in ipairs(windowSpaces) do
        if space == currentSpace and not w:isMinimized() then
          table.insert(spaceWindows, w)
          break
        end
      end
    end
  end

  if #spaceWindows <= 1 then return end

  local currentIndex = nil
  for i, w in ipairs(spaceWindows) do
    if w:id() == win:id() then
      currentIndex = i
      break
    end
  end

  if currentIndex then
    local prevIndex = currentIndex - 1
    if prevIndex < 1 then
      prevIndex = #spaceWindows
    end
    spaceWindows[prevIndex]:focus()
  end
end

-- Bind Alt-Tab for next window and Alt-Shift-Tab for previous window
hs.hotkey.bind({"alt"}, "tab", focusNextWindow)
hs.hotkey.bind({"alt", "shift"}, "tab", focusPreviousWindow)

-- Screenshot keybindings
-- Print Screen for region selection (Cmd+Shift+4)
hs.hotkey.bind({}, "f13", function()
  hs.eventtap.keyStroke({"cmd", "shift"}, "4")
end)

-- Shift+Print Screen for window screenshot (Cmd+Shift+4 then Space)
hs.hotkey.bind({"shift"}, "f13", function()
  hs.eventtap.keyStroke({"cmd", "shift"}, "4")
  hs.timer.doAfter(0.1, function()
    hs.eventtap.keyStroke({}, "space")
  end)
end)

-- optionally set ui format (must be done before loading toml config)
-- Nord inspired theme
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
-- optionally respect auto_reload setting in the toml config.
if spoon.Hammerflow.auto_reload then
	hs.loadSpoon("ReloadConfiguration")
	-- set any paths for auto reload
	spoon.ReloadConfiguration.watch_paths = { hs.configDir, "~/dotfiles/hammerspoon/" }
	spoon.ReloadConfiguration:start()
end
