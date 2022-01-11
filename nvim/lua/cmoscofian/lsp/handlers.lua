local utils = require("cmoscofian.utils")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")

local build_qf_item = function(uri, range)
    local bufnr = vim.uri_to_bufnr(uri)
    local filename = vim.uri_to_fname(uri)
    local line_number = range.start.line
    local texts = vim.api.nvim_buf_get_lines(bufnr, line_number, line_number+1, false)

    return {
        bufnr = bufnr,
        filename = filename,
        lnum = line_number+1,
        col = range.start.character+1,
        text = utils.trim(texts[1]),
    }
end

local M = {}

M.on_rename = function(use_placeholder)
    vim.validate {
        use_placeholder = { use_placeholder, "boolean", true },
    }

    local on_rename = function(err, workspace_edit)
        if err then
            vim.notify(string.format("[Code: %d][Message: %s]", err.code, err.message), vim.log.levels.WARN)
            return
        end

        if vim.tbl_isempty(workspace_edit) then
            return
        end

        vim.lsp.util.apply_workspace_edit(workspace_edit)

        local entries = {}
        if workspace_edit.changes then
            for uri, text_edits in pairs(workspace_edit.changes) do
                for _, text_edit in ipairs(text_edits) do
                    local item = build_qf_item(uri, text_edit.range)
                    table.insert(entries, item)
                end
            end
        end

        if workspace_edit.documentChanges then
            if not workspace_edit.documentChanges.kind then
                for _, changes in ipairs(workspace_edit.documentChanges) do
                    for _, text_edit in ipairs(changes.edits) do
                        local item = build_qf_item(changes.textDocument.uri, text_edit.range)
                        table.insert(entries, item)
                    end
                end
            end
        end

        vim.fn.setqflist(entries, "r")
    end

    local on_confirm = function(input)
        if not (input and #input > 0) then
            return
        end

        local params = vim.lsp.util.make_position_params()
        params.newName = input
        vim.lsp.buf_request(0, "textDocument/rename", params, on_rename)
    end

    local opts = {
        prompt = "Rename: ",
        default = nil,
    }

    if use_placeholder then
        opts.default = vim.fn.expand("<cword>")
    end

    vim.ui.input(opts, on_confirm)
end

M.on_reference = function(find_tests)
    vim.validate {
        find_tests = { find_tests, "boolean", true }
    }

    local params = vim.lsp.util.make_position_params()
    params.context = { includeDeclaration = true }

    vim.lsp.buf_request(0, "textDocument/references", params, function(err, locations, ctx)
        if err then
            vim.notify(string.format("[Code: %d][Message: %s]", err.code, err.message), vim.log.levels.ERROR)
            return
        end

        if vim.tbl_isempty(locations) then
            return
        end

        if not find_tests then
            local filtered_result = {}
            local ft = vim.api.nvim_buf_get_option(ctx.bufnr, "filetype")

            if ft == "go" then
                filtered_result = vim.tbl_filter(function(f)
                    return not string.find(f.uri, "_test") and not string.find(f.uri, "mock")
                end, locations)
            end

            if ft == "java" then
                filtered_result = vim.tbl_filter(function(f)
                    return not string.find(f.uri, "test") and not string.find(f.uri, "mock")
                end, locations)
            end

            if not vim.tbl_isempty(filtered_result) then
                locations = filtered_result
            end
        end

        local items = vim.lsp.util.locations_to_items(locations)
        if vim.tbl_isempty(items) then
            return
        end

        for i, item in ipairs(items) do
            items[i].text = utils.trim(item.text)
        end
        local reference = vim.fn.expand("<cword>")

        pickers.new({
            finder = finders.new_table {
                entry_maker = make_entry.gen_from_quickfix(),
                results = items,
            },
            initial_mode = "normal",
            previewer = previewers.vim_buffer_qflist.new({}),
            prompt_title = string.format("LSP References for: %s", reference),
            sorter = sorters.get_generic_fuzzy_sorter()
        }):find()
    end)
end

return M
