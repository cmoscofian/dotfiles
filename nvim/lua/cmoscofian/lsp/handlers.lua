local M = {}

M.on_rename = function(cnfg)
    vim.validate {
        cnfg = { cnfg, "table", true }
    }

    local create_qf_item = function(bufnr, text_edit)
        local line_number = text_edit.range.start.line
        local texts = vim.api.nvim_buf_get_lines(bufnr, line_number, line_number+1, false)
        return {
            bufnr = bufnr,
            lnum = line_number+1,
            col = text_edit.range.start.character+1,
            text = texts[1],
        }
    end

    local handler = function(err, workspace_edit, _, _)
        if err then
            print(err)
        end

        if not workspace_edit then
            return
        end

        vim.lsp.util.apply_workspace_edit(workspace_edit)

        local entries = setmetatable({}, {})
        if workspace_edit.changes then
            for uri, text_edits in pairs(workspace_edit.changes) do
                local bufnr = vim.uri_to_bufnr(uri)
                for _, text_edit in ipairs(text_edits) do
                    local item = create_qf_item(bufnr, text_edit)
                    table.insert(entries, item)
                end
            end
        end

        if workspace_edit.documentChanges then
            if not workspace_edit.documentChanges.kind then
                for _, changes in ipairs(workspace_edit.documentChanges) do
                    local bufnr = vim.uri_to_bufnr(changes.textDocument.uri)
                    for _, text_edit in ipairs(changes.edits) do
                        local item = create_qf_item(bufnr, text_edit)
                        table.insert(entries, item)
                    end
                end
            end
        end

        vim.fn.setqflist(entries, 'r')
    end

    local params = vim.lsp.util.make_position_params()
    local new_name = vim.fn.input("New Name: ")
    if not new_name or new_name == nil or new_name == "" then
        return
    end
    params.newName = new_name

    vim.lsp.buf_request(0, "textDocument/rename", params, handler)
end

return M
