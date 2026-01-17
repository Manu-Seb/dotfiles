-- lua/plugins/lsp.lua
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Core LSP & Installer
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        -- Autocompletion
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",

        -- Snippets
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",

        -- Formatting & Linting
        "stevearc/conform.nvim",
        "nvimtools/none-ls.nvim",

        -- Debugging
        "mfussenegger/nvim-dap",
    },
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Mason setup
        require("mason").setup({})
        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettier",
                "eslint_d",
                "codelldb",
            },
        })

        -- Conform (Prettier formatting)
        require("conform").setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                lua = { "stylua" },
                rust = { "rustfmt" },
            },
            formatters = {
                stylua = {
                    prepend_args = { "--indent-width", "4", "--indent-type", "Spaces" },
                },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = false,
            },
        })

        -- Mason-LSPConfig (LSP servers only)
        require("mason-lspconfig").setup({
            ensure_installed = {
                "html",
                "cssls",
                "jsonls",
                "bashls",
                "marksman",
                "lua_ls",
                "intelephense",
                "ts_ls",
                "pyright",
                "rust_analyzer",
            },
            handlers = {
                -- Default handler for all servers
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            -- Disable LSP formatting (conform handles it)
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                        end,
                    })
                end,

                -- Custom overrides
                lua_ls = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "LuaJIT" },
                                diagnostics = { globals = { "vim" } },
                                workspace = { library = { vim.env.VIMRUNTIME } },
                            },
                        },
                    })
                end,

                rust_analyzer = function()
                    require("lspconfig").rust_analyzer.setup({
                        capabilities = capabilities,
                        settings = {
                            ["rust-analyzer"] = {
                                checkOnSave = { command = "clippy" },
                            },
                        },
                    })
                end,

                ts_ls = function()
                    require("lspconfig").ts_ls.setup({
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                        end,
                    })
                end,
            },
        })

        -- LSP UI & Diagnostics
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = { style = "minimal", border = "rounded", header = "", prefix = "" },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "✘",
                    [vim.diagnostic.severity.WARN] = "▲",
                    [vim.diagnostic.severity.HINT] = "⚑",
                    [vim.diagnostic.severity.INFO] = "»",
                },
            },
        })

        -- LSP Keymaps (on LspAttach)
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(event)
                local opts = { buffer = event.buf, noremap = true, silent = true }

                -- Core LSP mappings
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = event.buf })
                vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
                vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)

                -- Manual format (uses conform)
                vim.keymap.set({ "n", "v" }, "<leader>lf", function()
                    require("conform").format({ async = true, lsp_fallback = false })
                end, opts)
            end,
        })

        -- nvim-cmp setup
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()

        vim.opt.completeopt = { "menu", "menuone", "noselect" }

        cmp.setup({
            preselect = cmp.PreselectMode.Item,
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer", keyword_length = 3 },
                { name = "path" },
            }),
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            formatting = {
                fields = { "abbr", "menu", "kind" },
                format = function(entry, item)
                    item.menu = ({
                        nvim_lsp = "[LSP]",
                        luasnip = "[SNIP]",
                        buffer = "[BUF]",
                        path = "[PATH]",
                    })[entry.source.name]
                    return item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            }),
        })

        -- DAP (Debug Adapter Protocol)
        local dap = require("dap")

        -- CodeLLDB adapter for Rust/C++
        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                args = { "--port", "${port}" },
            },
        }

        -- Rust configuration
        dap.configurations.rust = {
            {
                name = "Launch (CodeLLDB)",
                type = "codelldb",
                request = "launch",
                program = function()
                    local exe = vim.fn.getcwd() .. "/target/debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                    if vim.fn.executable(exe) == 1 then
                        return exe
                    end
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
        }

        -- DAP keymaps
        vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>B", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "DAP: Conditional Breakpoint" })
        vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP: REPL" })
        vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "DAP: Terminate" })
    end,
}
