local lsp_cfg = require("config.lsp")
local server_cfg = lsp_cfg.get("terraform", "terraformls")

local terraform_cmd = "terraform-ls"
if vim.fn.executable(terraform_cmd) ~= 1 and vim.fn.executable("terraform-lsp") == 1 then
    terraform_cmd = "terraform-lsp"
end

---@type vim.lsp.Config
return {
    cmd = terraform_cmd == "terraform-lsp" and { terraform_cmd } or { terraform_cmd, "serve" },
    filetypes = { "terraform", "terraform-vars" },
    root_markers = {
        ".terraform",
        ".terraform.lock.hcl",
        ".git",
    },
    single_file_support = true,
    settings = server_cfg and vim.deepcopy(server_cfg.settings) or nil,
}
