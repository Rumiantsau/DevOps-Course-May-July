# HT2 implementation

## File script.sh contains result of transformation task.

### Task definition:
sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done

### Result:

1. sudo netstat -tunapl - list all open ports
2. awk '/firefox/ {print $5}' - port filter by process name
3. cut -d: -f1 - we leave only ip-addresses, without an open port number
4. sort - sorting ip addresses
5. uniq -c - counting the number of unique ip
6. sort - sorting ip addresses
7. tail -n5 - limiting the number of displayed lines of ip-addresses
8. grep -oP '(\d+\.){3}\d+' - output by mask (regular expression) of only ip-addresses
9. "while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done" - whois command for each ip address in the loop

### For the implementation of all tasks, the initial data were checked, the input of information from the keyboard was checked, the user was checked from which the script was launched. userfriendly or displaying output. One additional task was done (number 2 additional information with whois).