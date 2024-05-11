#!/bin/bash
LANG=en_us_8859_1
dir="/media/HDD_1TB/minecraft_backups/last"
# Screening each "/" to "\/" for "sed" command usage
dirP=${dir////\\/}

# Time start
ts=$(date +%s)


# Getting list of backups and total space used
world=$(ls -p $dir/world | grep -v /)
world_nether=$(ls -p $dir/world_nether | grep -v /)
world_the_end=$(ls -p $dir/world_the_end | grep -v /)
total_weight=$(du -h $dir | tail -n 1 | sed -e "s/$dirP//")
weight=$(du -h $dir/world | tail -n 1 | sed -e "s/$dirP\/world//")
weight_nether=$(du -h $dir/world_nether | tail -n 1 | sed -e "s/$dirP\/world_nether//")
weight_the_end=$(du -h $dir/world_the_end | tail -n 1 | sed -e "s/$dirP\/world_the_end//")


# Counting backups and printing information
count=0
for b in $world; do ((count+=1)); done
for b in $world_nether; do ((count+=1)); done
for b in $world_the_end; do ((count+=1)); done
echo "We have $count unsorted backups"
echo "World $weight"
echo "Nether $weight_nether"
echo "The End $weight_the_end"
echo "Total weight $total_weight"
echo ""


# Extract world type [world, world_nether, world_the_end]
function getworldtype {
    worldtype=$(echo $1 | cut -d '2' -f 1)
}

# Function that extracts creation time
function gettime {
    time=$(echo $1 | sed -e "s/$worldtype//")
    time=$(echo $time | sed -e "s/.tar//")
    date=$(echo $time | cut -b 1-8)
    year=$(echo $date | cut -b 1-4)
    month=$(echo $date | cut -b 5-6)
    day=$(echo $date | cut -b 7-8)
    hour=$(echo $time | cut -b 10-11)
    weekday=$(date -d $date +%a)
}


# Loop through worlds
worlds=($world $world_nether $world_the_end)
for w in ${worlds[*]}
do
    # Creating week array
    week=()
    # Bool variable: if sunday came
    sun_came=0

    # Loop through backups
    for b in $w
    do
        # Getting world type and creation time
        getworldtype $b
        gettime $b

        if [ "$weekday" == "Sun" ]; then sun_came=1;
        else 
            # If it was Sunday: do the work
            if [ $sun_came == 1 ]; then
                c=0
                for w in "${week[@]}"; do
                    # Counting backups this week
                    ((c+=1))
                    # Deleting backups
                    rm $dir/$w
                done

                # Creating /weekly if not exists
                [ ! -d $dir/weekly/$year-$month-$day ] && mkdir -p $dir/weekly/$year-$month-$day && echo created weekly/$year-$month-$day
                # Moving Monday backup to /weekly
                mv $dir/$type/$b $dir/weekly/$year-$month-$day

                # Printing counted backups
                echo "Backups This week: $c"
                # Renewing variables
                sun_came=0
                week=()
                continue
           fi
        fi
        # Adding backup to week array
    done
done
echo
echo "Backups cleaned 🗑️" 
echo "Time elased: $(($(date +%s)-$ts))s."

