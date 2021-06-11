
#!/bin/bash
set -e # Exit immediately if a simple command exits with a non-zero status

#set -x # Activate debugging from here

function empty_input {
if [ -z "$processName" ]
  then
    echo "error: No argument supplied. Script will be finish"
    exit 1
fi
}

function number_input {
re='^[0-9]+$'
if ! [[ $quLines =~ $re ]] ; then
  echo "error: Not a number. Script will be finish" >&2; show_connects_stat=0; exit 1
fi
}

function show_without_columns {
netstat -tunapl |
awk '/'$processName'/ ''{print $5}'|
cut -d: -f1 |
sort |
uniq -c |
sort |
tail -n"$quLines" |
grep -oP '(\d+\.){3}\d+' |
while read IP ; do whois $IP |
awk -F':' '/^Organization/ {print $2}'; done
exit 1
}

function show_with_columns {
echo "___________Table with other second informations----------"
netstat -tunapl | awk '/'$processName'/ ''{print $5 "        " $6}'
#clear
#echo "-----------Table with other second information-----------"
netstat -tunapl | awk '/'$processName'/ ''{print $5}'|
cut -d: -f1 |
sort |
uniq -c |
sort |
tail -n"$quLines" |
grep -oP '(\d+\.){3}\d+' |
while read IP; do whois $IP |
awk -F':' '/^Organization/ {print $2}'; done
exit 1
}

echo "Please, enter proces's name: "
read processName

empty_input

echo "Please, enter quantity displayed lines"
read quLines

number_input

read -p "Show other columns state? (Y/N): " confirm && [[ $confirm == [yY] ||
 $confirm == [yY][eE][sS] ]] || show_without_columns

show_with_columns