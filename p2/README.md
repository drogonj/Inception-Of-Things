# Part 1

Setup 2 machines using Vagrant.

* Both have K3s installed
* First one is called {`whoami`}S(erver) which is the **master node**
* Second one is called {`whoami`}S(erver)W(orker) wich is an **agent node**

Each VM got an given IP and can be reach via SSH without password.

Our **agent node** is connected to our master.

```
host> vagrant up
.................
#Lets say my login is "bob"
host> vagrant ssh bobS
.................
vagrant@bobS> kubectl get nodes -o wide
NAME         STATUS   ROLES                  AGE   VERSION        INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION    CONTAINER-RUNTIME
bobs    Ready    control-plane,master   93s   v1.32.4+k3s1   192.168.56.110   <none>        Debian GNU/Linux 11 (bullseye)   5.10.0-32-amd64   containerd://2.0.4-k3s2
bobsw   Ready    <none>                 32s   v1.32.4+k3s1   192.168.56.111   <none>        Debian GNU/Linux 11 (bullseye)   5.10.0-32-amd64   containerd://2.0.4-k3s2

```
