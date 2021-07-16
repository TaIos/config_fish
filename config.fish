# =============================================
# NOTES
# =============================================

# TIDE install from https://github.com/IlanCosman/tide
# 1. curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
# 2. fisher install IlanCosman/tide
# 3. tide configure

# If GIT emoji from https://medium.com/@joshuacrass/git-fish-prompt-faa389fff07c
# are not working:
# 1. funced _tide_item_git
# 2. Replace it with
#     function _tide_item_git
#         fish_git_prompt
#     end
# 3. funcsave _tide_item_git

# =============================================
# FISH EXTENTIONS
# =============================================

fish_vi_key_bindings

# =============================================
# SET
# =============================================

# PATH
set -gx PATH /home/slarty/.local/bin /home/slarty/bin $PATH

set -g EDITOR 'vim'

# N - set line numbering in less
# U - display special characters (eg backspace)
# R - RAW-CONTROL-CHARS (fixes git diff problem)
# F - exit if the entire file can be displayed on the first scree
# X - do not clear screen on exit (leave it written to terminal)
# e - automatically exit the second time it reaches end-of-file
set -gx LESS '-URFXe'

# =============================================
# SOURCE
# =============================================

# allows using `module` command
# for loading MPI module
# more info: https://modules.readthedocs.io/en/latest/module.html#package-initialization
source '/usr/share/Modules/init/fish' >/dev/null 2>&1
source '/usr/share/Modules/init/fish_completion' >/dev/null 2>&1

# =============================================
# ALIAS
# =============================================

alias forcepush='git add .;git commit --amend --no-edit;git push -f'

alias amendall='git add .;git commit --amend --no-edit'

alias gxx='g++ -Wall -pedantic -Wextra --std=c++11 -o run.out'
alias pdp='g++ -Wall -pedantic -Wextra --std=c++11 -O3 -funroll-loops -fopenmp -o run.out'
alias pdpdeb='g++ -Wall -pedantic -Wextra --std=c++11 -O3 -funroll-loops -fopenmp -g -o run.out'
alias callgrind='valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes --collect-jumps=yes'

alias efish='vim ~/.config/fish/config.fish'

# =============================================
# JUPYTER
# =============================================

# run jupyter lab in current directory
function jn 
	set PORT (math (jupyter notebook list | wc -l)+7000-1) # next availible port
	nohup jupyter notebook --port=$PORT . > /dev/null 2>&1 &
	sleep 1
	nohup firefox https://localhost:$PORT/lab > /dev/null 2>&1 &
	return 0
end

# run jupyter lab in home folder defined in: ~/.jupyter/jupyter_notebook_config.json
function jnh
	set PORT (math (jupyter notebook list | wc -l)+7000-1) # next availible port
	nohup jupyter notebook --port=7000  > /dev/null 2>&1 &
	sleep 1
	nohup firefox https://localhost:$PORT/lab > /dev/null 2>&1 &
	return 0
end

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

