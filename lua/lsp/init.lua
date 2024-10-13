local lspconfig = require("lspconfig")
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = { "eslint" },  -- Make sure ESLint is installed
})

require("lsp.diagnostics")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<C-f>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-b>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-a>"] = cmp.mapping.confirm({ select = true }),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "nvim_lsp", group_index = 2 },
        { name = "copilot", group_index = 2 },
        { name = "path", group_index = 2 },
        { name = "luasnip", group_index = 2 },
        { name = "vim-dadbod-completion", priority = 700 },
        { name = "crates" },
    },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local function on_attach(client, bufnr)
    if not client then
        vim.notify("LSP client initialization failed", vim.log.levels.ERROR)
        return
    end

    local buf_set_keymap = function(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local opts = { noremap = true, silent = true }
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gl", '<cmd>lua vim.diagnostic.open_float(nil, {focus=false, scope="line"})<CR>', opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("v", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
end

local function setup_lsp(name, opts)
    opts = opts or {}
    opts.on_attach = on_attach
    opts.capabilities = capabilities
    opts.on_exit = function(code, signal, client_id)
        local client = vim.lsp.get_client_by_id(client_id)
        if not client then
            vim.notify("LSP client is nil on exit", vim.log.levels.ERROR)
            print("Exit code:", code, "Signal:", signal, "Client ID:", client_id)
            return
        end
    end
    vim.schedule(function()
        lspconfig[name].setup(opts)
    end)
end

setup_lsp("pyright", {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
            },
        },
    },
})

setup_lsp("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                loadOutDirsFromCheck = true,
            },
            procMacro = {
                enable = true,
            },
            checkOnSave = {
                command = "clippy",
            },
        },
    },
})

setup_lsp("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim", "use" },
            },
        },
    },
})

setup_lsp("vtsls", {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = {
        ["textDocument/definition"] = function(err, result, method, ...)
            if vim.tbl_islist(result) and #result > 1 then
                local filtered_result = {}
                for _, value in ipairs(result) do
                    if not string.match(value.targetUri, "react/index.d.ts") then
                        table.insert(filtered_result, value)
                    end
                end
                return vim.lsp.handlers["textDocument/definition"](nil, filtered_result, method, ...)
            else
                return vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
            end
        end,
    },
    settings = {
        -- Enable TypeScript settings here
        typescript = {
            diagnosticOptions = {
                noUnusedLocals = false,  -- Turn off TypeScript's unused local diagnostics
                noUnusedParameters = false,  -- Turn off TypeScript's unused parameter diagnostics
            },
            eslint = {
                enable = true,  -- Enable ESLint integration
            },
        },
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = {},
        tsserver_path = nil,
        tsserver_plugins = {},
        tsserver_max_memory = "auto",
        tsserver_format_options = {},
        tsserver_file_preferences = {},
        tsserver_locale = "en",
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        code_lens = "off",
        disable_member_code_lens = true,
        jsx_close_tag = {
            enable = false,
            filetypes = { "javascriptreact", "typescriptreact" },
        },
    },
})

setup_lsp("eslint", {})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
})

require("formatter").setup({
    filetype = {
        javascript = function()
            return {
                exe = "prettier",
                args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
                stdin = true,
            }
        end,
        typescript = function()
            return {
                exe = "prettier",
                args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
                stdin = true,
            }
        end,
    },
})
