# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=50000
setopt appendhistory autocd nomatch correctall
unsetopt beep notify
bindkey -e

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

# Syntax Highlighting
antigen bundle zsh-users/zsh-syntax-highlighting

# antigen setup finish
antigen apply

if [[ -r /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi
