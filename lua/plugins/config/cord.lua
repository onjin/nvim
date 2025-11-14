local M = {}

M.config = function()
    require('cord').setup({
        log_level = vim.log.levels.WARN,
        enabled = true,
        display = {
            theme = 'catppuccin',
            flavor = 'accent',
        },
        advanced = {
            discord = {
                pipe_paths = {
                    '/run/user/' .. string.format("%s", io.popen('id -u')) .. 'discord-ipc-0',
                },
                reconnect = {
                    enabled = true,
                }
            },
        },
        plugins = {
            ['cord.plugins.visibility'] = {
                precedence = 'blacklist',
                rules = {
                    blacklist = {
                        '~/Workspace/p/cint', -- matches path
                        { type = 'glob', value = '**/sops/**' },
                        -- function example
                        function(ctx) return ctx.workspace == 'secret' end,
                    },
                },
            },
        }
    })
end
return M
