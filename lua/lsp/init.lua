local lspconfig = require('lspconfig')
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
require('mason').setup({})

-- Setup cmp with your specified mappings and sources
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-f>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<C-a>'] = cmp.mapping.confirm({ select = true }),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
  },
  sources = {
    { name = "nvim_lsp", group_index = 2 },
    { name = "copilot", group_index = 2 },
    { name = "path", group_index = 2 },
    { name = "luasnip", group_index = 2 },
  }
})

-- Enhanced server capabilities for nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Common on_attach function for LSP servers
local function on_attach(client, bufnr)
  local buf_set_keymap = function(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }
  -- Key mappings
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gl', '<cmd>lua vim.diagnostic.open_float(nil, {focus=false, scope="line"})<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('v', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

-- Python LSP configuration
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  }
})

-- Lua LSP setup (sumneko_lua)
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim', 'use'}
      }
    }
  }
})

-- TypeScript custom handler setup (you can uncomment or adjust as needed)
require("typescript-tools").setup {
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ['textDocument/definition'] = function(err, result, method, ...)
      if vim.tbl_islist(result) and #result > 1 then
        local filtered_result = {}
        for _, value in ipairs(result) do
          if not string.match(value.targetUri, 'react/index.d.ts') then
            table.insert(filtered_result, value)
          end
        end
        return vim.lsp.handlers['textDocument/definition'](nil, filtered_result, method, ...)
      else
        return vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
      end
    end
  },
  settings = {
    -- spawn additional tsserver instance to calculate diagnostics on it
    separate_diagnostic_server = true,
    -- "change"|"insert_leave" determine when the client asks the server about diagnostic
    publish_diagnostic_on = "insert_leave",
    -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
    -- "remove_unused_imports"|"organize_imports") -- or string "all"
    -- to include all supported code actions
    -- specify commands exposed as code_actions
    expose_as_code_action = {},
    -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
    -- not exists then standard path resolution strategy is applied
    tsserver_path = nil,
    -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
    -- (see 💅 `styled-components` support section)
    tsserver_plugins = {},
    -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
    -- memory limit in megabytes or "auto"(basically no limit)
    tsserver_max_memory = "auto",
    -- described below
    tsserver_format_options = {},
    tsserver_file_preferences = {},
    -- locale of all tsserver messages, supported locales you can find here:
    -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
    tsserver_locale = "en",
    -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
    complete_function_calls = false,
    include_completions_with_insert_text = true,
    -- CodeLens
    -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
    -- possible values: ("off"|"all"|"implementations_only"|"references_only")
    code_lens = "off",
    -- by default code lenses are displayed on all referencable values and for some of you it can
    -- be too much this option reduce count of them by removing member references from lenses
    disable_member_code_lens = true,
    -- JSXCloseTag
    -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
    -- that maybe have a conflict if enable this feature. )
    jsx_close_tag = {
        enable = false,
        filetypes = { "javascriptreact", "typescriptreact" },
    }
  },
}

require('nvim-ts-autotag').setup()

-- Diagnostic settings
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})

-- Formatter configuration
require('formatter').setup({
  filetype = {
    javascript = function()
      return {
        exe = "prettier",
        args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
        stdin = true
      }
    end,
    typescript = function()
      return {
        exe = "prettier",
        args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
        stdin = true
      }
    end
  }
})


