local cc_adapters = require("codecompanion.adapters")
cc_adapters.copilot = nil

-- CodeCompanion setup
require("codecompanion").setup({
  enabled_adapters = {
    "ollama",
    "ollama_commit",
  },

  strategies = {
    chat   = { adapter = "ollama" },
    inline = { adapter = "ollama" },
    agent  = { adapter = "ollama" },
  },

  adapters = {
    -- Default Ollama adapter
    ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        options = {
          model = "qwen2.5-coder:14b-instruct-q4_k_m",
        },
      })
    end,

    -- Commit adapter (HEADLESS + constrained)
    ollama_commit = function()
      return require("codecompanion.adapters").extend("ollama", {
        options = {
          model = "qwen2.5-coder:14b-instruct-q4_k_m",
        },
        parameters = {
          num_predict = 300,
          temperature = 0.2,
          stop = { "```", "##", "\n\n\n" },
        },
      })
    end,
  },

  prompt_library = {
    ["Commit"] = {
      strategy = "chat",
      description = "Generate a conventional git commit message",
      opts = {
        index = 10,
        is_slash_cmd = false,
        auto_submit = true,
        adapter = "ollama_commit",
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
vim.keymap.set("n", "<leader>ci", "<cmd>CodeCompanion<cr>", { noremap = true, silent = true, desc = "Inline AI Prompt" })-- Map <C-a> (or your choice) to trigger the inline assistant
