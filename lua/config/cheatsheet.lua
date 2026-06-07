-- Keybind cheatsheet: `map()` both sets the keymap and records it in a registry.
-- The cheatsheet renders the registry, so there is one source of truth — every
-- map made via `map()` auto-appears here.
local M = {}

local registry = {}     -- ordered list of { mode, lhs, desc }
local index = {}        -- mode..lhs -> registry position (dedup; ftplugin re-runs)
local win = nil

-- Set a keymap and, if it has a desc, record it for the cheatsheet.
-- Buffer-local maps (opts.buffer) are tagged so they only list in that buffer.
function M.map(mode, lhs, rhs, opts)
    opts = opts or {}
    vim.keymap.set(mode, lhs, rhs, opts)
    if opts.desc and opts.desc ~= '' then
        local buf = opts.buffer
        if buf == true then buf = vim.api.nvim_get_current_buf() end
        local key = mode .. lhs .. (buf or '')
        local entry = { mode = mode, lhs = lhs, desc = opts.desc, buf = buf or nil }
        if index[key] then
            registry[index[key]] = entry
        else
            registry[#registry + 1] = entry
            index[key] = #registry
        end
    end
end

local mode_labels = { n = 'Normal', i = 'Insert', v = 'Visual', x = 'Visual block', t = 'Terminal' }

local function render_lines()
    local cur = vim.api.nvim_get_current_buf()
    local groups = {}
    for _, e in ipairs(registry) do
        if not e.buf or e.buf == cur then
            groups[e.mode] = groups[e.mode] or {}
            table.insert(groups[e.mode], e)
        end
    end
    local lines, width = {}, 0
    for _, mode in ipairs({ 'n', 'i', 'v', 'x', 't' }) do
        local entries = groups[mode]
        if entries then
            table.sort(entries, function(a, b) return a.lhs < b.lhs end)
            if #lines > 0 then lines[#lines + 1] = '' end
            lines[#lines + 1] = '  ' .. (mode_labels[mode] or mode)
            local pad = 0
            for _, e in ipairs(entries) do pad = math.max(pad, #e.lhs) end
            for _, e in ipairs(entries) do
                local line = string.format('  %-' .. pad .. 's  →  %s', e.lhs, e.desc)
                lines[#lines + 1] = line
                width = math.max(width, vim.fn.strdisplaywidth(line))
            end
        end
    end
    return lines, width
end

function M.toggle()
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
        win = nil
        return
    end

    local lines, width = render_lines()
    if #lines == 0 then
        return vim.notify('No keymaps registered', vim.log.levels.INFO)
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].bufhidden = 'wipe'

    width = math.min(width + 2, math.floor(vim.o.columns * 0.9))
    local height = math.min(#lines, math.floor(vim.o.lines * 0.8))
    win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = 'rounded',
        title = ' Cheatsheet ',
        title_pos = 'center',
    })
    vim.wo[win].cursorline = true
    for _, k in ipairs({ 'q', '<Esc>' }) do
        vim.keymap.set('n', k, M.toggle, { buffer = buf, nowait = true })
    end
end

vim.api.nvim_create_user_command('Cheatsheet', M.toggle, { desc = 'Show keybind cheatsheet' })
M.map('n', '<leader>/', M.toggle, { desc = 'Show keybind cheatsheet' })

return M
