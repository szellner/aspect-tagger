#!/bin/bash 
#### Description: Adds a 'square' tag to square images and a 'panorama' tag to panoramic images
#### Written by: Stephanie Zellner (sm_zellner@msn.com) on 07/09/16
#### Tested on: OSX Yosemite 

root=${1:-~}
tagCount=0
fileCount=0
# Path names will only be split on newlines, not spaces
IFS=$'\n'
# If the root given is a directory, find all image files excluding system files and hidden folders.
if [[ -d "$root" ]]; then 
	files="$(mdfind -onlyin $root 'kMDItemKind==*image' | grep -v '/Library\|/\.')"
# If the root given is a file, then nothing more than setting the files variable needs to be done.
elif [[ -f "$root" ]]; then
	files=$root
fi

for f in $files; do
	((fileCount++))
	# We cannot directly compare kMDItemPixelWidth and kMDItemPixelHeight, so we use sips instead
	height="$(sips -g pixelWidth $f | tail -n1 | cut -d" " -f4)"
	width="$(sips -g pixelHeight $f | tail -n1 | cut -d" " -f4)"
	# Check if large enough to be included
	if [[ $height -gt 512 ]] && [[ $width -gt 512 ]]; then
		pan=$(bc <<< "scale=2;($width / $height)>2.5")
		# If an image is square, tag it with 'square'
		if [[ $height -eq $width ]]; then
			tag -a square $f
			((tagCount++))
		# If an image is at least twice as long as it is tall, tag it with 'panorama'

		elif [[ $pan -eq 1 ]]; then
			tag -a panorama $f
			((tagCount++))
		fi
	fi
	# For long processes, notify the user that the script is still running
	if [[ $((fileCount % 2000)) = 0 ]]; then 
		echo "Processing more files..."
	fi
done
# Return a final count of how many square images were found and tagged
if [[ -d "$root" ]]; then
	echo "COMPLETED: $tagCount/$fileCount images tagged in $root"
# Sort of hack-ey way to count the successful/unsuccessful tags from multiple runs of this program
elif [[ -f "$root" ]]; then
	if [[ $tagCount -eq 1 ]]; then
		echo "+1"
	else
		echo "+0"
	fi
fi
