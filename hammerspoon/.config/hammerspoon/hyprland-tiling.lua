-- ╭─────────────────────────────────────────────────────────────╮
-- │                  🪟 Hyprland-Style Tiling Module            │
-- │           Enhanced Window Management with Animations        │
-- ╰─────────────────────────────────────────────────────────────╯

local HyprlandTiling = {}

-- ┌─────────────────────────────────────────────────────────────┐
-- │                    📊 Window Tracking                       │
-- └─────────────────────────────────────────────────────────────┘
local tiledWindows = {}
local windowPositions = {}

-- ┌─────────────────────────────────────────────────────────────┐
-- │                      🎨 Animation Settings                  │
-- └─────────────────────────────────────────────────────────────┘
local config = {
    animation_duration = 0.25,  -- Smooth like Hyprland
    border_width = 3,
    border_radius = 8,
    gaps = {
        inner = 8,
        outer = 12
    },
    -- Nord-inspired colors
    colors = {
        active_border = { hex = "#88C0D0", alpha = 0.9 },   -- Nord frost blue
        inactive_border = { hex = "#4C566A", alpha = 0.6 }, -- Nord polar night
        focus_flash = { hex = "#A3BE8C", alpha = 0.8 },     -- Nord aurora green
        background = { hex = "#2E3440", alpha = 0.1 }       -- Subtle background
    }
}

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   📐 Geometry Calculations                  │
-- └─────────────────────────────────────────────────────────────┘
local function getScreenGeometry(screen)
    -- Use the visible frame which excludes menu bar and dock
    local frame = screen:fullFrame()
    local visibleFrame = screen:frame()

    return {
        x = visibleFrame.x + config.gaps.outer,
        y = visibleFrame.y + config.gaps.outer,
        w = visibleFrame.w - (config.gaps.outer * 2),
        h = visibleFrame.h - (config.gaps.outer * 2)
    }
end

local function getWindowsInPosition(screen, position)
    local windows = {}
    for winId, pos in pairs(windowPositions) do
        if pos == position then
            local win = hs.window.get(winId)
            if win and win:screen():id() == screen:id() then
                table.insert(windows, win)
            end
        end
    end
    return windows
end

local function calculateTileFrame(screen, position, tileCount)
    local screenFrame = screen:frame()
    print("Screen frame:", hs.inspect(screenFrame))

    local frame = {}

    if position == "left" then
        frame = {
            x = screenFrame.x,
            y = screenFrame.y,
            w = screenFrame.w / 2,
            h = screenFrame.h
        }
    elseif position == "right" then
        frame = {
            x = screenFrame.x + (screenFrame.w / 2),
            y = screenFrame.y,
            w = screenFrame.w / 2,
            h = screenFrame.h
        }
    elseif position == "top" then
        frame = {
            x = screenFrame.x,
            y = screenFrame.y,
            w = screenFrame.w,
            h = screenFrame.h / 2
        }
    elseif position == "bottom" then
        frame = {
            x = screenFrame.x,
            y = screenFrame.y + (screenFrame.h / 2),
            w = screenFrame.w,
            h = screenFrame.h / 2
        }
    elseif position == "maximize" then
        frame = {
            x = screenFrame.x,
            y = screenFrame.y,
            w = screenFrame.w,
            h = screenFrame.h
        }
    elseif position == "center" then
        local margin_x = screenFrame.w * 0.15
        local margin_y = screenFrame.h * 0.1
        frame = {
            x = screenFrame.x + margin_x,
            y = screenFrame.y + margin_y,
            w = screenFrame.w - (margin_x * 2),
            h = screenFrame.h - (margin_y * 2)
        }
    elseif position == "thirds-left" then
        frame = {
            x = screenFrame.x,
            y = screenFrame.y,
            w = screenFrame.w / 3,
            h = screenFrame.h
        }
    elseif position == "thirds-center" then
        frame = {
            x = screenFrame.x + (screenFrame.w / 3),
            y = screenFrame.y,
            w = screenFrame.w / 3,
            h = screenFrame.h
        }
    elseif position == "thirds-right" then
        frame = {
            x = screenFrame.x + (2 * screenFrame.w / 3),
            y = screenFrame.y,
            w = screenFrame.w / 3,
            h = screenFrame.h
        }
    end

    return frame
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                     ✨ Visual Effects                       │
-- └─────────────────────────────────────────────────────────────┘
local function createBorderHighlight(win, color, duration)
    if not win then return end

    local frame = win:frame()
    local canvas = hs.canvas.new(frame)

    -- Create glowing border effect
    canvas:appendElements({
        {
            type = "rectangle",
            action = "stroke",
            strokeColor = color,
            strokeWidth = config.border_width,
            roundedRectRadii = { xRadius = config.border_radius, yRadius = config.border_radius }
        },
        {
            type = "rectangle",
            action = "stroke",
            strokeColor = { hex = color.hex, alpha = color.alpha * 0.3 },
            strokeWidth = config.border_width + 2,
            roundedRectRadii = { xRadius = config.border_radius + 1, yRadius = config.border_radius + 1 }
        }
    })

    canvas:show(0.1)

    hs.timer.doAfter(duration or 0.8, function()
        canvas:hide(0.3)
        hs.timer.doAfter(0.3, function()
            canvas:delete()
        end)
    end)

    return canvas
end

local function flashWindow(win, color)
    if not win then return end

    local frame = win:frame()
    local flash = hs.canvas.new(frame)

    flash:appendElements({
        {
            type = "rectangle",
            action = "fill",
            fillColor = color or config.colors.focus_flash,
            roundedRectRadii = { xRadius = config.border_radius, yRadius = config.border_radius }
        }
    })

    flash:show(0.05)

    hs.timer.doAfter(0.05, function()
        flash:hide(0.15)
        hs.timer.doAfter(0.15, function()
            flash:delete()
        end)
    end)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                  🎯 Enhanced Window Movement                │
-- └─────────────────────────────────────────────────────────────┘
local function animatedMove(win, frame, showBorder)
    if not win then return end

    -- Pre-move flash
    flashWindow(win, config.colors.background)

    -- Smooth animated movement
    win:setFrame(frame, config.animation_duration)

    -- Post-move border highlight
    if showBorder ~= false then
        hs.timer.doAfter(config.animation_duration * 0.8, function()
            createBorderHighlight(win, config.colors.active_border, 0.6)
        end)
    end
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                  🪟 Public Tiling Functions                │
-- └─────────────────────────────────────────────────────────────┘

local function retileExistingWindows(screen, position)
    local windows = getWindowsInPosition(screen, position)
    local geo = getScreenGeometry(screen)

    for i, win in ipairs(windows) do
        local windowCount = #windows + 1 -- +1 for the new window being added
        local frame = {}

        if position == "left" or position == "right" then
            local windowHeight = geo.h / windowCount
            local windowIndex = i - 1 -- 0-based index

            if position == "left" then
                frame = {
                    x = geo.x,
                    y = geo.y + (windowIndex * windowHeight),
                    w = (geo.w / 2) - (config.gaps.inner / 2),
                    h = windowHeight - config.gaps.inner
                }
            else -- right
                frame = {
                    x = geo.x + (geo.w / 2) + (config.gaps.inner / 2),
                    y = geo.y + (windowIndex * windowHeight),
                    w = (geo.w / 2) - (config.gaps.inner / 2),
                    h = windowHeight - config.gaps.inner
                }
            end

            animatedMove(win, frame, false)
        end
    end
end

function HyprlandTiling.tileWindow(position)
    local win = hs.window.focusedWindow()
    if not win then
        print("No focused window")
        return
    end

    local screen = win:screen()
    print("Tiling window to position:", position)

    -- Skip retiling for now to simplify debugging
    -- retileExistingWindows(screen, position)

    local frame = calculateTileFrame(screen, position)
    print("Calculated frame:", hs.inspect(frame))

    -- Track the window position
    local winId = win:id()
    tiledWindows[winId] = true
    windowPositions[winId] = position

    -- Use direct setFrame instead of animated move for debugging
    print("Setting window frame to:", hs.inspect(frame))
    local success = win:setFrame(frame)
    print("setFrame returned:", success)

    -- Check if window actually moved
    local newFrame = win:frame()
    print("Window frame after setFrame:", hs.inspect(newFrame))

    -- Disable visual effects for debugging
    -- createBorderHighlight(win, config.colors.active_border, 0.6)
end

function HyprlandTiling.resizeWindow(direction, amount)
    local win = hs.window.focusedWindow()
    if not win then return end

    local frame = win:frame()
    amount = amount or 50

    if direction == "wider" then
        frame.w = frame.w + amount
        frame.x = frame.x - (amount / 2)
    elseif direction == "narrower" then
        frame.w = math.max(frame.w - amount, 200)
        frame.x = frame.x + (amount / 2)
    elseif direction == "taller" then
        frame.h = frame.h + amount
        frame.y = frame.y - (amount / 2)
    elseif direction == "shorter" then
        frame.h = math.max(frame.h - amount, 100)
        frame.y = frame.y + (amount / 2)
    end

    animatedMove(win, frame, false)
end

function HyprlandTiling.cycleWindows(direction)
    local focusedWin = hs.window.focusedWindow()
    if not focusedWin then return end

    local allWindows = hs.window.visibleWindows()
    local currentIndex = nil

    -- Find current window index
    for i, win in ipairs(allWindows) do
        if win:id() == focusedWin:id() then
            currentIndex = i
            break
        end
    end

    if not currentIndex then return end

    local nextIndex
    if direction == "next" then
        nextIndex = (currentIndex % #allWindows) + 1
    else
        nextIndex = currentIndex == 1 and #allWindows or currentIndex - 1
    end

    local nextWindow = allWindows[nextIndex]
    if nextWindow then
        nextWindow:focus()
        flashWindow(nextWindow, config.colors.focus_flash)
    end
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   🎨 Workspace Integration                  │
-- └─────────────────────────────────────────────────────────────┘
function HyprlandTiling.switchToWorkspace(workspace)
    -- Execute aerospace command
    hs.execute(string.format("aerospace workspace %s", workspace))

    -- Visual feedback
    hs.timer.doAfter(0.1, function()
        local focusedWin = hs.window.focusedWindow()
        if focusedWin then
            createBorderHighlight(focusedWin, config.colors.focus_flash, 0.4)
        end
    end)
end

function HyprlandTiling.moveWindowToWorkspace(workspace)
    local win = hs.window.focusedWindow()
    if not win then return end

    -- Flash before move
    flashWindow(win, config.colors.background)

    -- Execute aerospace command
    hs.execute(string.format("aerospace move-node-to-workspace %s", workspace))

    -- Follow window to new workspace
    hs.timer.doAfter(0.2, function()
        hs.execute(string.format("aerospace workspace %s", workspace))
    end)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                  🎛️ Advanced Layout Functions              │
-- └─────────────────────────────────────────────────────────────┘
function HyprlandTiling.toggleFloating()
    hs.execute("aerospace layout floating tiling")

    local focusedWin = hs.window.focusedWindow()
    if focusedWin then
        hs.timer.doAfter(0.1, function()
            createBorderHighlight(focusedWin, config.colors.active_border, 0.5)
        end)
    end
end

function HyprlandTiling.toggleLayout()
    hs.execute("aerospace layout tiles horizontal vertical")

    hs.timer.doAfter(0.1, function()
        local focusedWin = hs.window.focusedWindow()
        if focusedWin then
            createBorderHighlight(focusedWin, config.colors.focus_flash, 0.5)
        end
    end)
end

function HyprlandTiling.resetLayout()
    hs.execute("aerospace flatten-workspace-tree")

    hs.timer.doAfter(0.2, function()
        local allWindows = hs.window.visibleWindows()
        for _, win in ipairs(allWindows) do
            createBorderHighlight(win, config.colors.active_border, 0.3)
        end
    end)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                    📊 Workspace Status                      │
-- └─────────────────────────────────────────────────────────────┘
function HyprlandTiling.showWorkspaceInfo()
    local result = hs.execute("aerospace list-workspaces --monitor focused --visible")
    local workspace = result:gsub("%s+", "")

    hs.notify.new({
        title = "Current Workspace",
        informativeText = "Workspace: " .. workspace,
        withdrawAfter = 2
    }):send()
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                     ⚙️ Configuration                        │
-- └─────────────────────────────────────────────────────────────┘
function HyprlandTiling.updateConfig(newConfig)
    for key, value in pairs(newConfig) do
        config[key] = value
    end
end

function HyprlandTiling.getConfig()
    return config
end

return HyprlandTiling