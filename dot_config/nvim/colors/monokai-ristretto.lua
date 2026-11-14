-- Monokai Pro Ristretto for Neovim
-- Based on your Ghostty palette

local M = {}

M.colors = {
  bg       = "#2c2525",
  fg       = "#fff1f3",
  red      = "#fd6883",  -- keywords, errors
  green    = "#adda78",  -- strings
  yellow   = "#f9cc6c",  -- numbers, constants
  orange   = "#f38d70",  -- types, classes
  purple   = "#a8a9eb",  -- functions, methods
  cyan     = "#85dacc",  -- variables, builtins
  comment  = "#72696a",  -- comments
  sel      = "#5b5353",  -- selection background
  cursor   = "#c3b7b8",  -- cursor
  dark_red = "#72696a",  -- bright black / line numbers
}

function M.setup()
  local c = M.colors

  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.background      = "dark"
  vim.g.colors_name     = "monokai-ristretto"
  vim.o.termguicolors   = true

  local hi = vim.api.nvim_set_hl

  -- ── Editor ──────────────────────────────────────────────────────────────
  hi(0, "Normal",          { fg = c.fg,      bg = c.bg })
  hi(0, "NormalFloat",     { fg = c.fg,      bg = c.bg })
  hi(0, "NormalNC",        { fg = c.fg,      bg = c.bg })
  hi(0, "SignColumn",      { fg = c.comment, bg = c.bg })
  hi(0, "ColorColumn",     {                 bg = c.sel })
  hi(0, "CursorLine",      {                 bg = c.sel })
  hi(0, "CursorLineNr",    { fg = c.cursor,  bg = c.bg, bold = true })
  hi(0, "LineNr",          { fg = c.comment, bg = c.bg })
  hi(0, "Cursor",          { fg = c.bg,      bg = c.cyan })
  hi(0, "TermCursor",      { fg = c.bg,      bg = c.cyan })
  hi(0, "Visual",          {                 bg = c.sel })
  hi(0, "VisualNOS",       {                 bg = c.sel })
  hi(0, "StatusLine",      { fg = c.fg,      bg = c.sel })
  hi(0, "StatusLineNC",    { fg = c.comment, bg = c.sel })
  hi(0, "WinSeparator",    { fg = c.sel,     bg = c.bg })
  hi(0, "VertSplit",       { fg = c.sel,     bg = c.bg })
  hi(0, "TabLine",         { fg = c.comment, bg = c.sel })
  hi(0, "TabLineFill",     { fg = c.comment, bg = c.sel })
  hi(0, "TabLineSel",      { fg = c.fg,      bg = c.bg })
  hi(0, "Pmenu",           { fg = c.fg,      bg = c.sel })
  hi(0, "PmenuSel",        { fg = c.bg,      bg = c.cyan })
  hi(0, "PmenuSbar",       {                 bg = c.sel })
  hi(0, "PmenuThumb",      {                 bg = c.comment })
  hi(0, "Folded",          { fg = c.comment, bg = c.sel })
  hi(0, "FoldColumn",      { fg = c.comment, bg = c.bg })
  hi(0, "EndOfBuffer",     { fg = c.sel,     bg = c.bg })
  hi(0, "NonText",         { fg = c.comment })
  hi(0, "Whitespace",      { fg = c.sel })
  hi(0, "MatchParen",      { fg = c.yellow,  bg = c.sel, bold = true })
  hi(0, "QuickFixLine",    {                 bg = c.sel })
  hi(0, "Directory",       { fg = c.yellow })
  hi(0, "Title",           { fg = c.orange,  bold = true })
  hi(0, "Search",          { fg = c.bg,      bg = c.yellow })
  hi(0, "IncSearch",       { fg = c.bg,      bg = c.orange })
  hi(0, "Substitute",      { fg = c.bg,      bg = c.red })
  hi(0, "WildMenu",        { fg = c.bg,      bg = c.cyan })
  hi(0, "Question",        { fg = c.green })
  hi(0, "MoreMsg",         { fg = c.green })
  hi(0, "ErrorMsg",        { fg = c.red })
  hi(0, "WarningMsg",      { fg = c.yellow })
  hi(0, "ModeMsg",         { fg = c.fg,      bold = true })
  hi(0, "MsgArea",         { fg = c.fg,      bg = c.bg })
  hi(0, "SpellBad",        { sp = c.red,     undercurl = true })
  hi(0, "SpellCap",        { sp = c.yellow,  undercurl = true })
  hi(0, "SpellRare",       { sp = c.purple,  undercurl = true })
  hi(0, "SpellLocal",      { sp = c.cyan,    undercurl = true })

  -- ── Syntax ──────────────────────────────────────────────────────────────
  hi(0, "Comment",         { fg = c.comment, italic = true })
  hi(0, "Constant",        { fg = c.yellow })
  hi(0, "String",          { fg = c.green })
  hi(0, "Character",       { fg = c.green })
  hi(0, "Number",          { fg = c.yellow })
  hi(0, "Float",           { fg = c.yellow })
  hi(0, "Boolean",         { fg = c.yellow })
  hi(0, "Identifier",      { fg = c.cyan })
  hi(0, "Function",        { fg = c.purple })
  hi(0, "Statement",       { fg = c.red })
  hi(0, "Conditional",     { fg = c.red })
  hi(0, "Repeat",          { fg = c.red })
  hi(0, "Label",           { fg = c.red })
  hi(0, "Operator",        { fg = c.red })
  hi(0, "Keyword",         { fg = c.red })
  hi(0, "Exception",       { fg = c.red })
  hi(0, "PreProc",         { fg = c.green })
  hi(0, "Include",         { fg = c.red })
  hi(0, "Define",          { fg = c.red })
  hi(0, "Macro",           { fg = c.green })
  hi(0, "PreCondit",       { fg = c.green })
  hi(0, "Type",            { fg = c.orange })
  hi(0, "StorageClass",    { fg = c.orange })
  hi(0, "Structure",       { fg = c.orange })
  hi(0, "Typedef",         { fg = c.orange })
  hi(0, "Special",         { fg = c.yellow })
  hi(0, "SpecialChar",     { fg = c.yellow })
  hi(0, "Tag",             { fg = c.red })
  hi(0, "Delimiter",       { fg = c.fg })
  hi(0, "SpecialComment",  { fg = c.comment, italic = true })
  hi(0, "Debug",           { fg = c.red })
  hi(0, "Underlined",      { underline = true })
  hi(0, "Ignore",          { fg = c.comment })
  hi(0, "Error",           { fg = c.red,     bold = true })
  hi(0, "Todo",            { fg = c.yellow,  bold = true })

  -- ── Treesitter ───────────────────────────────────────────────────────────
  hi(0, "@comment",                  { fg = c.comment, italic = true })
  hi(0, "@comment.documentation",    { fg = c.comment, italic = true })
  hi(0, "@keyword",                  { fg = c.red })
  hi(0, "@keyword.function",         { fg = c.red })
  hi(0, "@keyword.operator",         { fg = c.red })
  hi(0, "@keyword.return",           { fg = c.red })
  hi(0, "@keyword.import",           { fg = c.red })
  hi(0, "@conditional",              { fg = c.red })
  hi(0, "@repeat",                   { fg = c.red })
  hi(0, "@exception",                { fg = c.red })
  hi(0, "@operator",                 { fg = c.red })
  hi(0, "@punctuation.delimiter",    { fg = c.fg })
  hi(0, "@punctuation.bracket",      { fg = c.fg })
  hi(0, "@punctuation.special",      { fg = c.yellow })
  hi(0, "@string",                   { fg = c.green })
  hi(0, "@string.escape",            { fg = c.yellow })
  hi(0, "@string.special",           { fg = c.yellow })
  hi(0, "@character",                { fg = c.green })
  hi(0, "@number",                   { fg = c.yellow })
  hi(0, "@float",                    { fg = c.yellow })
  hi(0, "@boolean",                  { fg = c.yellow })
  hi(0, "@constant",                 { fg = c.yellow })
  hi(0, "@constant.builtin",         { fg = c.yellow })
  hi(0, "@constant.macro",           { fg = c.yellow })
  hi(0, "@namespace",                { fg = c.orange })
  hi(0, "@type",                     { fg = c.orange })
  hi(0, "@type.builtin",             { fg = c.orange })
  hi(0, "@type.definition",          { fg = c.orange })
  hi(0, "@type.qualifier",           { fg = c.red })
  hi(0, "@attribute",                { fg = c.yellow })
  hi(0, "@function",                 { fg = c.purple })
  hi(0, "@function.call",            { fg = c.purple })
  hi(0, "@function.builtin",         { fg = c.cyan })
  hi(0, "@function.macro",           { fg = c.purple })
  hi(0, "@method",                   { fg = c.purple })
  hi(0, "@method.call",              { fg = c.purple })
  hi(0, "@constructor",              { fg = c.orange })
  hi(0, "@parameter",                { fg = c.orange })
  hi(0, "@variable",                 { fg = c.fg })
  hi(0, "@variable.builtin",         { fg = c.cyan })
  hi(0, "@field",                    { fg = c.cyan })
  hi(0, "@property",                 { fg = c.cyan })
  hi(0, "@tag",                      { fg = c.red })
  hi(0, "@tag.delimiter",            { fg = c.comment })
  hi(0, "@tag.attribute",            { fg = c.orange })
  hi(0, "@text",                     { fg = c.fg })
  hi(0, "@text.emphasis",            { italic = true })
  hi(0, "@text.strong",              { bold = true })
  hi(0, "@text.uri",                 { fg = c.green, underline = true })
  hi(0, "@text.title",               { fg = c.orange, bold = true })
  hi(0, "@text.literal",             { fg = c.green })
  hi(0, "@text.reference",           { fg = c.purple })
  hi(0, "@label",                    { fg = c.cyan })

  -- ── LSP semantic tokens ──────────────────────────────────────────────────
  hi(0, "@lsp.type.class",           { fg = c.orange })
  hi(0, "@lsp.type.decorator",       { fg = c.yellow })
  hi(0, "@lsp.type.enum",            { fg = c.orange })
  hi(0, "@lsp.type.enumMember",      { fg = c.yellow })
  hi(0, "@lsp.type.function",        { fg = c.purple })
  hi(0, "@lsp.type.interface",       { fg = c.orange })
  hi(0, "@lsp.type.keyword",         { fg = c.red })
  hi(0, "@lsp.type.method",          { fg = c.purple })
  hi(0, "@lsp.type.namespace",       { fg = c.orange })
  hi(0, "@lsp.type.parameter",       { fg = c.orange })
  hi(0, "@lsp.type.property",        { fg = c.cyan })
  hi(0, "@lsp.type.struct",          { fg = c.orange })
  hi(0, "@lsp.type.type",            { fg = c.orange })
  hi(0, "@lsp.type.typeParameter",   { fg = c.orange })
  hi(0, "@lsp.type.variable",        { fg = c.fg })

  -- ── Diagnostics ──────────────────────────────────────────────────────────
  hi(0, "DiagnosticError",           { fg = c.red })
  hi(0, "DiagnosticWarn",            { fg = c.yellow })
  hi(0, "DiagnosticInfo",            { fg = c.cyan })
  hi(0, "DiagnosticHint",            { fg = c.green })
  hi(0, "DiagnosticUnderlineError",  { sp = c.red,    undercurl = true })
  hi(0, "DiagnosticUnderlineWarn",   { sp = c.yellow, undercurl = true })
  hi(0, "DiagnosticUnderlineInfo",   { sp = c.cyan,   undercurl = true })
  hi(0, "DiagnosticUnderlineHint",   { sp = c.green,  undercurl = true })
  hi(0, "DiagnosticVirtualTextError",{ fg = c.red,    bg = c.bg })
  hi(0, "DiagnosticVirtualTextWarn", { fg = c.yellow, bg = c.bg })
  hi(0, "DiagnosticVirtualTextInfo", { fg = c.cyan,   bg = c.bg })
  hi(0, "DiagnosticVirtualTextHint", { fg = c.green,  bg = c.bg })

  -- ── Git ───────────────────────────────────────────────────────────────────
  hi(0, "DiffAdd",                   { fg = c.green,  bg = "#2c3422" })
  hi(0, "DiffChange",                { fg = c.yellow, bg = "#332d20" })
  hi(0, "DiffDelete",                { fg = c.red,    bg = "#352428" })
  hi(0, "DiffText",                  { fg = c.fg,     bg = "#3d3422" })
  hi(0, "GitSignsAdd",               { fg = c.green })
  hi(0, "GitSignsChange",            { fg = c.yellow })
  hi(0, "GitSignsDelete",            { fg = c.red })

  -- ── nvim-tree ─────────────────────────────────────────────────────────────
  hi(0, "NvimTreeNormal",            { fg = c.fg,  bg = c.bg })
  hi(0, "NvimTreeFolderName",        { fg = c.yellow })
  hi(0, "NvimTreeOpenedFolderName",  { fg = c.yellow, bold = true })
  hi(0, "NvimTreeRootFolder",        { fg = c.orange, bold = true })
  hi(0, "NvimTreeGitDirty",          { fg = c.yellow })
  hi(0, "NvimTreeGitNew",            { fg = c.green })
  hi(0, "NvimTreeGitDeleted",        { fg = c.red })
  hi(0, "NvimTreeSpecialFile",       { fg = c.cyan })
  hi(0, "NvimTreeIndentMarker",      { fg = c.comment })

  -- ── fzf-lua ──────────────────────────────────────────────────────────────
  hi(0, "FzfLuaNormal",              { fg = c.fg,      bg = c.bg })
  hi(0, "FzfLuaBorder",              { fg = c.sel,     bg = c.bg })
  hi(0, "FzfLuaTitle",               { fg = c.bg,      bg = c.orange, bold = true })
  hi(0, "FzfLuaPreviewNormal",       { fg = c.fg,      bg = c.bg })
  hi(0, "FzfLuaPreviewBorder",       { fg = c.sel,     bg = c.bg })
  hi(0, "FzfLuaPreviewTitle",        { fg = c.bg,      bg = c.green,  bold = true })
  hi(0, "FzfLuaCursor",              { fg = c.bg,      bg = c.cursor })
  hi(0, "FzfLuaCursorLine",          {                 bg = c.sel })
  hi(0, "FzfLuaCursorLineNr",        { fg = c.cursor,  bold = true })
  hi(0, "FzfLuaSearch",              { fg = c.yellow,  bold = true })
  hi(0, "FzfLuaScrollBorderEmpty",   { fg = c.comment })
  hi(0, "FzfLuaScrollBorderFull",    { fg = c.purple })
  hi(0, "FzfLuaHelpNormal",          { fg = c.fg,      bg = c.sel })
  hi(0, "FzfLuaHeaderBind",          { fg = c.cyan })
  hi(0, "FzfLuaHeaderText",          { fg = c.orange })

  -- ── Which-key ────────────────────────────────────────────────────────────
  hi(0, "WhichKey",                  { fg = c.cyan })
  hi(0, "WhichKeyGroup",             { fg = c.orange })
  hi(0, "WhichKeyDesc",              { fg = c.fg })
  hi(0, "WhichKeySeparator",         { fg = c.comment })
  hi(0, "WhichKeyFloat",             { bg = c.sel })

  -- ── Indent Blankline ─────────────────────────────────────────────────────
  hi(0, "IblIndent",                 { fg = c.sel })
  hi(0, "IblScope",                  { fg = c.comment })

  -- ── Lualine (use colorscheme = "auto" or reference these groups) ─────────
  hi(0, "lualine_a_normal",          { fg = c.bg,  bg = c.purple, bold = true })
  hi(0, "lualine_a_insert",          { fg = c.bg,  bg = c.green,  bold = true })
  hi(0, "lualine_a_visual",          { fg = c.bg,  bg = c.orange, bold = true })
  hi(0, "lualine_a_replace",         { fg = c.bg,  bg = c.red,    bold = true })
  hi(0, "lualine_a_command",         { fg = c.bg,  bg = c.yellow, bold = true })
  hi(0, "lualine_b_normal",          { fg = c.fg,  bg = c.sel })
  hi(0, "lualine_c_normal",          { fg = c.comment, bg = c.bg })
end

M.setup()

return M
