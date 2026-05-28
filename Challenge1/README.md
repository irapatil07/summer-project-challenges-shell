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
![System info and service pick](cron_sys_info.png)



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
![Check if service is running](cron_status.png)
![Find PID](find_PID.png)




### Step 3 : Stopping the service
**Command**
```bash
sudo service cron stop
```
This command halts the execution of `cron` service of Linux system which ensures that no tasks scheduled to `cron` are performed until the service is restarted.
So, changes can be made without unintentionally executing the service.
And `sudo` is needed because some services like stopping system services need administrator privileges.

**Screenshot**
![Stop the service](cron_stop.png)



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
![Verify PID is gone i.e cron stopped](verify_cron_stop.png)



### Step 5 : Starting the Service again

**Command**
```bash
sudo service cron start
```
This restarts the service again, can be verified again by displaying PID

**Screenshot**
![Start service again](cron_start_again.png)



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
![Kill the process using PID](cron_kill.png)



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

Here, I've not used `systectl status cron` because `systemd` may automatically restarts the service after killing it so it shows running/active in that case.


**Screenshot**
![Check service status after killing it](status_after.png)



### What I learned
- Some processes require `sudo` while some don't
- Using WSL Ubuntu for basic Linux administration tasks
- Difference between stopping and killing a process directly
- Difference between systemd timer and cron and when to use which
- Services may restart automatically when `systemd` is used
