-- Review branch changes natively: changed files in the quickfix, per-file diff via gitsigns.
local map = require("config.cheatsheet").map

local function review(base)
    base = (base and base ~= '') and base or 'main'
    local root = vim.trim(vim.fn.system({ 'git', 'rev-parse', '--show-toplevel' }))
    if vim.v.shell_error ~= 0 then
        return vim.notify('Not in a git repo', vim.log.levels.ERROR)
    end
    local mb = vim.trim(vim.fn.system({ 'git', 'merge-base', base, 'HEAD' }))
    if vim.v.shell_error ~= 0 then
        return vim.notify('No merge-base with ' .. base, vim.log.levels.ERROR)
    end
    local items = {}
    for _, line in ipairs(vim.fn.systemlist({ 'git', '-C', root, 'diff', '--name-status', mb })) do
        local status, path = line:match('^(%S+)%s+(.+)$')
        if path then
            items[#items + 1] = { filename = root .. '/' .. path, text = status }
        end
    end
    -- git diff ignores untracked files; list new files explicitly.
    for _, path in ipairs(vim.fn.systemlist({ 'git', '-C', root, 'ls-files', '--others', '--exclude-standard' })) do
        items[#items + 1] = { filename = root .. '/' .. path, text = 'A' }
    end
    if #items == 0 then
        return vim.notify('No changes vs ' .. base, vim.log.levels.INFO)
    end
    vim.g.review_base = mb
    require('gitsigns').change_base(mb, true)
    vim.fn.setqflist({}, ' ', { title = 'Review vs ' .. base, items = items })
    vim.cmd('copen | cfirst')
end

local function review_reset()
    vim.g.review_base = nil
    require('gitsigns').change_base(nil, true)
    vim.notify('Review base reset to index', vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('Review', function(o) review(o.args) end, { nargs = '?' })
vim.api.nvim_create_user_command('ReviewReset', review_reset, {})
map('n', '<leader>vr', '<cmd>Review<CR>', { desc = 'Review branch changes' })
map('n', '<leader>vR', '<cmd>ReviewReset<CR>', { desc = 'Reset review base to index' })
map('n', '<leader>vd', function() require('gitsigns').diffthis(vim.g.review_base) end,
    { desc = 'Diff current file vs review base' })
map('n', ']h', function() require('gitsigns').nav_hunk('next') end, { desc = 'Next hunk' })
map('n', '[h', function() require('gitsigns').nav_hunk('prev') end, { desc = 'Prev hunk' })
