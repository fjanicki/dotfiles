export PATH=$HOME/bin:/usr/local/bin:$HOME/.dotfiles/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export PATH="/opt/homebrew/anaconda3/bin:$PATH"
ZSH_THEME="robbyrussell"
ZSH_TMUX_AUTOSTART_ONCE="true"

plugins=(git docker docker-compose aws cp httpie macos minikube pip tmux)
plugins+=(yarn-completion)

source $ZSH/oh-my-zsh.sh
source ~/.secrets
# Source the dotfiles (order matters)

for DOTFILE in "$DOTFILES_DIR"/system/.{function,function,function_fs,function_network,function_text,path,env,exports,alias,fnm,grep,prompt,completion,fix}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done
if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}.macos; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

export EDITOR='vim'

source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell
alias k=kubectl
complete -o default -F __start_kubectl k
complete -C /opt/homebrew/bin/terraform terraform
. "$HOME/.cargo/env"

[[ /opt/homebrew/bin/kubectl ]] && source <(kubectl completion zsh)

# Enable the use of NPM
eval "$(fnm env --use-on-cd)"

# Helm Completions
[[ /opt/homebrew/bin/helm ]] && source <(helm completion zsh)

# npm completions
[[ npm ]] && source <(npm completion)

alias ssm="aws ssm start-session --target "
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
