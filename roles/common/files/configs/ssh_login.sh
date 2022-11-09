#!/usr/bin/zsh

RED='\033[0;31m'
NC='\033[0m'
IP=`echo $SSH_CLIENT | awk '{print $1}'`

FILE=$HOME/.installation-complete
if [[ ! -f "$FILE" ]]; then
    FILE=/etc/iptables/rules.v4
    if [[ -f "$FILE" ]]; then
        FIRST_LOGIN=`egrep "\-s\\s.*ALLOW SSH" /etc/iptables/rules.v4`
        if [[ $? != 0 ]]; then
            sed -Ei "s/-m tcp(.*ALLOW SSH)/-m tcp -s $IP\1/g" /etc/iptables/rules.v4
            echo -e "First SSH login detected! Adding ${RED}${IP}${NC} to /etc/iptables/rules.v4"
            iptables-restore < /etc/iptables/rules.v4
            touch $HOME/.installation-complete
        else
            echo -e "Logging in from: ${RED}${IP}${NC}"
        fi
    else
        echo -e "Missing /etc/iptables/rules.v4. ${RED}Check iptables!${NC}"
    fi

    # Handle custom docker rules
    FILE=/etc/iptables/docker.rules.v4
    if [[ -f "$FILE" ]]; then
        FIRST_LOGIN=`egrep "\-s\\s.*ALLOW SSH" /etc/iptables/docker.rules.v4`
        if [[ $? != 0 ]]; then
            sed -Ei "s/-m tcp(.*ALLOW SSH)/-m tcp -s $IP\1/g" /etc/iptables/docker.rules.v4
            sed -Ei "s/-m tcp(.*ALLOW WEB)/-m tcp -s $IP\1/g" /etc/iptables/docker.rules.v4
            echo -e "Detected docker! Adding ${RED}${IP}${NC} to /etc/iptables/docker.rules.v4"
        fi
    fi
    
    # Handle custom ui rules
    FILE=/etc/iptables/ui.rules.v4
    if [[ -f "$FILE" ]]; then
        FIRST_LOGIN=`egrep "\-s\\s.*ALLOW SSH" /etc/iptables/ui.rules.v4`
        if [[ $? != 0 ]]; then
            sed -Ei "s/-m tcp(.*ALLOW SSH)/-m tcp -s $IP\1/g" /etc/iptables/ui.rules.v4
            sed -Ei "s/-m tcp(.*ALLOW WEB)/-m tcp -s $IP\1/g" /etc/iptables/ui.rules.v4
            echo -e "Detected wireguard-ui! Adding ${RED}${IP}${NC} to /etc/iptables/ui.rules.v4"
        fi
    fi
else
    echo -e "Logging in from: ${RED}${IP}${NC}"
fi