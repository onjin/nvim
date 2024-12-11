return {
   {
      'echasnovski/mini.statusline',
      version = false,
      dependencies = {
         { 'echasnovski/mini.icons',  version = false },
         { 'echasnovski/mini-git',    version = false },
         { 'echasnovski/mini.diff',   version = false },
         { 'echasnovski/mini.notify', version = false },
      },
      config = function()
         require("custom.statusline").setup_mini()
      end,
   },
}
