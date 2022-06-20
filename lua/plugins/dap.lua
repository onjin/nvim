require('dap-python').setup('~/.pyenv/versions/debugpy/bin/python')
require('dap-python').test_runner = 'pytest'


--[[require('dapui').setup(                                                                                                                                                                                             
  layouts = {                                                                                                                                                                                                       
    {                                                                                                                                                                                                               
      elements = {                                                                                                                                                                                                  
        'scopes',                                                                                                                                                                                                   
        'breakpoints',                                                                                                                                                                                              
        'stacks',                                                                                                                                                                                                   
        'watches',                                                                                                                                                                                                  
      },                                                                                                                                                                                                            
      size = 40,                                                                                                                                                                                                    
      position = 'left',                                                                                                                                                                                            
    },                                                                                                                                                                                                              
    {                                                                                                                                                                                                               
      elements = {                                                                                                                                                                                                  
        'repl',                                                                                                                                                                                                     
        'console',                                                                                                                                                                                                  
      },                                                                                                                                                                                                            
      size = 10,                                                                                                                                                                                                    
      position = 'bottom',                                                                                                                                                                                          
    },                                                                                                                                                                                                              
  },                                                                                                                                                                                                                
)]]

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

-- nnoremap <silent> <leader>in :lua require('dap-python').test_method()<CR>
-- nnoremap <silent> <leader>if :lua require('dap-python').test_class()<CR>
-- vnoremap <silent> <leader>is <ESC>:lua require('dap-python').debug_selection()<CR>
