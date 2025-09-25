hs.loadSpoon("Hammerflow")

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
