#!/usr/bin/env bash

ALL=0
HELP=0
JAVA=0
MAVEN=0
LEIN=0
EMACS=0
UTILS=0
IDEA=0

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
    exit 0
fi

if [ "${ALL}" -eq 1 ]; then
    JAVA=1
    MAVEN=1
    LEIN=1
    EMACS=1
    UTILS=1
    IDEA=1
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
    POSTINSTALL "unzip"
fi

if [ "${IDEA}" -eq 1 ]; then
    PREINSTALL "Intellij IDEA"
    wget https://download-cdn.jetbrains.com/idea/ideaIU-2021.2.3.tar.gz
    tar -xzf idea*.tar.gz
    mv idea* idea
    sudo mv idea /opt
    cd $HOME/.bootstrap-linux
    sudo desktop-file-install jetbrains-idea.desktop
    POSTINSTALL "Intellij IDEA"
fi
