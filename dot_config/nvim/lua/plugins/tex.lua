return {
  {
    "lervag/vimtex",
    init = function()
      -- tectonic from homebrew instead of latexmk/MacTeX (handles bibtex/biber itself)
      vim.g.vimtex_compiler_method = "tectonic"
      -- vimtex passes --keep-logs so the quickfix list can be filled from the
      -- .log. Delete it after a successful build (quickfix is already parsed by
      -- then). vimtex judges success by parsing the log, not by exit code, and
      -- its errorformat misses plain "! ..." TeX errors from tectonic (no
      -- -file-line-error), so keep the log and warn if any such line exists.
      vim.api.nvim_create_autocmd("User", {
        pattern = "VimtexEventCompileSuccess",
        callback = function()
          local log = vim.fn.eval("b:vimtex.compiler.get_file('log')")
          if log == "" or vim.fn.filereadable(log) == 0 then return end
          for _, line in ipairs(vim.fn.readfile(log)) do
            if line:match("^! ") then
              vim.notify("VimTeX: TeX errors in " .. vim.fn.fnamemodify(log, ":t")
                .. " (see :VimtexCompileOutput)", vim.log.levels.WARN)
              return
            end
          end
          vim.fn.delete(log)
        end,
      })
      -- Skim viewer with SyncTeX forward/backward search
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
    end,
  },
}
