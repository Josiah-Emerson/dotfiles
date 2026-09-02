local vks = vim.keymap.set

-- neo-tree
vks("n", "<leader>t", "<Cmd>Neotree toggle<CR>", {desc = "[t]oggle tree"})
vks("n", "<leader>nt", "<Cmd>Neotree<CR>", {desc = "switch to neotree from inside file"})

-- lsp help keymaps
vks("n", "<leader>h", "<Cmd>lua vim.lsp.buf.hover()<CR>", {desc = "[h]over info"})
vks("n", "<leader>df", "<Cmd>lua vim.lsp.buf.definition()<CR>", {desc = "[d]e[f]inition"})
vks("n", "<leader>ic", "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>", {desc = "[i]ncoming [c]alls"})
vks("n", "<leader>oc", "<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>", {desc = "[o]utgoing [c]alls"})
vks("n", "<leader>rf", "<Cmd>lua vim.lsp.buf.references()<CR>", {desc = "[r]e[f]erences"})
