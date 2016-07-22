#!/bin/bash 
#### Description: Adds a 'square' tag to square images and a 'panorama' tag to panoramic images using multiprocessing and asptag.sh
#### Written by: Stephanie Zellner (sm_zellner@msn.com) on 07/09/16
#### Last Updated: 07/22/16
#### Tested on: OSX Yosemite 10.10.5, OSX Mavericks 10.9.5
#### Known errors:
####    The fswatch module can write more than once for a single update. The authors have no plan to change that. 
#### Todo: 
####    Disown the process in Terminal (nohup?) so that it runs as a background process.

# SET UP COMMAND LINE OPTIONS
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -m|--mode)
    MODE="$2"
    shift # past argument
    ;;
    -v|--verbose)
    VERBOSE=1
    ;;
esac
shift # past argument or value
done

if [[ "$1" = "-v" ]]; then
    VERBOSE=1
    root=~
else
    # If no arguments are provided, script is run on home directory
    root=${1:-~}
fi

# Set the default mode and check for invalid modes. 
if [[ $MODE == "" ]]; then
    MODE="simple"
elif [[ $MODE != "simple" && $MODE != "monitor" ]]; then
    echo "$MODE is not a valid mode"
    exit 
fi

function log {
    if [[ $VERBOSE -eq 1 && "$@" != "" ]]; then
        echo "$@"
    fi
}

# BEGINNING OF TAGGING CODE
# Path names will only be split on newlines
IFS=$'\n'

case $MODE in 
    "simple") # Runs on a directory
    function shallowTag {
    # If there are files immediately under the root, run over those first. If tagged returns +1, if not returns +0.
    rootFiles=$(find $1 -maxdepth 1 -mindepth 1 -type f -exec file {} \; | awk -F: '{if ($2 ~/image/) print $1}' | xargs -I % ./asptag.sh % &)
    # Sum the echoed output then count the number of attempts to add. 
    numRootFiles=$(grep -o "+" <<< $rootFiles | wc -l | tr -d '[[:space:]]')
    rf=$(($rootFiles))
    if [[ $rf != 0 ]]; then 
        log "COMPLETED: $(($rootFiles))/$numRootFiles images shallow tagged in $1"
    fi
    }

    if [[ -d "$root" ]]; then
        shallowTag $root &
        # Split the subdirectories by size. It's not faster to split the big files again, but it allows for more processes.
        bigSub=$(find $root -maxdepth 1 -mindepth 1 -type d  -size +600c | grep -v '/Library\|/\.' &)
        smallSub=$(find $root -maxdepth 1 -mindepth 1 -type d -size -600c | grep -v '/Library\|/\.' &)
        for s in $smallSub; do
            shallowTag $s &
            log $(./asptag.sh $s &) &
        done
        if [[ ! -z "$bigSub" ]]; then 
            for b in $bigSub; do
                shallowTag $b &
                log $(./asptag.sh $b &) &
            done
        fi
    wait
    echo "All done! Now try searching for the 'square' or 'panorama' tags."
    exit
    
    elif [[ -f "$root" ]]; then
        echo "That's a file! Try giving me a directory to simple tag instead."
    else 
        echo "Oops! The path $root doesn't exist."
    fi
    ;;

    "monitor") # Begins an fswatch process to continuously monitor your system for updated files
    # Double check with the user that running this as a background process is okay & inform them how to close it
    echo "Monitor mode begins a background process to continuously monitor your system for updated files. Is this okay?"
    echo -n "Type [y/n] then press [ENTER]: "
    read agree
    if [[ $agree = "n" ]]; then
        echo "Try running in simple mode instead!"
        exit
    elif [[ $agree = "y" ]]; then
        echo "Beginning in a second...this process can be closed at any time by" #TODO
    else 
        echo "Sorry, I didn't understand that input. Try again."
        exit
    fi

    # If files are created (i.e. added or updated) and are image files, batch process them with the aspectTagger script
    fswatch --batch-marker=EOF --event Created -E -I -e ".*" -i "jpg$|jpeg$|png$|gif$|tif$|tiff$|psd$|xcf$" $root | while read file event; do
        if [ $file = "EOF" ]; then
            result=$(./asptag.sh "${list[@]}")
            # We get a +0/1 answer if a single file is updated in monitor mode. Strip the '+' and show results. 
            if [[ $result == *'+'* ]]; then #&& $fileCount != 0 
                # remove 2nd clause above and change below${result//+} if you want to see 0 or 1 updated
                if [[ $result -ne "+0" ]]; then
                    log "COMPLETED: 1 updated image tagged"
                elif [[ $result -eq "+0" ]]; then 
                    continue
                fi
            # Otherwise the completed statements come from asptag.sh 
            else
               log $result
            fi
           list=()

        else
            if [[ $file != *'Library'* ]]; then
                list+=($file)
            fi
        fi
    done
    # If the script is force quit and fswatch no longer receives events, notify the user and close out cleanly. 
    echo -e "\nThe aspectTagger script has been turned off."
    exit
    ;;
esac

