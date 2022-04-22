lua <<EOF
require('dap-python').setup('~/.pyenv/versions/debugpy/bin/python')
require('dap-python').test_runner = 'pytest'


require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 00.25 },
    },
    size = 40,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = { 
    max_type_length = nil, -- Can be integer or nil.
  }
})

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


function debug_python_monolith(args)
    local dap = require "dap"
    pythonAttachAdapter = {
        type = "server";
        host = '127.0.0.1';
        port = 3000;
    }
    pythonAttachConfig = {
        type = "python";
        request = "attach";
        connect = {
            port = 3000;
            host = '127.0.0.1';
        };
        mode = "remote";
        name = "Remote Attached Debugger";
        cwd = vim.fn.getcwd();
        pathMappings = {
            {
                localRoot = vim.fn.getcwd(); -- Wherever your Python code lives locally.
                remoteRoot = "/opt/application"; -- Wherever your Python code lives in the container.
            };
        };
    }
    local session = dap.attach('127.0.0.1', 3000, pythonAttachConfig)
    if session == nil then
        io.write("Error launching adapter");
    end
    dap.repl.open()
end

EOF

nnoremap <silent> <leader>in :lua require('dap-python').test_method()<CR>
nnoremap <silent> <leader>if :lua require('dap-python').test_class()<CR>
vnoremap <silent> <leader>is <ESC>:lua require('dap-python').debug_selection()<CR>
