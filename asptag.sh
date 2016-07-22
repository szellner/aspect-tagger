#!/bin/bash 
#### Description: Checks whether a 'square' or 'panorama' tag should be added or removed from an image. 
#### Written by: Stephanie Zellner (sm_zellner@msn.com) on 07/09/16
#### Last updated: 07/22/16
#### Tested on: OSX Yosemite 10.10.5, OSX Mavericks 10.9.5
#### Known errors: 
####    For some reason sips sometimes mixed up width and height, but this accounts for rotated or vertical panoramas.

root=${@:-~}
tagCount=0
fileCount=0
array=false
# Path names will only be split on newlines, not spaces
IFS=$'\n'
# If the root given is a directory, find all image files excluding system files and hidden folders.
if [[ -d "$root" ]]; then 
	files="$(mdfind -onlyin $root 'kMDItemKind==*image' | grep -v '/Library\|/\.')"
# If the root given is a file, then nothing more than setting the files variable needs to be done.
elif [[ -f "$root" ]]; then 
	files=$root	
else
	array=true
fi

function aspectTag {
	((fileCount++))
	# We cannot directly compare kMDItemPixelWidth and kMDItemPixelHeight, so we use sips instead
	height="$(sips -g pixelHeight $1 | tail -n1 | cut -d" " -f4)"
	width="$(sips -g pixelWidth $1 | tail -n1 | cut -d" " -f4)"
	# Check if large enough to be included
	if [[ $height -gt 512 && $width -gt 512 ]]; then
		isSq=$(tag -m square $1) 
		isPan=$(tag -m panorama $1) 
		# If an image is a square or panorama and not already tagged, tag it 
		if [[ $height -eq $width ]]; then
			if [[ $isSq != $1 ]]; then
				tag -a square $1
				((tagCount++)) 
			# An image cannot be square AND panoramic
			elif [[ $isPan = $1 ]]; then
				tag -r panorama $1 
			fi
		# If an image is at least (approximately) twice as long as it is tall, tag it with 'panorama'
		elif [[ $(( $width / $height )) -ge 2 || $(( $height / $width )) -ge 2 ]]; then
			if [[ $isPan != $1 ]]; then
				tag -a panorama $1
				((tagCount++))
			# An image cannot be square AND panoramic
			elif [[ $isSq = $1 ]]; then
				tag -r square $1 
			fi
		# Check if a previously-tagged image no longer qualifies as square or panoramic and remove that tag.
		else
			if [[ $isSq = $1 ]]; then
				tag -r square $1
			elif [[ $isPan = $1 ]]; then
				tag -r panorama $1
			fi
		fi
	fi

	# For long processes, notify the user that the script is still running
	if [[ $((fileCount % 2000)) = 0 ]]; then 
		echo -e "Processing more files in $root...\n"
	fi
}

# MAIN LOOP
if [[ $array = false ]]; then
	# Root can be a directory or a single file
	for f in $files; do
		aspectTag $f 
		# MULTIPROCESSING SPEED BOOST - Replace the line above with that below, but you probably will get a lot of 'fork: Resource temporarily unavailable' warnings. These DO cause incomplete results but this solution works fine if you don't have deeply neseted, large directories or don't want your application files to be parsed.
		# aspectTag $f &
	done
else
	for af in ${@}; do
		aspectTag $af 
	done
fi

# Return a final count of how many square or panoramic images were found and tagged
if [[ -d "$root" ]]; then
	if [[ $fileCount != 0 && $tagCount != 0 ]]; then
		echo "COMPLETED: $tagCount/$fileCount images tagged in $root"
	fi
# Sort of hack-ey way to count the successful/unsuccessful tags from multiple runs of this program on files (from aspectTagger)
elif [[ -f "$root" ]]; then
	if [[ $tagCount -eq 1 ]]; then
		echo "+1"
	else
		echo "+0"
	fi
# Return the final count of how many batch-updated images were tagged
elif [[ $tagCount != 0 ]]; then
	echo "COMPLETED: $tagCount/$fileCount updated images tagged" 
fi

