!/bin/bash

#Checks that the needed arguments for the command to be run.
if [[ $# -eq 0 ]]; then
    echo "usage: no argument is provided"
    exit 1
fi

if [[ $# -gt 1 ]]; then
    echo "usage: more than one arguments are provided"
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo "usage: input is not a file or it does not exist"
    exit 1
fi

if [[ "$1" != *.vsc ]]; then
    echo "usage: input does not have the extension .vsc"
    exit 1
fi
#Empty array for reading lines
lines=()
while IFS= read -r line || [[ -n "$line" ]]; do
    lines+=("$line")
done < "$1"
#If lines are empty quit as no program is present in vsc
if [[ ${#lines[@]} -eq 0 ]]; then
    echo "usage: the file is empty – no .bin file is produced"
    exit 1
fi
# sets n values as first line
n_values="${lines[0]}"
#Checks if n values are either 0 or 2
if [[ "$n_values" != "0" && "$n_values" != "2" ]]; then
    echo "usage: line 1 must be 0 or 2"
    exit 1
fi
# sets an output as a bin file
output="${1%.vsc}.bin"
# If n value is 0 it must be a quit program
if [[ "$n_values" == "0" ]]; then
    if [[ ${#lines[@]} -ne 2 || "${lines[1]}" != "QUIT,0,0" ]]; then
        echo "usage: when line 1 is 0, line 2 must be exactly QUIT,0,0"
        exit 1
    fi
#Initiate the quit and exits as 0
    {
        printf '\x20'
        printf '\x00'
    } > "$output" 
    echo "It is a QUIT program"
    echo "The content of the .bin file is"
    od -An -tx1 "$output" | tr -s ' ' '\n' | sed '/^$/d'
    
    exit 0
fi
