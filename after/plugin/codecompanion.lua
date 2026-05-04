require("codecompanion").setup({
  strategies = {
    chat   = { adapter = "lmstudio" },
    inline = { adapter = "lmstudio" },
    agent  = { adapter = "lmstudio" },
  },

  adapters = {
    http = {
      -- Don't auto-load Copilot/OpenAI/Anthropic/etc. on startup
      opts = {
        show_defaults = false,
      },

      -- Default LM Studio adapter
      lmstudio = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          env = {
            url = "http://localhost:1234",
            api_key = "lm-studio",          -- LM Studio ignores this, but a value is required
            chat_url = "/v1/chat/completions",
            models_endpoint = "/v1/models",
          },
          schema = {
            model = {
              default = "qwen/qwen3.5-9b",
            },
          },
        })
      end,

      -- Commit adapter (constrained for short, focused output)
      lmstudio_commit = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          env = {
            url = "http://localhost:1234",
            api_key = "lm-studio",
            chat_url = "/v1/chat/completions",
            models_endpoint = "/v1/models",
          },
          schema = {
            model = {
              default = "qwen/qwen3.5-9b",
            },
            temperature = {
              default = 0.2,
            },
            max_completion_tokens = {
              default = 300,
            },
          },
        })
      end,
    },
  },

  prompt_library = {
    ["Commit"] = {
      strategy = "chat",
      description = "Generate a conventional git commit message",
      opts = {
        index = 10,
        is_slash_cmd = false,
        auto_submit = true,
        adapter = "lmstudio_commit",
      },
      prompts = {
        {
          role = "system",
          content = [[
You are a Git commit message generator.

STRICT RULES:
- Output ONLY the commit message.
- No markdown.
- No explanations.
- No headings.
- No code blocks.
- Do not repeat the diff.

FORMAT:
<type>(<scope>): <subject>

(blank line)
- bullet point
- bullet point

ALLOWED TYPES:
feat, fix, refactor, chore, docs, style, test, build, ci
]],
        },
        {
          role = "user",
          content = function()
            local diff = vim.fn.system("git diff --cached")
            if diff == "" then
              return "Respond with: chore: no changes staged"
            end
            return diff
          end,
          opts = { contains_code = true },
        },
      },
    },
  },
})

-- KEYBINDINGS

-- 1. Git Commit Message
vim.keymap.set("n", "<leader>gm", "<cmd>CodeCompanionCmd commit<cr>", { noremap = true, silent = true, desc = "Generate Git Commit" })

-- 2. Inline "Fix/Modify" (Visual Mode)
vim.keymap.set("v", "<leader>ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true, desc = "CodeCompanion Actions" })

-- 3. Toggle Chat Sidebar
vim.keymap.set({ "n", "v" }, "<leader>ch", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })

-- 4. Quick Inline Prompt (Normal Mode)
vim.keymap.set("n", "<leader>ci", "<cmd>CodeCompanion<cr>", { noremap = true, silent = true, desc = "Inline AI Prompt" })
