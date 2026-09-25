return {
  {
    "kawre/leetcode.nvim",
    -- load eagerly for `nvim leetcode.nvim`, otherwise on :Leet
    lazy = "leetcode.nvim" ~= vim.fn.argv(0, -1),
    cmd = "Leet",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "cpp",
      picker = { provider = "snacks-picker" },
    },
  },
}
