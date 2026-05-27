# Challenge1 - Linux Service Management Challenge
## Approach
I'm using WSL on Windows 11 and have installed Ubuntu to do the tasks. Also, I'm using `cron` service because it is present by default and pre-installed.
Some of the commands below will have `sudo` because these tasks can only be done by having administrator/root privileges.
In Linux, normal users cannot change important system services.


## Step-by-Step Solution

### Step 1 : Check system info and pick a service

I checked the Ubuntu version first and if it is running or not. Then I checked if `cron` exists, as a pathway is shown, `cron` exists.
So, I decided to use `cron`.

**Command**
```bash
wsl -l -v
```
**Output**
```text
 NAME      STATE           VERSION
* Ubuntu    Running         2
```

Checking if cron exits:
**Command**
```bash
wsl which cron
```
**Output**
```text
/usr/sbin/cron
PS C:\Users\IraPatil>
```

**Screenshot**
Step 1: system info and service pick

<img width="531" height="163" alt="Screenshot 2026-05-27 145740" src="https://github.com/user-attachments/assets/84de91e1-84de-4d9a-9df5-a5bd880f0bc2" />



### Step 2 : Check if service is running and find PID

Check is service is running :
**Command**
```bash
systemctl status cron
```

**Output**
```text
 cron.service - Regular background program processing daemon
     Loaded: loaded (/usr/lib/systemd/system/cron.service; enabled; preset:>
     Active: active (running) since Wed 2026-05-27 03:15:25 UTC; 11min ago
       Docs: man:cron(8)
   Main PID: 169 (cron)
      Tasks: 1 (limit: 8774)
     Memory: 420.0K (peak: 2.3M)
        CPU: 36ms
     CGroup: /system.slice/cron.service
             └─169 /usr/sbin/cron -f -P

May 27 03:15:25 Mauve systemd[1]: Started cron.service - Regular background>
May 27 03:15:25 Mauve (cron)[169]: cron.service: Referenced but unset envir>
May 27 03:15:25 Mauve cron[169]: (CRON) INFO (pidfile fd = 3)
May 27 03:15:25 Mauve cron[169]: (CRON) INFO (Running @reboot jobs)
May 27 03:17:01 Mauve CRON[928]: pam_unix(cron:session): session opened for>
May 27 03:17:01 Mauve CRON[929]: (root) CMD (cd / && run-parts --report /et>
May 27 03:17:01 Mauve CRON[928]: pam_unix(cron:session): session closed for>
```
It gives information about other logs, Memory as well as the main PID and shows if service, here `cron` is active or not.

Now, find PID :
**Command**
```bash
pgrep cron
```

**Output**
```text
169
```

`pgrep` searches for running processes by name, i.e, `cron` is searched and it's PID is diplayed.

**Screenshot**
Step 2 : Check if service is running and find PID

<img width="944" height="441" alt="Screenshot 2026-05-27 151601" src="https://github.com/user-attachments/assets/efad04d3-3ef4-428c-afa8-d6a6fcab82fa" />

<img width="334" height="45" alt="Screenshot 2026-05-27 151949" src="https://github.com/user-attachments/assets/a54c80fd-1a27-4b73-85bf-14b37c29b261" />



### Step 3 : Stopping the service
**Command**
```bash
sudo service cron stop
```
This command halts the execution of `cron` service of Linux system which ensures that no tasks scheduled to `cron` are performed until the service is restarted.
So, changes can be made without unintentionally executing the service.
And `sudo` is needed because some services like stopping system services need administrator privileges.

**Screenshot**
Step 3 : Stop the service

<img width="517" height="39" alt="Screenshot 2026-05-27 152431" src="https://github.com/user-attachments/assets/63b125fc-2396-4f18-b49a-786e7835233c" />



### Step 4 : Confirming that the Service has stopped

This can be verified by asking to display the PID.
If serive is running then the PID can be displayed, like in Step 3.
Else, no PID is returned which confirms that the service has been stopped successfully.

**Command**
```bash
pgrep cron
```
No output is obtained.

**Screenshot**
Step 4 : Verify that PID is gone

<img width="479" height="88" alt="Screenshot 2026-05-27 152209" src="https://github.com/user-attachments/assets/51725458-b6cc-4d34-9def-17d8e526f46d" />



### Step 5 : Starting the Service again

**Command**
```bash
sudo service cron start
```
This restarts the service again, can be verified again by displaying PID

**Screenshot**
Step 5 : Start service again

<img width="535" height="69" alt="Screenshot 2026-05-27 152629" src="https://github.com/user-attachments/assets/42b43127-fc7b-46e0-985f-d2160ced29e2" />



### Step 6 : Killing the Process by using PID

First, get the PID by using command :
```bash
pgrep cron
```
**Output**
```text
5071
```
Then, for killing the process directly :
**Command**
```bash
sudo kill 5071
```
Basically, the command is :
```bash
sudo kill <PID>
```
The `kill` command directly terminates the process using it's PID.
This work on process-based management instead of service-based management.

**Screenshot**
Step 6 : Kill the process using PID

<img width="366" height="63" alt="Screenshot 2026-05-27 152841" src="https://github.com/user-attachments/assets/be93f422-5942-42b1-8d83-f856d39c91e6" />



### Step 7 : Checking Service Status after Killing

After killing, the service should have become inactive as process was terminated.
For checking status:
**Command**
```bash
service cron status
```

**Output**
```text
 cron.service - Regular background program processing daemon
     Loaded: loaded (/usr/lib/systemd/system/cron.service; enabled; preset:>
     Active: active (running) since Wed 2026-05-27 03:15:25 UTC; 11min ago
       Docs: man:cron(8)
   Main PID: 169 (cron)
      Tasks: 1 (limit: 8774)
     Memory: 420.0K (peak: 2.3M)
        CPU: 36ms
     CGroup: /system.slice/cron.service
             └─169 /usr/sbin/cron -f -P

May 27 03:15:25 Mauve systemd[1]: Started cron.service - Regular background>
May 27 03:15:25 Mauve (cron)[169]: cron.service: Referenced but unset envir>
May 27 03:15:25 Mauve cron[169]: (CRON) INFO (pidfile fd = 3)
May 27 03:15:25 Mauve cron[169]: (CRON) INFO (Running @reboot jobs)
May 27 03:17:01 Mauve CRON[928]: pam_unix(cron:session): session opened for>
May 27 03:17:01 Mauve CRON[929]: (root) CMD (cd / && run-parts --report /et>
May 27 03:17:01 Mauve CRON[928]: pam_unix(cron:session): session closed for>
```

Here, I've not used `systectl status cron` because `systemd` automatically restarts the service after killing it so it shows running/active in that case.


**Screenshot**
Step 7 : Check service status after killing it

<img width="951" height="341" alt="Screenshot 2026-05-27 153111" src="https://github.com/user-attachments/assets/ce2409e5-10fa-4355-a6a0-cd3dd35c7c0c" />



### What I learned
- Some processes require `sudo` while some don't
- Using WSL Ubuntu for basic Linux administration tasks
- Difference between stopping and killing a process directly
- Difference between systemd timer and cron and when to use which
- Services may restart automatically when `systemd` is used
