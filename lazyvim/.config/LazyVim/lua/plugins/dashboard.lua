return {
  {
    "nvimdev/dashboard-nvim",
    optional = true, -- only load if you’ve enabled the extra
    opts = function(_, opts)
      -- Your ASCII logo here (replace with what you like)
      local logo = [[


⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠉⠉⣶⣶⣦⠀⠀⠀⠀⠀⠀⠀⠀⣴⣶⣶⠉⠉⠁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣀⣀⣿⣿⣿⣀⣀⣀⣀⣀⣀⣀⣀⣿⣿⣿⣀⣀⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀
⠀⠀⢸⣿⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⣿⣿⠀⠀⠀
⣤⣤⣼⣿⣿⣿⣿⣿⣤⣤⣤⣿⣿⣿⣿⣿⣿⣿⣿⣤⣤⣤⣿⣿⣿⣿⣿⣤⣤⣤
⣿⣿⣿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⣿⣿⣿
⣿⣿⡇⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⣿⣿⣿
⣿⣿⡇⠀⠀⢸⣿⣿⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⣿⣿⡇⠀⠀⣿⣿⣿
⠛⠛⠃⠀⠀⠘⠛⠛⣤⣤⣤⣤⣤⡀⠀⠀⢠⣤⣤⣤⣤⣤⠛⠛⠃⠀⠀⠛⠛⠛
⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡇⠀⠀⢸⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀

      ]]

      -- Assign logo lines to dashboard header
      opts.config.header = vim.split(logo, "\n", { trimempty = false })
    end,
  },
}
