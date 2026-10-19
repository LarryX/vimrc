-- Completion (nvim-cmp + LuaSnip) and language servers (built-in LSP, Neovim 0.11+).
-- Loaded from full.vim with `lua require('config.lsp')` when running Neovim.

local ok_cmp, cmp = pcall(require, 'cmp')
local ok_snip, luasnip = pcall(require, 'luasnip')
if ok_cmp and ok_snip then
  require('luasnip.loaders.from_snipmate').lazy_load()   -- honza/vim-snippets

  local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  cmp.setup({
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    completion = { completeopt = 'menu,menuone,noinsert' },
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>']     = cmp.mapping.abort(),
      ['<C-b>']     = cmp.mapping.scroll_docs(-4),
      ['<C-f>']     = cmp.mapping.scroll_docs(4),
      ['<CR>']      = cmp.mapping.confirm({ select = false }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump()
        elseif has_words_before() then cmp.complete()
        else fallback() end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
        else fallback() end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources(
      { { name = 'nvim_lsp' }, { name = 'luasnip' }, { name = 'path' } },
      { { name = 'buffer', option = { get_bufnrs = vim.api.nvim_list_bufs } } }
    ),
    formatting = {
      format = function(entry, item)
        item.menu = ({ nvim_lsp = '[LSP]', luasnip = '[Snip]', buffer = '[Buf]', path = '[Path]' })[entry.source.name]
        return item
      end,
    },
  })
end

-- Language servers (built-in LSP client; no nvim-lspconfig needed)
local caps = vim.lsp.protocol.make_client_capabilities()
local ok_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_lsp then caps = cmp_lsp.default_capabilities(caps) end
vim.lsp.config('*', { capabilities = caps })

local servers = {
  pyright = { cmd = { 'pyright-langserver', '--stdio' }, filetypes = { 'python' },
              root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
              settings = { python = { analysis = { typeCheckingMode = 'basic' } } } },
  bashls  = { cmd = { 'bash-language-server', 'start' }, filetypes = { 'sh', 'bash' },
              root_markers = { '.git' } },
  clangd  = { cmd = { 'clangd' }, filetypes = { 'c', 'cpp', 'cuda' },
              root_markers = { 'compile_commands.json', '.clangd', '.git' } },
}
for name, cfg in pairs(servers) do
  if vim.fn.executable(cfg.cmd[1]) == 1 then
    vim.lsp.config(name, cfg)
    vim.lsp.enable(name)
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspCfg', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if vim.g.lsp_diagnostics ~= 1 and client then
      -- ALE already lints; avoid showing the same problems twice
      vim.diagnostic.enable(false, { bufnr = ev.buf, ns_id = vim.lsp.diagnostic.get_namespace(client.id) })
    end
    local o = { buffer = ev.buf, silent = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, o)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, o)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, o)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, o)
  end,
})
