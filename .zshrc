# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
source /usr/share/nvm/init-nvm.sh



prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
      print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
      print -n "%{%k%}"
  fi

  print -n "%{%f%}"
  CURRENT_BG='' 

  #Adds the new line and ➜ as the start character.
  printf "\n ➜";
}


alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

export QT_QPA_PLATFORMTHEME=qt5ct



# xmodmap -e "remove mod1 = Alt_L" -e "remove control = Control_L" -e "keysym Control_L = Alt_L" -e "keysym Alt_L = Control_L" -e "add mod1 = Alt_L" -e "add control = Control_L"
## set up natural scrolling
# imwheel
## setup monitors
# xrandr --output eDP-1 --auto --primary --output DP-2 --auto --above eDP-1


# export mysqlpassword=simplePassword

# export mysqlcontainer=suspicious_khorana
# export mysqlcontainer2=f72934ad18ef
# export dbName=vintrace


export JBOSS_HOME="/home/tom/Documents/vintrace/repos/jboss-eap-6.4.21"
export VINTRACE_SERVER_HOME="/home/tom/Documents/vintrace/repos/vintrace-server"
export VINTRACE_DB_BACKUP="/home/tom/Documents/vintrace/dbBackup"
export VINTRACE_SUPPORT="/home/tom/Documents/vintrace/supportTask"

export conda="/home/tom/anaconda3"
export IDEA="./.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/223.8836.41/bin/idea.sh"

# alias mysql_login='docker exec -it $mysqlcontainer2 mysql -uroot -p$mysqlpassword'


source $VINTRACE_DB_BACKUP/dbScripts.sh

alias jbosscli='/home/tom/Documents/vintrace/repos/jboss-eap-6.4.21/bin/jboss-cli.sh'
alias vintraceServerStart=$JBOSS_HOME/bin/standalone.sh -Djboss.bind.address=0.0.0.0 -DVINTRACE_ENV=local -DVINTRACE_SERVER_HOME=$VINTRACE_SERVER_HOME

# docker start $mysqlcontainer &
# docker run  --memory="4g" --memory-swap="10g" $mysqlcontainer &

swapCtrlAlt(){
  keymap=$(xmodmap -pm)

  # Check if the keymap already contains the Ctrl-Alt swap
  if grep -q "Control_L (0xcc)" <<< "$keymap"; then
    echo "Ctrl and Alt are already swapped"
  else
    xmodmap -e "remove mod1 = Alt_L" -e "remove control = Control_L" -e "keysym Control_L = Alt_L" -e "keysym Alt_L = Control_L" -e "add mod1 = Alt_L" -e "add control = Control_L"
    export swappedCtrAlt=$((swappedCtrAlt+1))
    echo "swapped Ctrl <-> Alt"
  fi
}

setUpNaturalScrolling(){
  mouseId=$(xinput list | grep "MX Master" | grep -oP 'id=\K\d+')
  xinput set-prop $mouseId 334 -1 -1 -1
}

setupXModMap(){
  swapCtrlAlt
  xmodmap -e "keycode 112 = Home" -e "keycode 117 = End" -e "keycode 119 = Print" -e "keycode 127 = Delete"
  setUpNaturalScrolling
}
setupXModMap

runScreenKey(){
  pgrep screenkey || screenkey -s medium --opacity 0.5  --scr 2 &
}

loadI3Layout_working(){
  i3-msg "workspace 2; append_layout ~/.i3/workspace-2.json; exec alacritty;exec alacritty;exec alacritty; exec code; exec $IDEA; exec calibre; exec google-chrome-stable;"
}

xset s off
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_DESKTOP=KDE
export SAL_USE_VCLPLUGIN=kde5
export KDE_SESSION_VERSION=5

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.sd
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/tom/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/tom/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/tom/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/tom/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

startJupyterNotebook(){
  cd '/home/tom/Documents/jupyter/'
  jupyter notebook
}

# export PATH="/home/tom/sdkman/graalvm-ce-java17-22.3.1/bin:$PATH"
# export JAVA_HOME="/home/tom/sdkman/graalvm-ce-java17-22.3.1"



# #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
