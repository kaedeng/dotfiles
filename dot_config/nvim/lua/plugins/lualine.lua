return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- flat blocks instead of powerline arrows
    opts.options.section_separators = { left = "", right = "" }
    opts.options.component_separators = { left = "", right = "" }
  end,
}
