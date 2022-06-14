local util = require('util')

vim.g.Tex_DefaultTargetFormat = 'pdf'
vim.g.Tex_CompileRule_pdf = 'xelatex -interaction=nonstopmode -halt-on-error -synctex=1 $*'
vim.g.Tex_ViewRule_pdf = 'zathura'
vim.g.Tex_GotoError = 0
vim.g.Tex_IgnoreLevel = 10
vim.g.Tex_IgnoredWarnings = {
"Underfull\n",
"Overfull\n",
"specifier changed to\n",
"You have requested\n",
"Missing number, treated as zero.\n",
"There were undefined references\n",
"Citation %.%# undefined\n",
"Latex Font Warning: %s\n",
"Package microtype Warning: %s\n",
"Package pgfplots Warning: %s\n",
}

util.nmap(']s', ':call Tex_ForwardSearchLaTeX()<CR>')
