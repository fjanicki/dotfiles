# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#zmodload zsh/zprof

export PATH=$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$HOME/.dotfiles/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export PATH="/opt/homebrew/anaconda3/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=$PATH:~/.local/bin/
export PATH=$PATH:$(go env GOPATH)/bin
export DISABLE_AUTO_TITLE='true'
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_TMUX_AUTOSTART_ONCE="true"

plugins=(git docker docker-compose aws cp httpie macos minikube pip tmux)
plugins+=(yarn-completion)

source $ZSH/oh-my-zsh.sh
source ~/.secrets
alias vim="nvim"
alias vi="nvim"
alias go-swagger='docker run --rm -it  --user $(id -u):$(id -g) -e GOPATH=$(go env GOPATH):/go -v $HOME:$HOME -w $(pwd) quay.io/goswagger/swagger'

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

# Enable transfer.sh


transfer(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;}

function fixFolder {
  file=$1
  mod_date=$(stat -f "%Sm" "$file")
  xattr -drs com.apple.metadata:kMDItemResumableCopy $file
  SetFile -d "$mod_date" "$file"
}

#zprof

# bun completions
[ -s "/Users/fjanicki/.bun/_bun" ] && source "/Users/fjanicki/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
fpath+=~/.zfunc
autoload -Uz compinit && compinit
function gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;}
eval "$(zoxide init zsh --cmd cd)"

alias gitpullr='(for dir in */; do cd "${dir}" && [ -d ".git" ] && git pull && cd ..; done)'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
