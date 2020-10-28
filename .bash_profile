
# Load our dotfiles like ~/.bash_prompt, etc…
#   ~/.extra can be used for settings you don’t want to commit,
#   Use it to configure your PATH, thus it being first in line.
for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file

# to help sublimelinter etc with finding my PATHS
case $- in
   *i*) source ~/.extra
esac

# generic colouriser
GRC=`which grc`
if [ "$TERM" != dumb ] && [ -n "$GRC" ]
    then
        alias colourify="$GRC -es --colour=auto"
        alias configure='colourify ./configure'
        for app in {diff,make,gcc,g++,ping,traceroute}; do
            alias "$app"='colourify '$app
    done
fi

# highlighting inside manpages and elsewhere
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

##
## gotta tune that bash_history…
##

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
export HISTTIMEFORMAT='%F %T '

# keep history up to date, across sessions, in realtime
#  http://unix.stackexchange.com/a/48113
export HISTCONTROL="ignoredups"       # no duplicate entries, but keep space-prefixed commands
export HISTSIZE=100000                          # big big history (default is 500)
export HISTFILESIZE=$HISTSIZE                   # big big history
type shopt &> /dev/null && shopt -s histappend  # append to history, don't overwrite it

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Save multi-line commands as one command
shopt -s cmdhist

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# ^ the only downside with this is [up] on the readline will go over all history not just this bash session.



##
## hooking in other apps…
##
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"



# z beats cd most of the time. `git clone https://github.com/rupa/z.git ~/code/z`
if which brew > /dev/null; then
    zpath="~/code/z/z.sh"
    [ -s $zpath ] && source $zpath
fi;

##
## Completion…
##

if [[ -n "$ZSH_VERSION" ]]; then  # quit now if in zsh
    return 1 2> /dev/null || exit 1;
fi;

# Sorry, very MacOS centric here. :/
if  which brew > /dev/null; then

    # bash completion.
    if [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
        source "$(brew --prefix)/share/bash-completion/bash_completion";
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion;
    fi

    # homebrew completion
    source "$(brew --prefix)/etc/bash_completion.d/brew"

    # hub completion
    if  which hub > /dev/null; then
        source "$(brew --prefix)/etc/bash_completion.d/hub.bash_completion.sh";
    fi;
fi;


# Enable tab completion for `g` by marking it as an alias for `git`
if type __git_complete &> /dev/null; then
    __git_complete g __git_main
fi;

# Enable git branch name completion if file exists
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults


# aws autocompletion
complete -C aws_completer aws

##
## better `cd`'ing
##

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell;

# Autocorrect on directory names to match a glob.
shopt -s dirspell 2> /dev/null

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

# add pyenv and pyenv-virtualenv
if which pyenv > /dev/null; then
  eval "$(pyenv init -)";
  if which brew > /dev/null; then
    # have brew use system python
    alias brew="env PATH=${PATH//$(pyenv root)\/shims:/} brew";
  fi
fi

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

if which jenv > /dev/null; then
  export PATH="$HOME/.jenv/bin:$PATH";
  eval "$(jenv init -)";
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# The next line updates PATH for the Google Cloud SDK.
# source '/Users/michael/sites/google-cloud-sdk/path.bash.inc'

# The next line enables bash completion for gcloud.
# source '/Users/michael/sites/google-cloud-sdk/completion.bash.inc'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/michael/sites/google-cloud-sdk/path.bash.inc' ]; then . '/Users/michael/sites/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/michael/sites/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/michael/sites/google-cloud-sdk/completion.bash.inc'; fi
