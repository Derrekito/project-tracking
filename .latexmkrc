# latexmk configuration for Gantt Charts

# Use LuaLaTeX
$pdf_mode = 4;  # 4 = lualatex
$postscript_mode = 0;
$dvi_mode = 0;

# Output directory (also set via Makefile)
$out_dir = 'build';

# Clean up extensions
$clean_ext = 'aux bbl bcf blg fdb_latexmk fls log out run.xml toc lof lot nav snm vrb';

# For watch mode: use a simple viewer
# Uncomment and modify for your preferred PDF viewer:
# $pdf_previewer = 'zathura %O %S';
# $pdf_previewer = 'evince %O %S';
# $pdf_previewer = 'okular %O %S';

# Silence some warnings
$silent = 0;
$warnings_as_errors = 0;

# Max iterations to resolve references
$max_repeat = 5;
