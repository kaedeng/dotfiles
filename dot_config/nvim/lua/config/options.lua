-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0

-- compose files -> docker_compose_language_service (yamlls still attaches too)
vim.filetype.add({
  pattern = {
    ["compose.*%.ya?ml"] = "yaml.docker-compose",
    ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
  },
})
vim.treesitter.language.register("yaml", "yaml.docker-compose")
