return {
  {
    "lervag/vimtex",
    init = function()
      -- tectonic from homebrew instead of latexmk/MacTeX (handles bibtex/biber itself)
      vim.g.vimtex_compiler_method = "tectonic"
    end,
  },
}
