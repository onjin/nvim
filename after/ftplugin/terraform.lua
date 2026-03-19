local function terraform_fmt(bufnr)
    if vim.fn.executable("terraform") ~= 1 then
        vim.notify("terraform is not available in PATH; skipping terraform fmt", vim.log.levels.WARN, {
            title = "Terraform Format",
        })
        return
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local input = table.concat(lines, "\n")
    if #lines > 0 then
        input = input .. "\n"
    end

    local result = vim.system({ "terraform", "fmt", "-no-color", "-" }, {
        stdin = input,
        text = true,
    }):wait()

    if result.code ~= 0 then
        vim.notify(result.stderr ~= "" and result.stderr or "terraform fmt failed", vim.log.levels.ERROR, {
            title = "Terraform Format",
        })
        return
    end

    local formatted = vim.split(result.stdout or "", "\n", { plain = true })
    if #formatted > 0 and formatted[#formatted] == "" then
        table.remove(formatted, #formatted)
    end

    if vim.deep_equal(lines, formatted) then
        return
    end

    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
    vim.fn.winrestview(view)
end

local function setup_terraform_format_on_save(bufnr)
    local group_name = ("my.terraform.format.%d"):format(bufnr)
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })

    vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        buffer = bufnr,
        callback = function(args)
            if vim.g.autoformat_on_save_enabled ~= true then
                return
            end

            terraform_fmt(args.buf)
        end,
    })
end

local function setup_terraform_keymaps(bufnr)
    vim.keymap.set("n", "glf", function()
        terraform_fmt(bufnr)
    end, {
        buffer = bufnr,
        silent = true,
        noremap = true,
        desc = "[Terraform] Format buffer with terraform fmt",
    })
end

local bufnr = vim.api.nvim_get_current_buf()
setup_terraform_format_on_save(bufnr)
setup_terraform_keymaps(bufnr)

if not _G.terraform_env_set then
    _G.terraform_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        local enabled = lsp_cfg.is_enabled("terraform", "terraformls")
        local has_terraform_ls = vim.fn.executable("terraform-ls") == 1
        local has_legacy_terraform_lsp = vim.fn.executable("terraform-lsp") == 1
        local has_server = has_terraform_ls or has_legacy_terraform_lsp

        if enabled and has_server then
            vim.lsp.enable("terraformls")
        elseif enabled then
            vim.notify(table.concat({
                "Terraform LSP is not available in PATH.",
                "Expected `terraform-ls` (official) or `terraform-lsp` (legacy).",
                "Debian/Ubuntu: install the upstream `terraform-ls` binary and place it in PATH,",
                "or use `mise use -g terraform-ls@latest` if you manage toolchains with mise.",
                "Nix: add `pkgs.terraform-ls` to your devShell packages or",
                "run `nix profile install nixpkgs#terraform-ls` for a user install.",
            }, "\n"), vim.log.levels.ERROR, { title = "Terraform LSP" })
        end
    end)
end
