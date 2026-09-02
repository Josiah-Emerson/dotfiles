-- Holds simple and general plugins that don't need their own file
return{
	-- auto pairs
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
}
