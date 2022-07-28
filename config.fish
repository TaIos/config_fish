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

alias p='stat -Lc "%A [%a] %U/%G %n"'

function ros2_terminal --description "Run ROS terminal"
	bash -c 'source /home/slarty/Apps/ros2_galactic/install/local_setup.bash; bash; '
end

# =========== UNIQWAY aliases

# DEPRACATED - create_setup_database_script.py
#alias uniqway_clone_and_prepare_production_db_for_testing='sudo service postgresql restart; sleep 5; dropdb uniqplay_db; createdb uniqplay_db; /home/slarty/work/uniqway/uniqway-server/quality-assurance/scripts/restore-uniqway-db.sh production; echo; python /home/slarty/work/uniqway/uniqway-server/quality-assurance/utils/create_setup_database_script.py | psql -U uniqplay_user -d uniqplay_db'

# DEPRACATED - create_setup_database_script.py
#alias uniqway_clone_and_prepare_staging_db_for_testing='sudo service postgresql restart; sleep 5; dropdb uniqplay_db; createdb uniqplay_db; /home/slarty/work/uniqway/uniqway-server/quality-assurance/scripts/restore-uniqway-db.sh staging; echo; python /home/slarty/work/uniqway/uniqway-server/quality-assurance/utils/create_setup_database_script.py | psql -U uniqplay_user -d uniqplay_db'

# DEPRACATED - create_setup_database_script.py
#alias uniqway_clone_staging_db='sudo service postgresql restart; sleep 5; dropdb uniqplay_db; createdb uniqplay_db; /home/slarty/work/uniqway/uniqway-server/quality-assurance/scripts/restore-uniqway-db.sh staging'

# DEPRACATED - create_setup_database_script.py
#alias uniqway_clone_production_db='sudo service postgresql restart; sleep 5; dropdb uniqplay_db; createdb uniqplay_db; /home/slarty/work/uniqway/uniqway-server/quality-assurance/scripts/restore-uniqway-db.sh production'

alias uniqway_get_production_application_config='/home/slarty/work/uniqway/uniqway-server/infra/aws/secrets.sh get production application-conf'

alias uniqway_get_staging_application_config='/home/slarty/work/uniqway/uniqway-server/infra/aws/secrets.sh get staging application-conf'

alias uniqway_connect_to_teamcity_old='ssh teamcity_old -L 8111:localhost:443'
alias uniqway_connect_to_teamcity='ssh -N -L 1337:localhost:8111 debug@teamcity'

# =========== UNIQWAY functions

function _uniqway_create_ssh_connection_to_db --description "Create SSH tunnel to Uniqway database"
	set ENVIRONMENT $argv[1]
	set FREE_PORT $argv[2]
	set DB_URL uniqplay-database-$ENVIRONMENT.c3ulragbtenq.eu-west-1.rds.amazonaws.com
	_print_as_heading "$ENVIRONMENT"
	echo "Creating SSH tunnel to $DB_URL"
		# source for sleep hack: https://unix.stackexchange.com/a/83812
	ssh -f -L $FREE_PORT:$DB_URL:5432 debug@debug  -o "ExitOnForwardFailure yes" 'sleep 10' 
end

function uniqway_clone_database --description "Clone Uniqway database"
	set ENVIRONMENT $argv[1]
	set FREE_PORT 5433
	set DUMP_FILE "backup_"$ENVIRONMENT"_"(date '+%Y-%m-%d_%H:%M:%S')".sql"
	_uniqway_create_ssh_connection_to_db $ENVIRONMENT $FREE_PORT
	if test $status -ne 0
		return $status
	end
	echo "Cloning "$argv[1]" on port "$FREE_PORT" to "$DUMP_FILE
	PGPASSWORD=(cat /home/slarty/work/uniqway/uniqway-secrets/pg_pass) pg_dump -h localhost -U uniqtest -d uniqplay_db -p $FREE_PORT -f $DUMP_FILE --verbose
end

function uniqway_database_connect --description "Connect to Uniqway database"
	set ENVIRONMENT $argv[1]
	set FREE_PORT 5433
	_uniqway_create_ssh_connection_to_db $ENVIRONMENT $FREE_PORT
	if test $status -ne 0
		return $status
	end
	echo "Connecting to "$argv[1]" on port "$FREE_PORT 
	PGPASSWORD=(cat /home/slarty/work/uniqway/uniqway-secrets/pg_pass) psql -h localhost -U uniqtest -d uniqplay_db -p $FREE_PORT
end

function _uniqway_docker_login_aws --description "Login to AWS for access of docker images stored in Amazon ECR"
	_print_as_heading "Logging to AWS"
	aws --profile uniqway --region eu-west-1 ecr get-login-password | docker login --username AWS --password-stdin https://202920049791.dkr.ecr.eu-west-1.amazonaws.com
end

function _uniqway_pull_production_docker_image --description "Pull latest docker image of production database from Amazon ECR"
	_uniqway_docker_login_aws	
	_print_as_heading "Pulling latest production DB snapshot"
	docker pull 202920049791.dkr.ecr.eu-west-1.amazonaws.com/database:latest
end

function _uniqway_get_local_bind_port_for_database --description "Get port as first argument or return sensible default if first argument is not present"
	set LOCAL_BIND_PORT $argv[1]
	if not test -n "$LOCAL_BIND_PORT"
		set LOCAL_BIND_PORT 5432
	end
	echo $LOCAL_BIND_PORT
end

function uniqway_pull_and_run_latest_prod_docker_db --description "Start docker container with pulled production database. First argument is optional local bind port for PSQL database"
	set LOCAL_BIND_PORT (_uniqway_get_local_bind_port_for_database $argv)
	_uniqway_pull_production_docker_image
	uniqway_refresh_prod_docker_db $LOCAL_BIND_PORT
end

function uniqway_refresh_prod_docker_db --description "Remove running docker container with database (if present) and recreate&run it from local image"
	set LOCAL_BIND_PORT (_uniqway_get_local_bind_port_for_database $argv)
	_print_as_heading "Refresh and run latest production database image [port=$LOCAL_BIND_PORT]"
	docker rm -f postgres 2>/dev/null || true 
	docker run -d -p $LOCAL_BIND_PORT:5432 --name postgres 202920049791.dkr.ecr.eu-west-1.amazonaws.com/database:latest
end

# =============================================
# JUPYTER
# =============================================

# run jupyter lab in current directory
function jn 
	set PORT (math (jupyter notebook list | wc -l)+7000-1) # next availible port
	nohup jupyter-lab --port=$PORT . > /dev/null 2>&1 &
	sleep 1
	#nohup firefox https://localhost:$PORT/lab > /dev/null 2>&1 &
	return 0
end

# run jupyter lab in home folder defined in: ~/.jupyter/jupyter_notebook_config.json
function jnh
	set PORT (math (jupyter notebook list | wc -l)+7000-1) # next availible port
	nohup jupyter-lab --port=7000 ~/Notebooks  > /dev/null 2>&1 &
	sleep 1
	#nohup firefox https://localhost:$PORT/lab > /dev/null 2>&1 &
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
# HELPER FUNCTIONS
# =============================================


function _print_count_times --description "Print count times given character without newline to STDOUT. First argument is character, second is count."
	set CHAR $argv[1]
	set COUNT $argv[2]
	printf %"$COUNT"s |tr " " $CHAR
	return 0
end

function _print_as_heading --description "Print first argument as with visual delimiters before and after"
	set HEADING $argv[1]
	set LEN (string length $HEADING)
	set DELIMITER "="
	_print_count_times $DELIMITER $LEN
	printf \n"$HEADING"\n
	_print_count_times $DELIMITER $LEN
	printf \n
	return 0
end

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

