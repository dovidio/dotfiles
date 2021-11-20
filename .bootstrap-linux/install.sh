#!/usr/bin/env bash

ALL=0
HELP=0
JAVA=0
MAVEN=0
LEIN=0
EMACS=0
UTILS=0
IDEA=0
VISUALCODE=0
ORIENTDB=0
ORIENTDBVERSION="3.2.2"
ZSH=0
CHROME=0

# no arguments, then install all
if [ "$#" == "0" ]; then
	ALL=1
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        --help)
            HELP=1
            shift # past argument
            ;;
        --all)
            ALL=1
            shift # past argument
            ;;
        --java)
            JAVA=1
            shift # past argument
            ;;
        --maven)
            MAVEN=1
            shift # past argument
            ;;
        --lein)
            LEIN=1
            shift # past argument
            ;;
	--emacs)
            EMACS=1
            shift # past argument
            ;;
	--utils)
	    UTILS=1
	    shift #past argument
	    ;;
    --idea)
        IDEA=1
        shift #past argument
        ;;
    --orientdb)
        ORIENTDB=1
        shift #past argument
        ;;
    --visualcode)
        VISUALCODE=1
        shift # past argument
        ;;
    --zsh)
        ZSH=1;
        shift # past argument
        ;;
    --chrome)
        CHROME=1
        shift # past argument
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ "${HELP}" -eq 1 ]; then
    echo "Usage: $0 [OPTION]"
    echo "  --help                                                Display this message"
    echo "  --all                                                 Install all packages (all those listed below)"
    echo "  --java                                                Install java"
    echo "  --maven                                               Install maven"
    echo "  --lein                                                Install lein and add it to /usr/bin"
    echo "  --emacs                                               Install emacs"
    echo "  --utils                                               Install utilities that why the hell are those not even installed by default"
    echo "  --idea                                                Install intellij idea"
    echo "  --orientdb                                            Install OrientDB"
    echo "  --visualcode                                          Install Visual Studio Code"
    echo "  --zsh                                                 Install zsh and oh-my-zsh"
    echo "  --chrome                                              Install Google Chrome"
    exit 0
fi

if [ "${ALL}" -eq 1 ]; then
    JAVA=1
    MAVEN=1
    LEIN=1
    EMACS=1
    UTILS=1
    IDEA=1
    ORIENTDB=1
    VISUALCODE=1
    ZSH=1
    CHROME=1
fi

PREINSTALL() {
    echo "Installing " $1 "..."
}

POSTINSTALL() {
    echo $1 " Installed."
}


if [ "${JAVA}" -eq 1 ]; then
    PREINSTALL "Java"
    sudo apt install openjdk-11-jdk -y
    POSTINSTALL "java"
fi

if [ "${MAVEN}" -eq 1 ]; then
    PREINSTALL "Maven"
    sudo apt install maven -y
    POSTINSTALL "Maven"
fi

if [ "${LEIN}" -eq 1 ]; then
    PREINSTALL "Lein"
    wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
    sudo mv lein /usr/bin
    chmod a+x /usr/bin/lein
    lein
    rm lein
    POSTINSTALL "Lein"
fi

if [ "${EMACS}" -eq 1 ]; then
    PREINSTALL "Emacs"
    sudo apt install emacs -y
    POSTINSTALL "Emacs"
fi

if [ "${UTILS}" -eq 1 ]; then
    PREINSTALL "unzip"
    sudo apt install unzip -y
    sudo apt install libgbm1 -y # needed for running intellij idea in wsl2
    sudo apt install curl -y # debian doesn't have it lol
    sudo apt install jq -y
    POSTINSTALL "unzip"
fi

if [ "${IDEA}" -eq 1 ]; then
    PREINSTALL "Intellij IDEA"
    wget https://download-cdn.jetbrains.com/idea/ideaIU-2021.2.3.tar.gz
    tar -xzf idea*.tar.gz
    rm idea*.tar.gz
    mv idea* idea
    sudo mv idea /opt
    POSTINSTALL "Intellij IDEA"
fi

if [ "${ORIENTDB}" -eq 1 ]; then
    PREINSTALL "OrientDB"
    wget https://s3.us-east-2.amazonaws.com/orientdb3/releases/$ORIENTDBVERSION/orientdb-$ORIENTDBVERSION.tar.gz
    tar -xzf orient*.tar.gz
    rm orient*.tar.gz
    mv orient* orientdb
    sudo mv orientdb /opt/orientdb
    POSTINSTALL "OrientDB"
fi

if [ "${VISUALCODE}" -eq 1 ]; then
  PREINSTALL "Visual Studio Code"
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt install apt-transport-https
  sudo apt update
  sudo apt install code
  POSTINSTALL "Visual Studio Code"
fi

if [ "${ZSH}" -eq 1 ]; then
  PREINSTALL "zsh"
  sudo apt install zsh -y
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  POSTINSTALL "zsh"
fi

if [ "${CHROME}" -eq 1 ]; then
  PREINSTALL "chrome"
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
  sudo apt-get update 
  sudo apt-get install google-chrome-stable -y
  POSTINSTALL "chrome"
fi