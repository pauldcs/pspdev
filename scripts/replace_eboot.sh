#!/bin/bash

path_to_volume="/Volumes/Untitled"
path_to_game="PSP/GAME/CUB3D"

if [ ! -f "EBOOT.PBP" ];
	then
		>&2 echo "Error: 'EBOOT.PBP': Not found"
		exit 1
fi

if [ -e "$path_to_volume" ]
	then
		echo "Found '$path_to_volume', now replacing 'EBOOT.PBP'..."
		rm -f $path_to_volume/$path_to_game/EBOOT.PBP
		cp EBOOT.PBP $path_to_volume/$path_to_game
		echo "Ejecting '$path_to_volume'..."
		diskutil eject $path_to_volume
	else
		>&2 echo "Error: PSP not found"
fi

