# HT1 implementation

# Solution
* Default key pair files stored into key_certs folder and named are "id_rsa.pub" and "id_rsa".
* Don't forget to change <ssh_user>, <root_password>, <ssh_password>, <path_to_key_file_into_key_certs_folder> into hosts.txt.
* Run ansible command "ansible-playbook playbook.yml -i hosts.txt".
* Use key "-k" for curl to ignore cert issue.  
For example "curl -k -XPOST -d'{"animal":"cow", "sound":"moooo", "count": 3}' https://myvm.localhost/".


# HT1 Task 
# Ansible assignment
## Create and deploy your own service
### The development stage:
For the true enterprise grade system we will need Python3, Flask and emoji support. Why on Earth would we create stuff that does not support emoji?!

* the service listens at least on port 80 (443 as an option)
* the service accepts GET and POST methods
* the service should receive `JSON` object and return strings in the following manner:
```sh
curl -XPOST -d'{"animal":"cow", "sound":"moooo", "count": 3}' http://myvm.localhost/
cow says moooo
cow says moooo
cow says moooo
Made with ❤️ by %your_name

curl -XPOST -d'{"animal":"elephant", "sound":"whoooaaa", "count": 5}' http://myvm.localhost/
elephant says whoooaaa
elephant says whoooaaa
elephant says whoooaaa
elephant says whoooaaa
elephant says whoooaaa
Made with ❤️ by %your_name
```
* bonus points for being creative when serving `/`

### Hints
* [installing flask](https://flask.palletsprojects.com/en/1.1.x/installation/#installation)
* [become a developer](https://flask.palletsprojects.com/en/1.1.x/quickstart/)
* [or whatch some videos](https://www.youtube.com/watch?v=Tv6qXtc4Whs)
* [dealing with payloads](https://www.digitalocean.com/community/tutorials/processing-incoming-request-data-in-flask)
* [Flask documentation](https://flask.palletsprojects.com/en/1.1.x/api/#flask.Request.get_json)
* [The database](https://emojipedia.org/nature/)
* 🐘 🐮 🦒
* what would you expect to see when visiting a random unknown website?

### The operating stage:
* create an ansible playbook that deploys the service to the VM
* make sure all the components you need are installed and all the directories for the app are present
* configure systemd so that the application starts after reboot
* secure the VM so that our product is not stolen: allow connections only to the ports 22,80,443. Disable root login. Disable all authentication methods except 'public keys'.
* bonus points for SSL/HTTPS support with self-signed certificates
* bonus points for using ansible vault

### Requirements
* Debian 10
* VirtualBox VM
