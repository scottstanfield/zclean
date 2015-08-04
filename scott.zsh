is_mac() { [[ $OSTYPE == darwin* ]] }

alias vz="vi ~/.zshrc"
alias sz="source ~/.zshrc"

# Detect which 'ls' flavor to use
if ls --color > /dev/null 2>&1; then # GNU ls
    lsflag="--color --group-directories-first -F"
else # OS X ls
    lsflag="-GF"
fi
alias ls="command ls ${lsflag}"
alias ll="ls -l ${lsflag}"
alias la="ls -a ${lsflag}"
export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.sh=01;32:*.csh=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:"

alias h="history"
alias vi="vim -p"
alias ,="cd .."
alias m="less"
alias rm='nocorrect rm -vI'
alias gs='git status 2>/dev/null'
alias -- pd='pushd'
alias ag="ag -i"            # make case insensitive searching the default

# Automatically ls after you change directories (cd).
# Comment out this function if it's annoying.
function chpwd() {
	emulate -L zsh
	ls
}

gg() { git commit -m "$*" }
gga() { git add -A && git commit -m "$*" }
ff () { find . -iname "$1*" -print }
take () { mkdir -p $1 && cd $1 }
zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}
ww() { watch "clear; cat $1" }

# BINDKEY 
bindkey "\e[3~" delete-char         # DEL does the right thing
bindkey "\e[1;5D" backward-word     # ⌃← skips back a word
bindkey "\e[1;5C" forward-word      # ⌃→ skips forward a word
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# workaround for zsh "xterm with numeric keypad" ignoring the keypad Enter key
bindkey '^[OM' '^M'

path() {
  echo $PATH | tr ":" "\n" | \
    awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
           sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
           sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
           sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
           sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
           print }"
}

rainbow() {
    for code in {000..255}; do  
        print -P -- "$code: %F{$code}Blackjack%f \t $BG[$code]Blackjack %{$reset_color%}"
    done
}

tophistory() {
	history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head -n 30
}

calc() {
	echo "scale=3;$@" | bc -l
}

loop () {
	while true; do
		$1
		sleep ${2:-1}
	done
}

ex() {
    if [[ -f $1 ]]; then
        case $1 in
          *.tar.bz2) tar xvjf $1;;
          *.tar.gz) tar xvzf $1;;
          *.tar.xz) tar xvJf $1;;
          *.tar.lzma) tar --lzma xvf $1;;
          *.bz2) bunzip $1;;
          *.rar) unrar $1;;
          *.gz) gunzip $1;;
          *.tar) tar xvf $1;;
          *.tbz2) tar xvjf $1;;
          *.tgz) tar xvzf $1;;
          *.zip) unzip $1;;
          *.Z) uncompress $1;;
          *.7z) 7z x $1;;
          *.dmg) hdiutul mount $1;; # mount OS X disk images
          *) echo "'$1' cannot be extracted via >ex<";;
    esac
    else
        echo "'$1' is not a valid file"
    fi
}

if is_mac; then
    pman() { man $1 -t | open -f -a Preview } # open man pages in Preview

    cdf() { eval cd "`osascript -e 'tell app "Finder" to return the quoted form of the POSIX path of (target of window 1 as alias)' 2>/dev/null`" }
    vol() {
        if [[ -n $1 ]]; then osascript -e "set volume output volume $1"
        else osascript -e "output volume of (get volume settings)"
        fi
    }

    locate() { mdfind "kMDItemDisplayName == '*$@*'c" }
    mailapp() {
        if [[ -n $1 ]]; then msg=$1
        else msg=$(cat | sed -e 's/\\/\\\\/g' -e 's/\"/\\\"/g')
        fi
        osascript -e 'tell application "Mail" to make new outgoing message with properties { Content: "'$msg'", visible: true }' -e 'tell application "Mail" to activate'
    }
    quit() {
        for app in $*; do
            osascript -e 'quit app "'$app'"'
        done
    }
    relaunch() {
        for app in $*; do
            osascript -e 'quit app "'$app'"';
            sleep 2;
            open -a $app
        done
    }
    alias ql='qlmanage -p 2>/dev/null' # OS X Quick Look
    alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
    alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
fi

# Make less the default pager, and specify some useful defaults.
# export LESS='XFR'

less_options=(
    --quit-if-one-screen     # If the entire text fits on one screen, just show it and quit. (like cat)
    --no-init                # Do not clear the screen first.
    --ignore-case            # Like "smartcase" in Vim: ignore case unless the search pattern is mixed.

    --chop-long-lines        # Do not automatically wrap long lines.
    --RAW-CONTROL-CHARS      # Allow ANSI colour escapes, but no other escapes.
    --quiet                  # No bell when trying to scroll past the end of the buffer.
    --dumb                   # Do not complain when we are on a dumb terminal.
);
export LESS="${less_options[*]}";
unset less_options;
export PAGER='less';
