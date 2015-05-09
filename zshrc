# Path to your oh-my-zsh installation.
export ZSH=$HOME/denver/oh-my-zsh

# Keep getting good tips from:
# https://github.com/janmoesen/tilde/blob/master/.bash/commands#L95-L121
# https://github.com/mathiasbynens/dotfiles/blob/master/.functions#L24-L27

POWERLINE_RIGHT_A="exit-status"

DISABLE_AUTO_UPDATE="true"
DISABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

function highlights {
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
	ZSH_HIGHLIGHT_PATTERNS+=('rm -rf' 'fg=white,bold,bg=red')
	ZSH_HIGHLIGHT_PATTERNS+=('sudo ' 'fg=white,bold,bg=red')
	ZSH_HIGHLIGHT_STYLES[path]=none
	ZSH_HIGHLIGHT_STYLES[builtin]=fg=blue
	ZSH_HIGHLIGHT_STYLES[command]=fg=blue
	ZSH_HIGHLIGHT_STYLES[alias]=fg=blue
	ZSH_HIGHLIGHT_STYLES[function]=fg=blue
}

function setup_paths {
	# PATHS
	# Use man pages from GNU first; fall back to OS X builtins
	# https://gist.github.com/quickshiftin/9130153
	# alias man='_() { echo $1; man -M $(brew --prefix)/opt/coreutils/libexec/gnuman $1 1>/dev/null 2>&1;  if [ "$?" -eq 0 ]; then man -M $(brew --prefix)/opt/coreutils/libexec/gnuman $1; else man $1; fi }; _'

	# GNU PATH: confirm with $ brew --prefix coreutils
	if [[ -d /usr/local/opt/coreutils/libexec ]]; then # GNU coreutils are installed; use them
		manpath=(/usr/local/opt/coreutils/libexec/gnuman $manpath)
		path=(/usr/local/opt/coreutils/libexec/gnubin $path)
	fi

	# npm binaries (get the path from npm bin -g
	if [[ -d /usr/local/share/npm/bin ]]; then
		path=(/usr/local/share/npm/bin $path)
	fi

	path=(${HOME}/bin /usr/local/bin /usr/local/sbin $path)

	# For Racket apps (DrRacket)
	# path+=('/Applications/Racket v6.1.1/bin')

	# Anaconda distribution of Python
	path=('/Users/scott/anaconda/bin' $path)

	# Remove duplicates
	# path=($^path(N))
}

source ~/denver/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
highlights
source ~/denver/oh-my-zsh/oh-my-zsh.sh
setup_paths

source ~/denver/zsh-scott
source ~/denver/prompt/base.sh
source ~/denver/prompt/arialdo-pathinline.zsh

# VARIABLES
export LANG=en_US.UTF-8

export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/scott/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

