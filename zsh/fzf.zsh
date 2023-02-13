if [[ "$(uname)" == "Linux" ]];
then
    # The path to these files was given inside the document that is listed at
    # =apt show fzf=. The package documentation can be fetched using different
    # commands depending on the distribution that you are using.
    [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
    [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
fi

if [[ "$(uname)" == "Darwin" ]];
then
    # The path to these files depends on where the package fzf was installed by
    # Homebrew. The path can be found through =brew info fzf=.
    [ -f "/opt/homebrew/opt/fzf/shell/completion.zsh" ] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 
    [ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ] && source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
fi


