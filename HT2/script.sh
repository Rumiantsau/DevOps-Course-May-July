#!/bin/bash
set -e # Exit immediately if a simple command exits with a non-zero status
#set -x # Activate debugging from here

# Key for netstat command
 netStatPar="-tunapl"

# Checking script run privileges root / non root
if  [ $(id -u) = 0 ]
 then
        echo ====================================================
        echo "-----------The Script is run as root!-------------"
        echo ====================================================
else

        echo ====================================================
        echo "------The script is run without root rights!------"
        echo ====================================================
fi

# Check for empty input
function empty_input {
if [ -z "$processName" ]
  then
        echo ====================================================
        echo "error: No argument supplied. Script will be finish"
        echo ====================================================
    exit 1
fi
}

# Check for numeric input
function number_input {
re='^[0-9]+$'
if ! [[ $quLines =~ $re ]] ; then
        echo ====================================================
        echo "----error: Not a number. Script will be finish----" >&2; show_connects_stat=0; exit 1
        echo ====================================================
fi
}

#
function scriptRun {
        echo ====================================================
        echo "-------------Output script result-----------------"
netstat "$netStatPar" 2>/dev/null |
awk '/'$processName'/ ''{print $5}'|
cut -d: -f1 |
sort |
uniq -c |
sort |
tail -n"$quLines" |
grep -oP '(\d+\.){3}\d+' |
while read IP ; do whois $IP |
awk -F':' '/^Organization/ {print $2}'; done
        echo "------------------Script end----------------------"
        echo ====================================================
exit 1
}

# Command execution without outputting additional data
function show_without_columns {
read -p "Show other columns in whois output? (Y/N): " confirm && [[ $confirm == [yY] ||
 $confirm == [yY][eE][sS] ]] || scriptRun
echo "Input additional column name for whois"
read addInWhois
netstat "$netStatPar" 2>/dev/null |
awk '/'$processName'/ ''{print $5}'|
cut -d: -f1 |
sort |
uniq -c |
sort |
tail -n"$quLines" |
grep -oP '(\d+\.){3}\d+' |
while read IP ; do whois $IP |
awk -F':' '/^Organization/ || ''/'$addInWhois'/ ''{print $1 $2}'; done
        echo "------------------Script end---------------------"
        echo ===================================================
exit 1
}

# Сommand execution with additional data output
function show_with_columns {
        echo ===================================================
        echo "-------Table with other second informations------"
        echo ===================================================
netstat "$netStatPar" 2>/dev/null | awk '/'$processName'/ ''{print $5 "        " $6}'
read -p "Show other columns in whois output? (Y/N): " confirm && [[ $confirm == [yY] ||
 $confirm == [yY][eE][sS] ]] || scriptRun
echo "Input additional column name for whois"
read addInWhois
netstat "$netStatPar" 2>/dev/null |
awk '/'$processName'/ ''{print $5}'|
cut -d: -f1 |
sort |
uniq -c |
sort |
tail -n"$quLines" |
grep -oP '(\d+\.){3}\d+' |
while read IP ; do whois $IP |
awk -F':' '/^Organization/ || ''/'$addInWhois'/ ''{print $1 $2}'; done
        echo "-----------------Script end----------------------"
        echo ===================================================
exit 1
}

echo "Please, enter proces's name: "
read processName

empty_input

echo "Please, enter quantity displayed lines"
read quLines

number_input

# Processing a request to display additional information (Yes/No)
read -p "Show other columns state? (Y/N): " confirm && [[ $confirm == [yY] ||
 $confirm == [yY][eE][sS] ]] || show_without_columns
show_with_columns