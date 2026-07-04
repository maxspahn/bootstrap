return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    --"rcarriga/nvim-notify"
  },
  -- filter progress
  options = {
    routes = {
      {
        filter = { -- filter progress messages
          event = "lsp",
          kind = "progress",
        },
      },
    },
  },
  config = function()
    require("noice").setup({
      cmdline = {
        view = "cmdline_popup", -- enables floating command line
g     },
      presets = {
        command_palette = true,
      },
    })
  end
}

