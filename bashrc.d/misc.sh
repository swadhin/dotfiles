# Find alias
alias f="find-pdf"

# PDF viewer alias
e () {
    zathura "$@" 2>/dev/null &
}

# Pdflatex alias
alias xelatex="xelatex -file-line-error -halt-on-error"
alias pdflatex="pdflatex -file-line-error -halt-on-error"
