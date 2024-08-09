#!/bin/bash
# Parameters

    LOGDATE=`date "+%Y%m%d"`
    BASEDIR=$(dirname $0)
    CURDIR=$(pwd)
    HOMEDIR=~/auto-attachment-printer 
    MAILDIR=~/auto-attachment-printer/maildata
    LOGFILE=~/auto-attachment-printer/logs/printmail-$LOGDATE.log
    ATTACH_DIR=~/auto-attachment-printer/attachments
    DATE=`date "+%d-%m-%Y %H:%M:%S"`

WAKEUP="03:30" # Wake up at this time tomorrow and run a command

DATE=`date "+%d-%m-%Y %H:%M:%S"`
echo $DATE " | " $HOSTNAME " | Booting Auto-Attachment-Process" | tee -a $LOGFILE

# change directory
echo $DATE " | " $HOSTNAME " | Switching directory to : $BASEDIR"
cd $BASEDIR
# create log file if it does not exist
touch $LOGFILE
date +%r-%-d/%-m/%-y >> $LOGFILE
# fetch mail
echo $DATE " | " $HOSTNAME " | Checking for new mail..."
fetchmail -f $HOMEDIR/fetchmail.conf -L $LOGFILE
# process new mails
shopt -s nullglob
for i in $MAILDIR/new/*
do
  echo $DATE " | " $HOSTNAME " | Processing : $i" | tee -a $LOGFILE
  uudeview $i -i -p $ATTACH_DIR/
# process file attachments with space (thanks to Dr.B.)
   cd $ATTACH_DIR
   for e in ./*
       do
           mv "$e" "${e// /_}"
   done
   for f in *.PDF
       do
       mv $f ${f%.*}.pdf
   done
   cd $BASEDIR
# end of Dr.B. patch
  echo $DATE " | " $HOSTNAME " | Printing PDFs" | tee -a $LOGFILE
  for x in $ATTACH_DIR/*.pdf
  do
          echo $DATE " | " $HOSTNAME " | Printing : $x" | tee -a $LOGFILE
          lp $x | tee -a $LOGFILE
          echo $DATE " | " $HOSTNAME " | Deleting file : $x" | tee -a $LOGFILE
          rm $x | tee -a $LOGFILE
  done
  echo $DATE " | " $HOSTNAME " | Clean up and remove any other attachments"
  for y in $ATTACH_DIR/*
  do
          rm $y
  done
  # delete mail
  echo $DATE " | " $HOSTNAME " | Deleting mail : $i" | tee -a $LOGFILE
  rm $i | tee -a $LOGFILE
done
shopt -u nullglob
echo $DATE " | " $HOSTNAME " | Job finished at:" $DATE | tee -a $LOGFILE
cd $CURDIR


# -----------------------Loop-------------------------------------


while :
do
    LOGDATE=`date "+%Y%m%d"`
    BASEDIR=$(dirname $0)
    CURDIR=$(pwd)
    HOMEDIR=~/auto-attachment-printer 
    MAILDIR=~/auto-attachment-printer/maildata
    LOGFILE=~/auto-attachment-printer/logs/printmail-$LOGDATE.log
    ATTACH_DIR=~/auto-attachment-printer/attachments
    DATE=`date "+%d-%m-%Y %H:%M:%S"`

    NEXTRUN=$(date +%d-%m-%Y -d "+1 day")
    TIME=$(date +%H:%M:%S)
    SECS=$(expr `date -d "tomorrow $WAKEUP" +%s` - `date -d "now" +%s`)
    
    echo " " | tee -a $LOGFILE
    echo $DATE " | " $HOSTNAME " | Next run will be on" $NEXTRUN "at" $WAKEUP | tee -a $LOGFILE
    echo " " | tee -a $LOGFILE
    sleep $SECS & 
    wait $!
    echo $DATE " | " $HOSTNAME " | Starting process..." | tee -a $LOGFILE
    # Run your command here

# change directory
echo $DATE " | " $HOSTNAME " | Switching directory to : $BASEDIR"
cd $BASEDIR
# create log file if it does not exist
touch $LOGFILE
date +%r-%-d/%-m/%-y >> $LOGFILE
# fetch mail
echo $DATE " | " $HOSTNAME " | Checking for new mail..."
fetchmail -f $HOMEDIR/fetchmail.conf -L $LOGFILE
# process new mails
shopt -s nullglob
for i in $MAILDIR/new/*
do
  echo $DATE " | " $HOSTNAME " | Processing : $i" | tee -a $LOGFILE
  uudeview $i -i -p $ATTACH_DIR/
# process file attachments with space (thanks to Dr.B.)
   cd $ATTACH_DIR
   for e in ./*
       do
           mv "$e" "${e// /_}"
   done
   for f in *.PDF
       do
       mv $f ${f%.*}.pdf
   done
   cd $BASEDIR
# end of Dr.B. patch
  echo $DATE " | " $HOSTNAME " | Printing PDFs" | tee -a $LOGFILE
  for x in $ATTACH_DIR/*.pdf
  do
          echo $DATE " | " $HOSTNAME " | Printing : $x" | tee -a $LOGFILE
          lp $x | tee -a $LOGFILE
          echo $DATE " | " $HOSTNAME " | Deleting file : $x" | tee -a $LOGFILE
          rm $x | tee -a $LOGFILE
  done
  echo $DATE " | " $HOSTNAME " | Clean up and remove any other attachments"
  for y in $ATTACH_DIR/*
  do
          rm $y
  done
  # delete mail
  echo $DATE " | " $HOSTNAME " | Deleting mail : $i" | tee -a $LOGFILE
  rm $i | tee -a $LOGFILE
done
shopt -u nullglob
echo $DATE " | " $HOSTNAME " | Job finished at:" $DATE | tee -a $LOGFILE
cd $CURDIR

done
