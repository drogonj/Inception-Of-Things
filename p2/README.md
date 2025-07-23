# Part 2

Setup a single-node cluster with 3 simple applications.

After configuring `/etc/hosts/` to `192.168.56.110 app1.com app2.com example.com` or simply doing `curl -H "Host:app2.com" 192.168.56.110`, each app should be accessible via HTTP, showing a `Hello from app<number> - <pod-name>` message.

app2 has 3 replicas. Then refreshing app2.com multiples times should show differents pod names.

####### More #######

* K9s installed wich provide an intuitive and simple terminal's based UI to manage/see our cluster
* Helm installed, used for Deployments and Services (Because learning a usefull tool is more fun than CTRL-C CTRL-V the same app 3 time)
