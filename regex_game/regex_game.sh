#########################################################################
# File Name: regex_game.sh
# Author: VOID_133
# QQ: #########
# mail: ####@gmail.com
# Created Time: Wed 01 Jul 2015 09:58:59 AM CST
#########################################################################
#!/bin/bash


function usage()
{
	echo "Usage:"
	echo "	regex_game [option1]";
	echo "Options:"
	echo "	play:Start a regex Game"
	echo "	edit:Create a new level"
	echo "	default: show the help message"
}

echo "Regex Game -- By VOID001"
case "$1" in
	"play")
		while [ 1 -eq 1 ]
		do
			echo "Please input the level you want to play"
			read levl
			RAWPATH="./raw_$levl";
			ANSPATH=".regex_game/ans_$levl";
			if [ -f "$RAWPATH" ] && [ -f "$ANSPATH" ]; then
				echo "Welcome to Level $levl !"
				echo "Here is the RAW Text"
				sleep 1
				chmod -w $RAWPATH
				gedit $RAWPATH
				chmod +w $RAWPATH
				echo "You need to found the below message from the $RAWPATH "
				sleep 1
				cat $ANSPATH
				echo "Now game start!"
				sleep 1
				echo "Please input the regex you want to use :)"
				read regex
				echo grep "$regex" $RAWPATH
				sleep 2
				echo "=======================Your grep result============================="
				grep "$regex" $RAWPATH --color=always | tee .usrgrep
				echo "===========================Final   Result==========================="
				sleep 2
				diff .usrgrep $ANSPATH > /dev/null
				if [ $? -eq 0 ]; then
					echo "You made it!"
					exit 0
				else
					echo "Ooops,something wrong is in your regex, try again please"
				fi
				rm .usrgrep
			else
				echo "No such Level!"
			fi
		done
		;;
	"edit")
		echo "Now please paste or type your raw text into gedit"
		sleep 1
		gedit .tmplevl
		tmpa=1;
		while [ ! -s .tmpans ]
		do
			echo "Now please give the regex"
			read regx
			grep "$regx" .tmplevl --color=always | tee .tmpans
			grep "$regx" .tmplevl --color=always > /dev/null
			if [ ! -s .tmpans ]; then
				echo "Your grep result is NOTHING!,Please change your regex"
			fi
		done
		echo "Please save your level with a level name"
		read levl
		while [ -f ".regex_game/ans_$levl" ]
		do
			echo "The level exist!"
			read levl
		done
		echo "$levl";
		mv .tmplevl ./raw_$levl
		mv .tmpans .regex_game/ans_$levl
		exit 0
		;;
	"")
		usage;
		;;
	*)
		usage;
		;;
esac
