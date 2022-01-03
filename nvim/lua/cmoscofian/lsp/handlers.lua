local status, utils = pcall(require, "cmoscofian.utils")
if not status then
    return
end

local M = {}

M.on_rename = function(use_placeholder)
    vim.validate {
        use_placeholder = { use_placeholder, "boolean", true },
    }

    local build_qf_item = function(bufnr, text_edit)
        local line_number = text_edit.range.start.line
        local texts = vim.api.nvim_buf_get_lines(bufnr, line_number, line_number+1, false)

        return {
            bufnr = bufnr,
            lnum = line_number+1,
            col = text_edit.range.start.character,
            text = utils.trim(texts[1]),
        }
    end

    local on_rename = function(err, workspace_edit)
        if err then
            print(err)
            return
        end

        if not workspace_edit then
            return
        end

        vim.lsp.util.apply_workspace_edit(workspace_edit)

        local entries = {}
        if workspace_edit.changes then
            for uri, text_edits in pairs(workspace_edit.changes) do
                local bufnr = vim.uri_to_bufnr(uri)
                for _, text_edit in ipairs(text_edits) do
                    local item = build_qf_item(bufnr, text_edit)
                    table.insert(entries, item)
                end
            end
        end

        if workspace_edit.documentChanges then
            if not workspace_edit.documentChanges.kind then
                for _, changes in ipairs(workspace_edit.documentChanges) do
                    local bufnr = vim.uri_to_bufnr(changes.textDocument.uri)
                    for _, text_edit in ipairs(changes.edits) do
                        local item = build_qf_item(bufnr, text_edit)
                        table.insert(entries, item)
                    end
                end
            end
        end

        vim.fn.setqflist(entries, 'r')
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

return M
