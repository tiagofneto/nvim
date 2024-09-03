return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                rust = { "rustfmt", lsp_format = "fallback" },
                javascript = { "prettierd", "prettier", stop_after_first = true }
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
        })
    end
}
