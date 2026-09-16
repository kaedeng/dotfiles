return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- installed via opam (`opam install ocaml-lsp-server`), not mason
        ocamllsp = { mason = false },
      },
    },
  },
}
