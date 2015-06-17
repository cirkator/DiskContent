#!/bin/bash

# Change DATE_FORMAT to "us" if you want 12_31_2015 appended to output file
# Leave on "eu" if you want 31_12_2015
DATE_FORMAT="eu"

# Path of tree_colorized.sh
TREE_PATH="/boot/scripts/"

###################################################################################################

# Set DATE_FORMAT to either EU or US format
# DATE will store the current date in the desired format
if [ $DATE_FORMAT == eu ]; then
        DATE="$(date +"%d.%m.%Y")"

elif [ $DATE_FORMAT == us ]; then
        DATE="$(date +"%m.%d.%Y")"

else    echo "Wrong date format input, please check again"
        exit 1
fi

# Set OUTPUT_PATH to where you want your disk_content text files to be saved
OUTPUT_PATH="/boot/scripts/DiskContent/${DATE}/"

# Check if OUTPUT_PATH directory exists, if not, create it
if [ ! -d "${OUTPUT_PATH}" ]; then
        mkdir -p "${OUTPUT_PATH}" && echo -e "\nOutput Directory successfully created"
fi

# Check if TREE_PATH directory exists, if not, create it
if [ ! -d $TREE_PATH ]; then
        mkdir -p $TREE_PATH && echo -e "\nTree Directory successfully created"
fi

# Check if tree_colorized.sh is at the correct location
if [ ! -f $TREE_PATH"tree_colorized.sh" ]; then
        echo -e "\ntree_colorized.sh is missing, make sure you have defined the correct location"
        exit 1
fi

###################################################################################################


# We just want the disk number, so we search for directories named disk* in /mnt,
# sort them numerically and in reverse direction, now that the highest disknumber is on top,
# we read the first line and cut away "/mnt/disk" which leaves us with just the disknumber
DISK_COUNT="$(find /mnt -maxdepth 1 -type d -name 'disk*' | sort -Vr | head -1 | cut -c 10-11)"

# Loop through the number of available disks, enter each disk, run tree_colorized.sh,
# write each txt file with the disk number to outputpath
for ((i=1; i<=$DISK_COUNT; i++)); do

        cd /mnt/disk$i
        echo "Reading content of disk$i"
        echo "Writing content of disk$i to $OUTPUT_PATH"disk$i".txt"
        $TREE_PATH./tree_colorized.sh > $OUTPUT_PATH"disk$i".txt
        echo -e "Done with disk$i\n"
done

        echo Script finished
        exit 0
