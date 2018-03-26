# Vim Setup
[[ -d $HOME/.vim ]] || mkdir -p $HOME/.vim
[[ -d $HOME/.config/nvim ]] || mkdir -p $HOME/.config/nvim

ln -s $PWD/.vimrc $HOME/.vimrc
ln -s $PWD/.vimrc $HOME/.config/nvim/init.vim

# setup vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ln -s $PWD/my-snippets $HOME/.vim

# Emacs Setup
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cp $PWD/.spacemacs $HOME/.spacemacs
