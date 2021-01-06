# =============================================
# NOTES
# =============================================

# TIDE: Fish prompt with nice walkthrough seting
#	https://github.com/IlanCosman/tide

# fish_git_prompt git configuration
#	https://fishshell.com/docs/current/cmds/fish_git_prompt.html

# fish prompt emoji
#	https://medium.com/@joshuacrass/git-fish-prompt-faa389fff07c

# =============================================
# EXTENTIONS
# =============================================

fish_vi_key_bindings

# =============================================
# PATH
# =============================================

set -gx PATH /home/slarty/.local/bin /home/slarty/bin $PATH

# =============================================
# ALIAS
# =============================================

alias forcepush='git add .;git commit --amend --no-edit;git push -f'

alias amendall='git add .;git commit --amend --no-edit'

alias gxx='g++ -Wall -pedantic -Wextra --std=c++11 -o run.out'

alias efish='vim ~/.config/fish/config.fish'

# =============================================
# JUPYTER
# =============================================

# currect folder
alias jn='nohup jupyter notebook --port=7000 . > /dev/null 2>&1 &; sleep 1; nohup firefox https://localhost:7000/lab > /dev/null 2>&1 &; return 0'

# home folder defined in: ~/.jupyter/jupyter_notebook_config.json
alias jnh='nohup jupyter notebook --port=7000  > /dev/null 2>&1 &; sleep 1; nohup firefox https://localhost:7000/lab > /dev/null 2>&1 &; return 0'

alias jnl='jupyter notebook list'

alias jnq='kill (pgrep jupyter)'

# =============================================
# ATUTOCOMPLETION
# =============================================
# https://github.com/fish-shell/fish-shell/issues/3541
# bindings: https://fishshell.com/docs/current/cmds/bind.html
# \e alt, \c ctrl

function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
        bind -M $mode \cw forward-word
    end
	bind \ek history-search-backward
	bind \ej history-search-forward
end

# =============================================
# TURN OFF GREETING
# =============================================
# https://stackoverflow.com/a/13995944

set fish_greeting

# =============================================
# GIT
# =============================================

set -g theme_display_git_default_branch yes

# ===========
# from https://medium.com/@joshuacrass/git-fish-prompt-faa389fff07c

# Options
set __fish_git_prompt_show_informative_status
set __fish_git_prompt_showcolorhints
set __fish_git_prompt_showupstream "informative"

# Colors
set green (set_color green)
set magenta (set_color magenta)
set normal (set_color normal)
set red (set_color red)
set yellow (set_color yellow)

set __fish_git_prompt_color_branch magenta --bold
set __fish_git_prompt_color_dirtystate white
set __fish_git_prompt_color_invalidstate red
set __fish_git_prompt_color_merging yellow
set __fish_git_prompt_color_stagedstate yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red


# Icons
set __fish_git_prompt_char_cleanstate ' 👍  '
set __fish_git_prompt_char_conflictedstate ' ⚠️  '
set __fish_git_prompt_char_dirtystate ' 💩  '
set __fish_git_prompt_char_invalidstate ' 🤮  '
set __fish_git_prompt_char_stagedstate ' 🚥  '
set __fish_git_prompt_char_stashstate ' 📦  '
set __fish_git_prompt_char_stateseparator ' | '
set __fish_git_prompt_char_untrackedfiles ' 🔍  '
set __fish_git_prompt_char_upstream_ahead ' ☝️  '
set __fish_git_prompt_char_upstream_behind ' 👇  '
set __fish_git_prompt_char_upstream_diverged ' 🚧  '
set __fish_git_prompt_char_upstream_equal ' 💯 ' 

