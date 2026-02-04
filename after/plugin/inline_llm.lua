local ns = vim.api.nvim_create_namespace("inline_llm")
local pending = false

local function clear_ghost()
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end

local function main_show_ghost(text)
  if not text or text == "" then return end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  vim.api.nvim_buf_set_extmark(0, ns, row - 1, col, {
    virt_text = { { text:gsub("\n.*", ""), "Comment" } },
    virt_text_pos = "overlay",
    hl_mode = "combine",
  })
end

local function show_ghost(text)
  if not vim.api.nvim_buf_is_valid(0) then return end
  main_show_ghost(text)
end


local function get_context()
  local line = vim.api.nvim_get_current_line()
  local ft = vim.bo.filetype
  return {
    prompt = line,
    system = "You are an inline code completion engine for " .. ft,
  }
end

local function request_completion()
  if pending then return end
  pending = true
  clear_ghost()

  vim.notify("LLM request sent", vim.log.levels.INFO)

  local ctx = get_context()

  vim.system({
    "curl", "-s",
    "http://localhost:11434/api/generate",
    "-H", "Content-Type: application/json",
    "-d", vim.json.encode({
      model = "qwen2.5-coder:7b-instruct-q5_k_m",
      prompt = ctx.prompt,
      options = {
        temperature = 0.2,
        num_predict = 64,
      },
      stream = false,
    }),
  }, { text = true }, function(res)
  vim.schedule(function()
    pending = false

    if res.code ~= 0 then
      vim.notify("LLM request failed", vim.log.levels.ERROR)
      return
    end

    local ok, json = pcall(vim.json.decode, res.stdout)
    if not ok or not json.response then
      vim.notify("Invalid LLM response", vim.log.levels.ERROR)
      return
    end

    show_ghost(json.response)
  end)
end)

local function accept_completion()
  local marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, { details = true })
  if #marks == 0 then return end

  local text = marks[1][4].virt_text[1][1]
  clear_ghost()
  vim.api.nvim_put({ text }, "c", true, true)
end

-- SAFE KEYMAPS
vim.keymap.set("i", "<A-l>", request_completion, { desc = "LLM inline completion" })
vim.keymap.set("i", "<A-y>", accept_completion, { desc = "Accept LLM completion" })
vim.keymap.set("i", "<Esc>", function()
  clear_ghost()
  return "<Esc>"
end, { expr = true })

vim.keymap.set("n", "<Esc>", clear_ghost)

