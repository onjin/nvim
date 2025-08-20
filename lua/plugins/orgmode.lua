-- lua/plugins/orgmode.lua
return {
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      -- Setup orgmode
      local orgmode = require "orgmode"
      local cwd = vim.fn.getcwd()
      local function get_agenda_files()
        local agenda_files = { vim.fn.expand "~/notes" .. "/**/*" }

        -- Add current project if in workspace
        local current_org = vim.fn.glob(cwd .. "/docs/*.org", false, true)
        vim.list_extend(agenda_files, current_org)

        return agenda_files
      end

      orgmode.setup {
        org_agenda_files = get_agenda_files(),
        org_default_notes_file = "~/notes/inbox.org",
        org_todo_keywords = { "TODO", "NEXT", "IN-PROGRESS", "WAITING", "|", "DONE", "CANCELLED" },
        -- Performance optimizations
        org_agenda_span = "week",
        org_agenda_start_day = "-3d", -- Show 3 days back
        org_agenda_skip_scheduled_if_done = true,
        org_agenda_skip_deadline_if_done = true,
        org_agenda_inhibit_startup = true, -- Don't run startup hooks for agenda

        -- Cache settings for better performance
        org_agenda_files_cache = true,
        org_capture_templates = {
          t = {
            description = "Task",
            template = "* TODO %?\n  SCHEDULED: %t",
            target = "~/notes/todo.org",
          },
          p = {
            description = "Project",
            template = "* %?\n  %u\n  :CATEGORY: Project",
            target = "~/notes/todo.org",
          },
          a = {
            description = "Area",
            template = "* %?\n  %u\n  :CATEGORY: Area",
            target = "~/notes/todo.org",
          },
          r = {
            description = "Resource",
            template = "* %?\n  %u\n  :CATEGORY: Resource",
            target = "~/notes/todo.org",
          },
          T = {
            description = "Project Task",
            template = "* TODO %?\n  :PROPERTIES:\n  :PROJECT: %^{Project}\n  :END:\n  SCHEDULED: %t",
            target = cwd .. "/docs/project.org",
          },
          M = {
            description = "Project Meeting",
            template = "* MEETING %? :meeting:\n  SCHEDULED: %t\n** Attendees\n** Agenda\n** Notes\n** Action Items",
            target = cwd .. "/docs/project.org",
          },
        },
        mappings = {
          global = {
            org_agenda = "<Leader>oa",
            org_capture = "<Leader>oc",
          },
        },
      }

      -- Dynamic agenda file management (after setup)
      local function update_agenda_files()
        local agenda_files = get_agenda_files()

        -- Update orgmode configuration
        require("orgmode.config").org_agenda_files = agenda_files
      end

      -- Update agenda files on directory change
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          vim.defer_fn(update_agenda_files, 100)
        end,
      })

      -- Initial update
      vim.defer_fn(update_agenda_files, 500)

      -- Org-mode specific keymaps
      vim.keymap.set("n", "<leader>oa", function()
        -- Force update agenda files before opening
        vim.defer_fn(function()
          require("orgmode").action "agenda.prompt"
        end, 100)
      end, { desc = "Org Agenda" })
      vim.keymap.set(
        "n",
        "<leader>oc",
        '<cmd>lua require("orgmode").action("capture.prompt")<CR>',
        { desc = "Org Capture" }
      )
      vim.keymap.set(
        "n",
        "<leader>ol",
        '<cmd>Telescope find_files search_dirs={"~/notes"} find_command=rg,--files,--glob,*.org<CR>',
        { desc = "Find Org Files" }
      )

      -- Project-specific org commands (updated for NAS path)
      vim.keymap.set("n", "<leader>opo", function()
        local project_root = vim.fn.getcwd()
        local org_file = project_root .. "/docs/project.org"

        -- Create docs directory if it doesn't exist
        vim.fn.mkdir(project_root .. "/docs", "p")

        -- Create basic project.org template if it doesn't exist
        if vim.fn.filereadable(org_file) == 0 then
          local project_name = vim.fn.fnamemodify(project_root, ":t")
          local hostname = vim.fn.hostname()
          local template = {
            "#+TITLE: " .. project_name,
            "#+AUTHOR: " .. vim.fn.expand "$USER",
            "#+DATE: " .. os.date "%Y-%m-%d",
            "#+PROPERTY: HOSTNAME " .. hostname,
            "",
            "* Project Overview",
            "** Description",
            "",
            "** Goals",
            "",
            "* Tasks",
            "** TODO Setup project structure",
            "   SCHEDULED: <" .. os.date "%Y-%m-%d" .. ">",
            "   :PROPERTIES:",
            "   :CREATED: [" .. os.date "%Y-%m-%d %H:%M" .. "]",
            "   :HOST: " .. hostname,
            "   :END:",
            "",
            "* Notes",
            "",
            "* Meetings",
            "",
          }

          local file = io.open(org_file, "w")
          if file then
            for _, line in ipairs(template) do
              file:write(line .. "\n")
            end
            file:close()
          end
        end

        vim.cmd("edit " .. org_file)
      end, { desc = "Open Project Org File" })

      -- Fast workspace project switcher (avoids full directory scan)
      vim.keymap.set("n", "<leader>opw", function()
        local workspace = vim.fn.expand "~/Workspace/p"
        vim.notify(workspace)

        -- Use telescope for fast project switching
        require("telescope.builtin").find_files {
          prompt_title = "Workspace Projects",
          cwd = workspace,
          find_command = {
            "rg",
            "--files",
            "-d",
            "6",
            "-g",
            "*.org",
            -- "|",
            -- "sed",
            -- "-E",
            -- "'s#/docs/.*##' ",
            -- "|",
            -- "sort",
            -- "-u",
          },
          attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", function()
              local selection = require("telescope.actions.state").get_selected_entry()
              require("telescope.actions").close(prompt_bufnr)

              -- Change to project directory and open org file
              vim.notify(selection.path)
              local project_dir = vim.fn.fnamemodify(selection.path, ":h:h")
              vim.notify(project_dir)
              vim.cmd("cd " .. project_dir)
              vim.cmd("edit " .. selection.path)
            end)
            return true
          end,
        }
      end, { desc = "Switch Workspace Project" })

      -- Integration with your existing todo.txt workflow
      vim.keymap.set("n", "<leader>opt", function()
        local project_root = vim.fn.getcwd()
        local todo_file = project_root .. "/todo.txt"

        if vim.fn.filereadable(todo_file) == 1 then
          vim.cmd("edit " .. todo_file)
        else
          -- Suggest creating org file instead
          vim.ui.select({ "Create todo.txt", "Create project.org" }, {
            prompt = "No todo file found. Create:",
          }, function(choice)
            if choice == "Create todo.txt" then
              vim.cmd("edit " .. todo_file)
            elseif choice == "Create project.org" then
              vim.fn.feedkeys("<leader>opo", "n")
            end
          end)
        end
      end, { desc = "Open Project Todo" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "org" })
      else
        opts.ensure_installed = { "org" }
      end
    end,
  },
  {
    "akinsho/org-bullets.nvim",
    ft = "org",
    config = function()
      require("org-bullets").setup {
        symbols = {
          headlines = { "◉", "○", "✸", "✿" },
          checkboxes = {
            half = { "", "OrgTSCheckboxHalfChecked" },
            done = { "✓", "OrgTSCheckboxChecked" },
            todo = { "˽", "OrgTSCheckboxUnchecked" },
          },
        },
      }
    end,
  },
  {
    "chipsenkbeil/org-roam.nvim",
    tag = "0.1.1",
    dependencies = {
      {
        "nvim-orgmode/orgmode",
      },
    },
    config = function()
      require("org-roam").setup({
        directory = "~/notes/notes/",
        org_files = {
          "~/notes/todo.org",
        },
        extensions = {
          dailies = {
            directory = "journal",
          },
        },
      })
    end
  }
}

-- Optional: Add to lua/plugins/telescope.lua or create lua/plugins/org-telescope.lua
-- {
--   'nvim-telescope/telescope.nvim',
--   optional = true,
--   opts = function()
--     local actions = require('telescope.actions')
--     return {
--       pickers = {
--         find_files = {
--           find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--glob", "*.org" },
--         },
--       },
--       extensions = {
--         orgmode = {
--           -- Add org-specific telescope integration
--         }
--       }
--     }
--   end
-- }
