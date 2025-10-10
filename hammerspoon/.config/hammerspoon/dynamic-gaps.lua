-- ╭─────────────────────────────────────────────────────────────╮
-- │                   📐 Dynamic Gap Management                 │
-- │         Hyprland-Style Dynamic Gaps & Layout Control       │
-- ╰─────────────────────────────────────────────────────────────╯

local DynamicGaps = {}

-- ┌─────────────────────────────────────────────────────────────┐
-- │                      ⚙️ Gap Configuration                   │
-- └─────────────────────────────────────────────────────────────┘
local gapConfig = {
    current = {
        inner = 8,
        outer = 12
    },
    presets = {
        compact = { inner = 4, outer = 6 },
        comfortable = { inner = 8, outer = 12 },
        spacious = { inner = 16, outer = 20 },
        minimal = { inner = 0, outer = 4 },
        presentation = { inner = 24, outer = 32 }
    },
    animation_duration = 0.3,
    colors = {
        preview = { hex = "#A3BE8C", alpha = 0.2 },
        border = { hex = "#88C0D0", alpha = 0.6 },
        indicator = { hex = "#EBCB8B", alpha = 0.9 }
    }
}

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   📊 Layout State Tracking                 │
-- └─────────────────────────────────────────────────────────────┘
local layoutState = {
    current_preset = "comfortable",
    is_floating = false,
    monitor_layouts = {},
    window_states = {}
}

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   🎨 Visual Gap Indicators                  │
-- └─────────────────────────────────────────────────────────────┘
local gapIndicator = nil

local function createGapIndicator(preset_name, gaps)
    if gapIndicator then
        gapIndicator:delete()
    end

    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    local indicatorSize = { w = 300, h = 80 }
    local position = {
        x = frame.x + (frame.w - indicatorSize.w) / 2,
        y = frame.y + frame.h - indicatorSize.h - 100
    }

    gapIndicator = hs.canvas.new({
        x = position.x,
        y = position.y,
        w = indicatorSize.w,
        h = indicatorSize.h
    })

    -- Background with rounded corners
    gapIndicator:appendElements({
        {
            type = "rectangle",
            action = "fill",
            fillColor = { hex = "#2E3440", alpha = 0.95 },
            roundedRectRadii = { xRadius = 15, yRadius = 15 }
        },
        {
            type = "rectangle",
            action = "stroke",
            strokeColor = gapConfig.colors.indicator,
            strokeWidth = 2,
            roundedRectRadii = { xRadius = 15, yRadius = 15 }
        }
    })

    -- Title
    gapIndicator:appendElements({
        {
            type = "text",
            text = "📐 Gap Preset: " .. preset_name:upper(),
            textColor = gapConfig.colors.indicator,
            textFont = "JetBrains Mono",
            textSize = 14,
            textAlignment = "center",
            frame = { x = 0, y = 15, w = 300, h = 20 }
        }
    })

    -- Gap values
    gapIndicator:appendElements({
        {
            type = "text",
            text = string.format("Inner: %d • Outer: %d", gaps.inner, gaps.outer),
            textColor = { hex = "#88C0D0", alpha = 0.9 },
            textFont = "JetBrains Mono",
            textSize = 12,
            textAlignment = "center",
            frame = { x = 0, y = 45, w = 300, h = 20 }
        }
    })

    return gapIndicator
end

local function showGapIndicator(preset_name, gaps, duration)
    local indicator = createGapIndicator(preset_name, gaps)
    indicator:show(0.2)

    hs.timer.doAfter(duration or 2.0, function()
        indicator:hide(0.3)
        hs.timer.doAfter(0.3, function()
            indicator:delete()
        end)
    end)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                  🎯 Gap Preview Visualization              │
-- └─────────────────────────────────────────────────────────────┘
local function showGapPreview(gaps)
    local allWindows = hs.window.visibleWindows()
    local previews = {}

    for _, win in ipairs(allWindows) do
        local frame = win:frame()
        local screen = win:screen()
        local screenFrame = screen:frame()

        -- Calculate preview frame with new gaps
        local previewFrame = {
            x = frame.x + gaps.inner,
            y = frame.y + gaps.inner,
            w = frame.w - (gaps.inner * 2),
            h = frame.h - (gaps.inner * 2)
        }

        -- Create preview overlay
        local preview = hs.canvas.new(previewFrame)
        preview:appendElements({
            {
                type = "rectangle",
                action = "fill",
                fillColor = gapConfig.colors.preview,
                roundedRectRadii = { xRadius = 8, yRadius = 8 }
            },
            {
                type = "rectangle",
                action = "stroke",
                strokeColor = gapConfig.colors.border,
                strokeWidth = 2,
                roundedRectRadii = { xRadius = 8, yRadius = 8 }
            }
        })

        preview:show(0.2)
        table.insert(previews, preview)
    end

    -- Auto-hide previews
    hs.timer.doAfter(1.5, function()
        for _, preview in ipairs(previews) do
            preview:hide(0.2)
            hs.timer.doAfter(0.2, function()
                preview:delete()
            end)
        end
    end)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   🔧 Gap Management Functions               │
-- └─────────────────────────────────────────────────────────────┘
local function updateAerospaceGaps(gaps)
    -- Update Aerospace configuration with new gaps
    local commands = {
        string.format("aerospace reload-config"),
        -- Note: Aerospace doesn't support runtime gap changes,
        -- but we can still provide visual feedback
    }

    for _, cmd in ipairs(commands) do
        hs.execute(cmd)
    end
end

function DynamicGaps.setGapPreset(preset_name)
    if not gapConfig.presets[preset_name] then
        hs.notify.new({
            title = "Gap Error",
            informativeText = "Unknown preset: " .. preset_name,
            withdrawAfter = 2
        }):send()
        return
    end

    local gaps = gapConfig.presets[preset_name]
    gapConfig.current = { inner = gaps.inner, outer = gaps.outer }
    layoutState.current_preset = preset_name

    -- Show preview
    showGapPreview(gaps)

    -- Update Aerospace (visual feedback only)
    updateAerospaceGaps(gaps)

    -- Show indicator
    showGapIndicator(preset_name, gaps, 2.5)

    -- Store state
    layoutState.monitor_layouts[hs.screen.mainScreen():id()] = {
        preset = preset_name,
        gaps = gaps
    }
end

function DynamicGaps.adjustGaps(direction, amount)
    amount = amount or 2
    local gaps = gapConfig.current

    if direction == "increase_inner" then
        gaps.inner = math.min(gaps.inner + amount, 50)
    elseif direction == "decrease_inner" then
        gaps.inner = math.max(gaps.inner - amount, 0)
    elseif direction == "increase_outer" then
        gaps.outer = math.min(gaps.outer + amount, 100)
    elseif direction == "decrease_outer" then
        gaps.outer = math.max(gaps.outer - amount, 0)
    elseif direction == "increase_all" then
        gaps.inner = math.min(gaps.inner + amount, 50)
        gaps.outer = math.min(gaps.outer + amount, 100)
    elseif direction == "decrease_all" then
        gaps.inner = math.max(gaps.inner - amount, 0)
        gaps.outer = math.max(gaps.outer - amount, 0)
    end

    gapConfig.current = gaps
    showGapPreview(gaps)
    showGapIndicator("custom", gaps, 1.5)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                 🎨 Layout Switching with Animation         │
-- └─────────────────────────────────────────────────────────────┘
function DynamicGaps.cycleGapPresets(direction)
    local presets = { "compact", "comfortable", "spacious", "minimal", "presentation" }
    local currentIndex = 1

    -- Find current preset index
    for i, preset in ipairs(presets) do
        if preset == layoutState.current_preset then
            currentIndex = i
            break
        end
    end

    local nextIndex
    if direction == "next" then
        nextIndex = (currentIndex % #presets) + 1
    else
        nextIndex = currentIndex == 1 and #presets or currentIndex - 1
    end

    local nextPreset = presets[nextIndex]
    DynamicGaps.setGapPreset(nextPreset)
end

function DynamicGaps.toggleCompactMode()
    if layoutState.current_preset == "compact" then
        DynamicGaps.setGapPreset("comfortable")
    else
        DynamicGaps.setGapPreset("compact")
    end
end

function DynamicGaps.togglePresentationMode()
    if layoutState.current_preset == "presentation" then
        DynamicGaps.setGapPreset("comfortable")
    else
        DynamicGaps.setGapPreset("presentation")
    end
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │               📱 Monitor-Specific Gap Management           │
-- └─────────────────────────────────────────────────────────────┘
function DynamicGaps.adaptGapsToMonitor()
    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    local screenId = screen:id()

    -- Auto-adjust gaps based on screen size
    local preset
    if frame.w < 1920 then
        preset = "compact"  -- Smaller screens use compact gaps
    elseif frame.w > 2560 then
        preset = "spacious"  -- Larger screens use spacious gaps
    else
        preset = "comfortable"  -- Standard screens use comfortable gaps
    end

    -- Check if we have a stored preference for this monitor
    if layoutState.monitor_layouts[screenId] then
        preset = layoutState.monitor_layouts[screenId].preset
    end

    DynamicGaps.setGapPreset(preset)
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   🎛️ Advanced Layout Controls              │
-- └─────────────────────────────────────────────────────────────┘
function DynamicGaps.smartGapAdjustment()
    local allWindows = hs.window.visibleWindows()
    local windowCount = #allWindows

    -- Adjust gaps based on window count
    local preset
    if windowCount <= 2 then
        preset = "spacious"
    elseif windowCount <= 4 then
        preset = "comfortable"
    else
        preset = "compact"
    end

    DynamicGaps.setGapPreset(preset)
end

function DynamicGaps.saveCurrentLayout()
    local screen = hs.screen.mainScreen()
    local screenId = screen:id()

    layoutState.monitor_layouts[screenId] = {
        preset = layoutState.current_preset,
        gaps = {
            inner = gapConfig.current.inner,
            outer = gapConfig.current.outer
        }
    }

    hs.notify.new({
        title = "Layout Saved",
        informativeText = "Current gaps saved for this monitor",
        withdrawAfter = 2
    }):send()
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                   📊 Status and Information                │
-- └─────────────────────────────────────────────────────────────┘
function DynamicGaps.showGapStatus()
    local gaps = gapConfig.current
    local preset = layoutState.current_preset

    hs.notify.new({
        title = "Current Gap Settings",
        informativeText = string.format("Preset: %s\nInner: %d, Outer: %d",
                                       preset:upper(), gaps.inner, gaps.outer),
        withdrawAfter = 3
    }):send()
end

function DynamicGaps.getConfig()
    return {
        gaps = gapConfig.current,
        preset = layoutState.current_preset,
        state = layoutState
    }
end

-- ┌─────────────────────────────────────────────────────────────┐
-- │                     🔧 Initialization                       │
-- └─────────────────────────────────────────────────────────────┘
function DynamicGaps.initialize()
    -- Set up monitor change watcher
    local monitorWatcher = hs.screen.watcher.new(function()
        hs.timer.doAfter(0.5, function()
            DynamicGaps.adaptGapsToMonitor()
        end)
    end)
    monitorWatcher:start()

    -- Initialize with comfortable preset
    DynamicGaps.setGapPreset("comfortable")

    hs.notify.new({
        title = "Dynamic Gaps",
        informativeText = "Gap management initialized",
        withdrawAfter = 2
    }):send()
end

return DynamicGaps