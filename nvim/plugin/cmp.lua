local status, cmp = pcall(require, "cmp")
if not status then
    return
end

local status, luasnip = pcall(require, "luasnip")
if not status then
    return
end

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<c-k>"] = cmp.mapping.select_prev_item(),
        ["<c-j>"] = cmp.mapping.select_next_item(),
        ["<c-space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
        ["<cr>"] = cmp.mapping.confirm { select = true },
        ["<tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, { "i", "s", }),
        ["<s-tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s", }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer", keyword_length = 5 },
        { name = "nvim_lua" },
    },
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, item)
            item.kind = string.format("%s %s", icons[item.kind], item.kind)
            item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
            })[entry.source.name]
            return item
        end,
    },
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    experimental = {
        native_menu = false,
        ghost_text = true,
    },
}
