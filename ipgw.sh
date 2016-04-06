#########################################################################
# File Name: ipgw.sh
# Author: VOID_133
# QQ: #########
# mail: ####@gmail.com
# Created Time: Wed 06 Apr 2016 09:51:10 AM CST
#########################################################################
#!/bin/bash

function welcome()
{
    echo "=========================================="
    echo "|                                        |"
    echo "|    NEU IPGW Login Script v0.0          |"
    echo "|                                        |"
    echo "|                       By VOID001       |"
    echo "|                                        |"
    echo "=========================================="
}

function usage()
{
    welcome
    echo "Usage: ipgw [options]"
    echo "  -c Do a connect action"
    echo "  -d Do a disconnect action"
    echo "  Above options must provide only one"
#    echo "-p Use Proxy Mode[Only for VOID001]"
    echo "  -h Show usage"
}

function getconfig()
{
    if [ -f ~/.ipgwcfg ]; then
        noconfig=0
        username=`awk '{print $1}' ~/.ipgwcfg`
        password=`awk '{print $2}' ~/.ipgwcfg`
    else
        noconfig=1
        echo "This is your first time to use this script, Please input your username and password"
        echo "Input your username"
        read username
        echo "Input password"
        read -s password
    fi
}

function saveconfig()
{
    if [ $noconfig -eq 1 ]; then
        echo $username $password > ~/.ipgwcfg
        chmod 600 ~/.ipgwcfg
        echo "Your configuration saved!"
        echo "If you want to login with another user, please remove ~/.ipgwcfg"
        echo -e
    fi
}

function showresult()
{
    clear
    iconv -f gb2312 -t utf8 /tmp/.ipgwresult -o /tmp/.ipgwresult
    grep "REASON=" /tmp/.ipgwresult > /tmp/.ipgwsres   #Truncate the file to only 1 line
    grep "IP=" /tmp/.ipgwresult > /tmp/.ipgwip   #Get ip address
    grep "余额" /tmp/.ipgwresult > /tmp/.ipgwcredit  #Get remained credit = = WTF ipgw result is 帐户 NOT 账户
    grep "IPGWCLIENT_START SUCCESS=YES" /tmp/.ipgwresult > /dev/null

    if [ $? -eq 0 ]; then
        echo "$verb Success!"
        if [ "$verb" == "Connect" ]; then
            echo "Your IP Address is"
            ip=`awk '{print $3}' /tmp/.ipgwip`
            echo $ip
            echo "Your remained credit is"
            sed "s/<t[d,r]>\|<\/t[d,r]>//g" /tmp/.ipgwcredit #Get rid of other annoying symbols
        fi
        saveconfig
    else
        echo "$verb Failed!"
        reason=`awk '{print $3}' /tmp/.ipgwsres`
        echo "$reason"
    fi
}

function cleanup()
{
    rm -rf /tmp/.ipgw*
}

case $1 in
    "-c")
        verb="Connect"
        getconfig
        curl ipgw.neu.edu.cn/ipgw/ipgw.ipgw --data "uid=$username&password=$password&operation=connect&range=2&timeout=1" > /tmp/.ipgwresult
        showresult
        cleanup
        ;;
    "-d")
        verb="Disconnect"
        getconfig
        curl ipgw.neu.edu.cn/ipgw/ipgw.ipgw --data "uid=$username&password=$password&operation=disconnectall&range=2&timeout=1" > /tmp/.ipgwresult
        showresult
        cleanup
        ;;
    "")
        usage
        ;;
    *)
        usage;
        ;;
esac

#curl --proxy socks5://127.0.0.1:1084 ipgw.neu.edu.cn/ipgw/ipgw.ipgw --data "uid=$username&password=$password&operation=disconnectall&range=2&timeout=1"
