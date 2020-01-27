#!/bin/bash
validateArgs() {
    if (( $# != 2 )); then
        echo "Illegal number of parameters" >&2
        exit 1
    fi
    
    if [ ! -d "$1" ] && [ ! -f "$1" ]
    then
        echo file or directory does not exists >&2
        exit 1
    fi
    
    checkIfNotNumber='^[0-9]+$'
    if ! [[ $2 =~ $checkIfNotNumber ]] ; then
       echo "not a number" >&2
       exit 1
    fi
}

removeOldBackups() {
    filePattern=$1--??????????????????????????????.tar.gz
    filesInBackups=$(ls $filePattern -1)
    filesCount=$(ls $filePattern | wc -l)
    
    for fileName in $filesInBackups
    do
        if (( filesCount >= $2 )); then
            filesCount=$((filesCount-1))
            rm -f $fileName
        fi
    done
}

createBackUpRouteIfNotExist() {
    if [ ! -d "$1" ]
    then
        mkdir $1
    fi    
}

#validate args
validateArgs $1 $2

# process backup folder
backupRoute='/tmp/backups'
createBackUpRouteIfNotExist $backupRoute
cd $backupRoute

# replace / with - and remove first one       
bckpName=$(echo $1 | tr / - )
if [[ $bckpName == -* ]]; then
    bckpName=${bckpName:1}
fi

# remove old backupds and genereate the new one if allowed
removeOldBackups $bckpName $2
if (( $2 > 0 )); then
  bckpName=${bckpName}--$(date +%F--%H-%M-%S-%N).tar.gz
  tar -zcf "$backupRoute/$bckpName" "$1"  >/dev/null 2>&1
else
   echo "only 0 backups allowed" >&2 
fi

exit 0