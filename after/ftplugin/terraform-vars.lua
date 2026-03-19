if not _G.terraform_env_set then
    dofile(vim.fn.stdpath("config") .. "/after/ftplugin/terraform.lua")
end
