local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

treesitter.setup({
  highlight = {
    enable = true,
  },
  ensure_installed = {
	  "bash",
	  "go",
	  "java",
	  "javascript",
	  "json",
	  "toml",
  },
})
