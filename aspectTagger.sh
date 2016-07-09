#!/bin/bash 
#### Description: Adds a 'square' tag to square images and a 'panorama' tag to panoramic images using multiprocessing and tag.sh
#### Written by: Stephanie Zellner (sm_zellner@msn.com) on 07/09/16
#### Tested on: OSX Yosemite 

# Path names will only be split on newlines
IFS=$'\n'
# If no arguments are provided, script is run on home directory
root=${1:-~}

function shallowTag {
	# If there are files immediately under the root, run over those first. If tagged returns +1, if not returns +0.
	rootFiles=$(find $1 -maxdepth 1 -mindepth 1 -type f -exec file {} \; | awk -F: '{if ($2 ~/image/) print $1}' | xargs -I % ./tag.sh %)
	# Evaluate the echoed output as a sum then count the number of attempts to add. 
	numRootFiles=$(grep -o "+" <<< $rootFiles | wc -l | tr -d '[[:space:]]')
	echo "COMPLETED: $(($rootFiles))/$numRootFiles images tagged in $1"
}

if [[ -d "$root" ]]; then
	shallowTag $root &
	# Split the subdirectories by size
	bigSub=$(find $root -maxdepth 1 -mindepth 1 -type d  -size +500c | grep -v '/Library\|/\.')
	smallSub=$(find $root -maxdepth 1 -mindepth 1 -type d -size -500c | grep -v '/Library\|/\.')
	# Small directories don't need to be split further
	for s in $smallSub; do
		./tag.sh $s &
	done
	# Big directories get tested for files again and split
	if [[ ! -z "$bigSub" ]]; then 
		for b in $bigSub; do
			# Tag files immediately under the new root 
			shallowTag $b &
			# Run for the sub-subdirectories
			subSub=$(find $b -maxdepth 1 -mindepth 1 -type d | grep -v '/Library\|/\.')
			for ss in $subSub; do
				./tag.sh $ss &
			done
		done
	fi
	wait
	echo "All done! Now try searching for the 'square' or 'panorama' tags."

elif [[ -f "$root" ]]; then
	echo "That's a file! Try giving me a folder to search instead."
else 
	echo "Oops! That path doesn't exist."
fi
		