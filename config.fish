set -g theme_display_git_default_branch yes
fish_vi_key_bindings


alias forcepush='git add .;git commit --amend --no-edit;git push -f'
alias amendall='git add .;git commit --amend --no-edit'
alias gxx='g++ -Wall -pedantic -Wextra --std=c++11 -o run.out'

# JUPYTER
alias jn='nohup jupyter notebook --port=7000 > /dev/null 2>&1 &; sleep 1; nohup firefox https://localhost.localdomain:7000/lab > /dev/null 2>&1 &; return 0'
alias jnl='pgrep jupyter'
alias jnq='kill (pgrep jupyter)'

# https://github.com/fish-shell/fish-shell/issues/3541
# bindings: https://fishshell.com/docs/current/cmds/bind.html
# \e alt, \c ctrl
function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
	bind \ek history-search-backward
	bind \ej history-search-forward
end

