local settings = require('user-conf')
local fn = vim.fn

-- packer location
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
local function get_config(name)
	return string.format('require("config/%s")', name)
end

-- install packer from github if is not in our system
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer...")
	vim.api.nvim_command("packadd packer.nvim")
end

-- initialize and configure packer
local packer = require("packer")

-- autocommand that reloads neovim when plugins.lua changes
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

packer.init({
  -- enable profiling via :PackerCompile profile=true
	enable = true,

  -- the amount in ms that a plugins load time must be over for it to be included in the profile
	threshold = 0,

  -- limit the number of simultaneous jobs. nil means no limit. set to 20 in order to prevent PackerSync form being "stuck" -> https://github.com/wbthomason/packer.nvim/issues/746
	max_jobs = 20,

	-- Have packer use a popup window
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- plugins

packer.startup(function(use)
	-- actual plugins list
	use("wbthomason/packer.nvim")

	use({ "windwp/nvim-autopairs", config = get_config("nvim-autopairs") })

	use 'ibhagwan/fzf-lua'
	
	-- colorschemes
	use 'tiagovla/tokyodark.nvim'
	use 'shaeinst/roshnivim-cs'
	use 'glepnir/zephyr-nvim'
	use 'shaunsingh/nord.nvim'
	use 'junegunn/fzf'

	use({'norcalli/nvim-colorizer.lua', cmd = 'ColorizerToggle', config = function()
		require('colorizer').setup()	
	end})
end)
