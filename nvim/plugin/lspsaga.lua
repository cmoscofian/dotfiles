local status, saga = pcall(require, "lspsaga")
if not status then
    return
end

saga.init_lsp_saga {
    use_saga_diagnostic_sign = true,
    error_sign = "",
    warn_sign = "",
    hint_sign = "",
    infor_sign = "",
    dianostic_header_icon = "   ",
    code_action_icon = " ",
    code_action_prompt = {
        enable = true,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
    },
    finder_definition_icon = "  ",
    finder_reference_icon = "  ",
    max_preview_lines = 10,
    finder_action_keys = {
        open = "<cr>",
        quit = "<esc>",
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
        split = "s",
        vsplit = "v",
    },
    code_action_keys = {
        exec = "<cr>",
        quit = "<esc>",
    },
    rename_action_keys = {
        exec = "<cr>",
        quit = "<esc>",
    },
    definition_preview_icon = "  ",
    border_style = "round",
    rename_prompt_prefix = "",
    server_filetype_map = {},
}
