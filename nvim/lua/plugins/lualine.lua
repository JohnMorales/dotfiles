return {
     { 
       'nvim-lualine/lualine.nvim',
       dependencies = { 'nvim-tree/nvim-web-devicons' },
       lazy = false,
       opts = { 
	config = {
	    icons_enabled = true,
	    theme = 'auto',
	    component_separators = { left = '', right = ''},
	    section_separators = { left = '', right = ''},
	    disabled_filetypes = {
	      statusline = {},
	      winbar = {},
	    },
	    ignore_focus = {},
	    always_divide_middle = true,
	    globalstatus = false,
	    refresh = {
	      statusline = 1000,
	      tabline = 1000,
	      winbar = 1000,
	    }
	  },
	  sections = {
	    lualine_a = {'mode'},
	    lualine_b = {'branch', 'diff', 'diagnostics'},
	    lualine_c = {'filename'},
	    lualine_x = {'encoding', 'fileformat', 'filetype'},
	    lualine_y = {'progress'},
	    lualine_z = {'location'}
	  },
	  inactive_sections = {
	    lualine_a = {},
	    lualine_b = {},
	    lualine_c = {'filename'},
	    lualine_x = {'location'},
	    lualine_y = {},
	    lualine_z = {}
	  },
	  tabline = {
		  lualine_a = {'buffers'},
		  lualine_b = {},
		  lualine_c = {},
		  lualine_x = {},
		  lualine_y = {},
		  lualine_z = {'tabs'}
		},
	  winbar = {},
	  inactive_winbar = {},
	  extensions = {}
	},
	keys = {
	  { "<leader>1", "<cmd>LualineBuffersJump 1<cr>", desc = "Jump to buffer 1" },
	  { "<leader>2", "<cmd>LualineBuffersJump 2<cr>", desc = "Jump to buffer 2" },
	  { "<leader>3", "<cmd>LualineBuffersJump 3<cr>", desc = "Jump to buffer 3" },
	  { "<leader>4", "<cmd>LualineBuffersJump 4<cr>", desc = "Jump to buffer 4" },
	  { "<leader>5", "<cmd>LualineBuffersJump 5<cr>", desc = "Jump to buffer 5" },
	  { "<leader>6", "<cmd>LualineBuffersJump 5<cr>", desc = "Jump to buffer 6" },
	  { "<leader>7", "<cmd>LualineBuffersJump 7<cr>", desc = "Jump to buffer 7" },
	  { "<leader>8", "<cmd>LualineBuffersJump 8<cr>", desc = "Jump to buffer 8" },
	  { "<leader>9", "<cmd>LualineBuffersJump 9<cr>", desc = "Jump to buffer 9" },
	  }
    }
}
