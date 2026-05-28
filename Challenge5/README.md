# Challenge 5 - YARA Installation and Detection Rules
## Approach 
I'm using WSL Ubuntu on windows 11 and YARA to do the tasks.
## Step 1 - Install YARA

For Ubuntu:
Command:
```bash
sudo apt update
sudo apt install yara -y
```
The first line updates Ubuntu so that latest version of YARA can be installed.
The second line installs YARA and `-y` means all prompts are skipped and evrything required is installed.


### Verify Installation
**Command**
```bash
yara --version
```
This gives the version installed.

**Output**
```text
4.5.0
```
**Screenshots**
![Installing YARA](YARAInstall1.png)
![Verification](YARAInstall2.png)



# Step 2 - Making YARA Rules

Rules are created in a file named `rules.yar`

For creating new file use:
**Command**
```bash
nano rules.yar
```
This creates a new file with name `rules.yar`. `nano` can also be used to edit existring YARA files.

Write the rules :
**Command**
```yara
rule Detect_Mimikatz_Process
{
    meta:
        description= "detects process name mimikatz"

    strings:
        $mz = "mimikatz" nocase

    condition:
        $mz
}

rule Detect_Shadow_Path
{
    meta:
        description= "detects access to /etc/shadow"

    strings:
        $shadow = "/etc/shadow"

    condition:
        $shadow
}

rule Detect_Reverse_Shell
{
    meta:
        description= "detects reverse shell indicators"

    strings:
        $rs = /reverse[_ ]shell/i

    condition:
        $rs
}
```
- `$` is used for YARA variable names
- `nocase` is used in strings for case-insensitive matching
- `/i` is used after regex for case-insensitivity
- `[_ ]` means both `_` and ` ` can be present and are considered


# Step 3 - Create Sample Trigger Files

##File for mimikatz rule

```bash
echo "this process is mimikatz" > mimikatz_sample.txt
```
This creates a new text file named mimikatz_sample.txt with content written in "...".

##File for /etc/shadow rule

```bash
echo "/etc/shadow contains password hashes" > shadow_sample.txt
```
Creates text file names shadow_sample.txt with content inside "..."

## File for reverse_shell rule

```bash
cho "reVeRSe_shELl connection established" > reverse_shell_
sample.txt
```
creates a text file named reverse_shell_sample.txt with content in "..."



# Step 4 - Run YARA Against Files

## Using mimikatz sample file

**Command**
```bash
yara rules.yar mimikatz_sample.txt
```

**Output**
```bash
Detect_Mimikatz_Process mimikatz_sample.txt
```


## Using shadow sample file

**Command**
```bash
yara rules.yar shadow_sample.txt
```

**Output**
```bash
Detect_Shadow_Path shadow_sample.txt
```


## Using reverse shell sample file

**Command**
```bash
yara rules.yar reverse_shell_sample.txt
```

**Output**
```bash
Detect_Reverse_Shell reverse_shell_sample.txt
```

**Screenshots**
![mimikatz process](YARA_mimikatz.png)
![shadow file path](YARA_shadow.png)
![reverse shell string](YARA_rev_shell.png)


# Step 5 - Difference Between Matching on a File vs a Running Process

## File Matching

* YARA scans files stored on disk.
* It checks file contents against rule patterns for malware.
* Commonly used for malware analysis and file scanning.
* It is static scanning.

Example for searching in file:

```bash
yara rules.yar suspicious_file.exe
```

## Running Process Matching

* YARA scans the memory of an active process.
* It detects malicious strings or code loaded during execution.
* Useful for detecting malware that only exists in memory.
* It is live/dynamic scanning.

Example for searching in running process:

```bash
sudo yara rules.yar <PID>
```

Where `<PID>` is the process ID.
As the process is running the PID is need to serach in it.

-Process scanning matters because 
 - Some malware delets itself from disk
 - Runs only in memory and might affect other processes

# Step 6 - Adding a New Detection Rule Without Restarting the Service

A running monitoring service can reload YARA rules dynamically by:

* Watching the rule directory for changes
* Reloading `.yar` files automatically without restarting the service
* Using signals such as `SIGHUP`
* Using hot-reload functionality built into the service

Example:

```bash
kill -HUP <PID>
```
- `kill` does NOT always terminate a process, is used to send signals to processes.
- `-HUP` send a `SIGHUP` or a "hang up signal" which reloads rules without restarting the service.
- `<PID>` is the PID of the running service in which we are checking and need to reload YARA rules.


## What I learnt
- What YARA is and how it detects suspicious strings or malware
- difference between running process matching and file matching
- how YARA rules are made
- Regex and String matching
- Basic Linux commands
