local system = require('llm')

system.setup({
    backend = "ollama",
    -- model = "qwen2.5-coder:7b-base-q5_k_m",
    -- model = "qwen2.5-coder:14b-base-q4_k_m",
    model = "qwen2.5-coder:7b-instruct-q5_k_m",
    url = "http://127.0.0.1:11434", 
    
    accept_keymap = "<A-y>",
    dismiss_keymap = "<A-]>",
    
    lsp = {
        bin_path = "llm-ls",
    },
    
    -- DISABLE FIM TOKENS
    -- We comment this out. Now the model won't use <fim_suffix> tags at all.
    -- It will just write code until it hits the end of the logical block.
    tokens = {
         prefix = "<|fim_prefix|>",
         suffix = "<|fim_suffix|>",
         middle = "<|fim_middle|>",
    },
    
    request_body = { 
        options = { 
            temperature = 0.05, 
            top_p = 0.9, 
            top_k = 40,
            repeat_penalty = 1.05,
            -- num_ctx = 8192,
            num_ctx = 4096,
            num_predict = 128,
            
            -- SIMPLE STOP LIST
            -- Since FIM is off, we only need to stop if it hallucinates a new file
            stop = { 
                "<|endoftext|>", 
                "<|file_separator|>", 
            } 
        } 
    },
    
    -- context_window = 8192, 
    context_window = 4096, 
    enable_suggestions_on_startup = true,
    enable_suggestions_on_files = "*",
})

-- Toggle Keybind
vim.keymap.set("n", "<leader>ta", function()
    local model = "qwen2.5-coder:7b-base-q5_k_m"
    local client = vim.lsp.get_clients({ name = "llm-ls" })[1]
    
    if client then
        vim.lsp.stop_client(client.id)
        vim.fn.system(string.format("curl -s -o /dev/null http://127.0.0.1:11434/api/generate -d '{\"model\": \"%s\", \"keep_alive\": 0}'", model))
        vim.notify("LLM Disabled", vim.log.levels.INFO)
    else
        vim.cmd("doautocmd FileType") 
        vim.notify("LLM Enabled", vim.log.levels.INFO)
    end
end, { desc = "Toggle LLM" })
