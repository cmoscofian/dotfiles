local status, cmp = pcall(require, "cmp")
if not status then
    return
end

local status, lspkind = pcall(require, "lspkind")
if not status then
    return
end

cmp.setup {
    snippet = {
        expand = function(args)
            P(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<enter>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "buffer", keyword_length = 5 },
    },
    experimental = {
        native_menu = false,
        ghost_text = true,
    },
    formatting = {
        format = lspkind.cmp_format {
            with_text = true,
            maxwidth = 50,
            menu = {
                nvim_lsp = "[lsp]",
                vsnip = "[vsnip]",
                buffer = "[buffer]",
            },
        },
    },
}
