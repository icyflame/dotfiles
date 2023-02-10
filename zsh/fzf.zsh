if [[ "$(uname)" == "Linux" ]];
then
    # The path to these files was given inside the document that is listed at
    # =apt show fzf=. The package documentation can be fetched using different
    # commands depending on the distribution that you are using.
    [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
    [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
fi

