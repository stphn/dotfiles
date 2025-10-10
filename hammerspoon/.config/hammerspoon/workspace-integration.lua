-- ╭─────────────────────────────────────────────────────────────╮
-- │              🌌 Aerospace Workspace Integration             │
-- │           Seamless Workspace Management & Monitoring       │
-- ╰─────────────────────────────────────────────────────────────╯

local WorkspaceIntegration = {}

-- ┌─────────────────────────────────────────────────────────────┐
-- │                     📊 Workspace Tracking                  │
-- └─────────────────────────────────────────────────────────────┘
local workspaceState = {
    current = "1",
    previous = "1",
    history = {},
    apps = {}
}

-- Nord-inspired colors for workspace indicators
local colors = {
    active = { hex = "#88C0D0", alpha = 0.9 },      -- Nord frost blue
    inactive = { hex = "#4C566A", alpha = 0.6 },    -- Nord polar night
    highlight = { hex = "#A3BE8C", alpha = 0.8 },   -- Nord aurora green
    background = { hex = "#2E3440", alpha = 0.95 }  -- Nord polar night dark
}

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   🔍 Workspace Detection                    │
-- └─────────────────────────────────────────────────────────────┘
local function getCurrentWorkspace()
    local result = hs.execute("aerospace list-workspaces --monitor focused --visible")
    if result then
        return result:gsub("%s+", "")
    end
    return "1"
end

local function getAllWorkspaces()
    local result = hs.execute("aerospace list-workspaces --all")
    local workspaces = {}
    if result then
        for workspace in result:gmatch("%S+") do
            table.insert(workspaces, workspace)
        end
    end
    return workspaces
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   🎨 Visual Workspace Indicator            │
-- └─────────────────────────────────────────────────────────────┘
local workspaceIndicator = nil

local function createWorkspaceIndicator()
    if workspaceIndicator then
        workspaceIndicator:delete()
    end

    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    local indicatorSize = { w = 200, h = 40 }
    local position = {
        x = frame.x + (frame.w - indicatorSize.w) / 2,
        y = frame.y + 60  -- Top center of screen
    }

    workspaceIndicator = hs.canvas.new({
        x = position.x,
        y = position.y,
        w = indicatorSize.w,
        h = indicatorSize.h
    })

    -- Background
    workspaceIndicator:appendElements({
        {
            type = "rectangle",
            action = "fill",
            fillColor = colors.background,
            roundedRectRadii = { xRadius = 12, yRadius = 12 }
        },
        {
            type = "rectangle",
            action = "stroke",
            strokeColor = colors.active,
            strokeWidth = 2,
            roundedRectRadii = { xRadius = 12, yRadius = 12 }
        }
    })

    return workspaceIndicator
end

local function showWorkspaceIndicator(workspace, duration)
    local indicator = createWorkspaceIndicator()

    -- Add workspace text
    indicator:appendElements({
        {
            type = "text",
            text = "Workspace " .. workspace,
            textColor = colors.active,
            textFont = "JetBrains Mono",
            textSize = 16,
            textAlignment = "center"
        }
    })

    indicator:show(0.2)

    hs.timer.doAfter(duration or 1.5, function()
        indicator:hide(0.3)
        hs.timer.doAfter(0.3, function()
            indicator:delete()
        end)
    end)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                  📋 Workspace Status Display               │
-- └─────────────────────────────────────────────────────────────┘
local statusDisplay = nil

local function createStatusDisplay()
    if statusDisplay then
        statusDisplay:delete()
    end

    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    local statusSize = { w = 400, h = 120 }
    local position = {
        x = frame.x + frame.w - statusSize.w - 20,
        y = frame.y + 20
    }

    statusDisplay = hs.canvas.new({
        x = position.x,
        y = position.y,
        w = statusSize.w,
        h = statusSize.h
    })

    -- Semi-transparent background
    statusDisplay:appendElements({
        {
            type = "rectangle",
            action = "fill",
            fillColor = colors.background,
            roundedRectRadii = { xRadius = 15, yRadius = 15 }
        },
        {
            type = "rectangle",
            action = "stroke",
            strokeColor = colors.highlight,
            strokeWidth = 2,
            roundedRectRadii = { xRadius = 15, yRadius = 15 }
        }
    })

    return statusDisplay
end

local function showWorkspaceStatus()
    local display = createStatusDisplay()
    local currentWS = getCurrentWorkspace()
    local allWorkspaces = getAllWorkspaces()

    -- Title
    display:appendElements({
        {
            type = "text",
            text = "🌌 Workspaces",
            textColor = colors.highlight,
            textFont = "JetBrains Mono",
            textSize = 14,
            textAlignment = "center",
            frame = { x = 0, y = 10, w = 400, h = 20 }
        }
    })

    -- Current workspace
    display:appendElements({
        {
            type = "text",
            text = "Current: " .. currentWS,
            textColor = colors.active,
            textFont = "JetBrains Mono",
            textSize = 12,
            textAlignment = "left",
            frame = { x = 20, y = 35, w = 360, h = 20 }
        }
    })

    -- Available workspaces
    local wsText = "Available: " .. table.concat(allWorkspaces, ", ")
    display:appendElements({
        {
            type = "text",
            text = wsText,
            textColor = colors.inactive,
            textFont = "JetBrains Mono",
            textSize = 11,
            textAlignment = "left",
            frame = { x = 20, y = 55, w = 360, h = 40 }
        }
    })

    display:show(0.2)

    hs.timer.doAfter(3.0, function()
        display:hide(0.3)
        hs.timer.doAfter(0.3, function()
            display:delete()
        end)
    end)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                    🎯 Workspace Navigation                  │
-- └─────────────────────────────────────────────────────────────┘
function WorkspaceIntegration.switchToWorkspace(workspace)
    local currentWS = getCurrentWorkspace()

    if currentWS ~= workspace then
        -- Update state
        workspaceState.previous = currentWS
        workspaceState.current = workspace

        -- Add to history
        table.insert(workspaceState.history, 1, currentWS)
        if #workspaceState.history > 10 then
            table.remove(workspaceState.history, 11)
        end

        -- Execute switch
        hs.execute(string.format("aerospace workspace %s", workspace))

        -- Visual feedback
        showWorkspaceIndicator(workspace, 1.2)

        -- Focus highlight after switch
        hs.timer.doAfter(0.3, function()
            local focusedWin = hs.window.focusedWindow()
            if focusedWin then
                local HyprlandTiling = require("hyprland-tiling")
                local config = HyprlandTiling.getConfig()
                local frame = focusedWin:frame()
                local canvas = hs.canvas.new(frame)

                canvas:appendElements({
                    {
                        type = "rectangle",
                        action = "stroke",
                        strokeColor = colors.highlight,
                        strokeWidth = 3,
                        roundedRectRadii = { xRadius = 8, yRadius = 8 }
                    }
                })

                canvas:show(0.1)
                hs.timer.doAfter(0.8, function()
                    canvas:hide(0.2)
                    hs.timer.doAfter(0.2, function()
                        canvas:delete()
                    end)
                end)
            end
        end)
    end
end

function WorkspaceIntegration.moveWindowToWorkspace(workspace)
    local win = hs.window.focusedWindow()
    if not win then return end

    local currentWS = getCurrentWorkspace()

    -- Flash window before move
    local frame = win:frame()
    local flash = hs.canvas.new(frame)
    flash:appendElements({
        {
            type = "rectangle",
            action = "fill",
            fillColor = { hex = "#A3BE8C", alpha = 0.3 },
            roundedRectRadii = { xRadius = 8, yRadius = 8 }
        }
    })

    flash:show(0.1)
    hs.timer.doAfter(0.15, function()
        flash:hide(0.1)
        flash:delete()
    end)

    -- Execute move
    hs.execute(string.format("aerospace move-node-to-workspace %s", workspace))

    -- Show indicator
    showWorkspaceIndicator(workspace .. " ← " .. currentWS, 1.5)
end

function WorkspaceIntegration.moveWindowAndFollow(workspace)
    WorkspaceIntegration.moveWindowToWorkspace(workspace)

    -- Follow after a brief delay
    hs.timer.doAfter(0.3, function()
        WorkspaceIntegration.switchToWorkspace(workspace)
    end)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   🔄 Workspace Utilities                    │
-- └─────────────────────────────────────────────────────────────┘
function WorkspaceIntegration.togglePreviousWorkspace()
    if workspaceState.previous then
        WorkspaceIntegration.switchToWorkspace(workspaceState.previous)
    end
end

function WorkspaceIntegration.showWorkspaceOverview()
    showWorkspaceStatus()
end

function WorkspaceIntegration.cycleWorkspaces(direction)
    local allWorkspaces = getAllWorkspaces()
    local currentWS = getCurrentWorkspace()
    local currentIndex = nil

    -- Find current workspace index
    for i, ws in ipairs(allWorkspaces) do
        if ws == currentWS then
            currentIndex = i
            break
        end
    end

    if not currentIndex then return end

    local nextIndex
    if direction == "next" then
        nextIndex = (currentIndex % #allWorkspaces) + 1
    else
        nextIndex = currentIndex == 1 and #allWorkspaces or currentIndex - 1
    end

    local nextWorkspace = allWorkspaces[nextIndex]
    if nextWorkspace then
        WorkspaceIntegration.switchToWorkspace(nextWorkspace)
    end
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                  📱 Application Management                  │
-- └─────────────────────────────────────────────────────────────┘
function WorkspaceIntegration.launchAppInWorkspace(appName, workspace)
    -- Switch to target workspace first
    WorkspaceIntegration.switchToWorkspace(workspace)

    -- Launch application
    hs.timer.doAfter(0.2, function()
        hs.application.launchOrFocus(appName)

        -- Visual feedback
        showWorkspaceIndicator(workspace .. " → " .. appName, 2.0)
    end)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   🔧 Layout Management                      │
-- └─────────────────────────────────────────────────────────────┘
function WorkspaceIntegration.toggleWorkspaceLayout()
    hs.execute("aerospace layout tiles horizontal vertical")

    local currentWS = getCurrentWorkspace()
    showWorkspaceIndicator("Layout → " .. currentWS, 1.0)
end

function WorkspaceIntegration.toggleFloatingMode()
    hs.execute("aerospace layout floating tiling")

    local currentWS = getCurrentWorkspace()
    showWorkspaceIndicator("Float ⇄ " .. currentWS, 1.0)
end

function WorkspaceIntegration.resetWorkspaceLayout()
    hs.execute("aerospace flatten-workspace-tree")

    local currentWS = getCurrentWorkspace()
    showWorkspaceIndicator("Reset → " .. currentWS, 1.5)

    -- Highlight all windows briefly
    hs.timer.doAfter(0.5, function()
        local allWindows = hs.window.visibleWindows()
        for _, win in ipairs(allWindows) do
            local frame = win:frame()
            local highlight = hs.canvas.new(frame)

            highlight:appendElements({
                {
                    type = "rectangle",
                    action = "stroke",
                    strokeColor = colors.highlight,
                    strokeWidth = 2,
                    roundedRectRadii = { xRadius = 6, yRadius = 6 }
                }
            })

            highlight:show(0.1)
            hs.timer.doAfter(0.6, function()
                highlight:hide(0.2)
                hs.timer.doAfter(0.2, function()
                    highlight:delete()
                end)
            end)
        end
    end)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                     📊 State Management                     │
-- └─────────────────────────────────────────────────────────────┘
function WorkspaceIntegration.getState()
    workspaceState.current = getCurrentWorkspace()
    return workspaceState
end

function WorkspaceIntegration.initializeMonitoring()
    -- Update current workspace state
    workspaceState.current = getCurrentWorkspace()

    hs.notify.new({
        title = "Workspace Integration",
        informativeText = "Monitoring workspace: " .. workspaceState.current,
        withdrawAfter = 2
    }):send()
end

return WorkspaceIntegration