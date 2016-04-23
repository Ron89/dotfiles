# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=50000
setopt appendhistory autocd nomatch correctall
unsetopt beep notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/chong/.zshrc'

# Antigen
source $HOME/.antigen/antigen/antigen.zsh

# emacs shell mode compatibility
if [[ $TERM == dumb ]]; then
	unset zle_bracketed_paste
else
	autoload -Uz bracketed-paste-magic
	zle -N bracketed-paste bracketed-paste-magic
fi

# Load oh-my-zsh
antigen use oh-my-zsh

# Bundles from the default repo
#antigen bundle git
#antigen bundle heroku
#antigen bundle pip
#antigen bundle lein
#antigen bundle command-not-found

# Syntax Highlighting
antigen bundle zsh-users/zsh-syntax-highlighting

autoload -Uz compinit
compinit
# End of lines added by compinstall

# 256 color support setup for terminator
if [ "$TERM" = "xterm" ]; then
	export TERM=xterm-256color
fi

# Colors
autoload -U colors && colors

# Prompt
autoload -U promptinit
promptinit
PROMPT="%{$fg_bold[green]%}%n%{$reset_color%}@%{$fg_bold[cyan]%}%m%{$reset_color%}:%{$fg_no_bold[yellow]%}%1~%{$reset_color%}$ "


## History Search
#autoload -U history-search-end
#zle -N history-beginning-search-backward-end history-search-end
#zle -N history-beginning-search-forward-end history-search-end
#
#bindkey "\e[A" history-beginning-search-backward-end
#bindkey "\e[B" history-beginning-search-forward-end

# Useful Aliases
# alias ls='ls --color=auto'
alias sudo='sudo -E'
alias vimtexServer='vim --servername vimlatex'
alias vimtex='vim --servername vimlatex --remote-tab'
alias vimcodeServer='vim --servername vimcode'
alias vimcode='vim --servername vimcode --remote-tab'
alias nvimtexServer='nvim --servername nvimlatex'
alias nvimtex='nvim --servername nvimlatex --remote-tab'
alias nvimcodeServer='nvim --servername nvimcode'
alias nvimcode='nvim --servername nvimcode --remote-tab'
alias gvimtex='gvim --servername vimlatex'
alias gvimtexSend='gvim --servername vimlatex --remote-tab'
alias gvimcodeServer='gvim --servername vimcode'
alias gvimcode='gvim --servername vimcode --remote-tab'


# add PATH for local tools
PATH=$HOME/bin:$PATH

# PATH refinement
# save and reload history after each command(first remove early history configs)
PROMPT_COMMAND=`echo $PROMPT_COMMAND | sed 's:history -[a-z];[ ]*::g'`
if [ "`echo $PROMPT_COMMAND | awk '{print substr($0,0,1)}'`" != ";" ]; then
	export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
else
	export PROMPT_COMMAND="history -a; history -c; history -r $PROMPT_COMMAND"
fi
# sort out environment variables, remove replicated item in them
PATH=`awk -F: '{for (i=1;i<=NF;i++) { if ( !x[$i]++ ) printf("%s:",$i); }}' <<< $PATH`
PATH=`echo $PATH | sed s:.$::`
export PATH

# Highlight
# source	/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## Base16 Shell
#BASE16_SHELL="$HOME/.config/base16-shell/base16-pop.dark.sh"
#[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Default Editor
export VISUAL="nvim"

# For encryption & decryption
export GPG_TTY=`tty`

if [[ -r /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi

# for urlscan
export BROWSER="firefox"
