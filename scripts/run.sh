#!/bin/bash

APP_NAME="PPSSPPSDL 2"
EXEC_NAME="PPSSPPSDL"

if [ ! -d "/Applications/$APP_NAME.app" ];
	then
		>&2 echo "Error: $EXEC_NAME: Not found"
		exit 1
fi
if [ ! -f "EBOOT.PBP" ];
	then
		>&2 echo "Error: 'EBOOT.PBP': Not found"
		exit 1
fi

printf "\e[0;32m[Starting $APP_NAME]\e[0m\n"
/Applications/"$APP_NAME.app"/Contents/MacOS/$EXEC_NAME $PWD/EBOOT.PBP > /dev/null
