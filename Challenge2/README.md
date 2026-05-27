# Challenge 2 - OSQuery Setup and Exploration

The goal of this task is to setup OSQuery on Ubuntu system, manage its service using `systemctl` and see status of tasks, and get information using SQL queries.

## Step 1 - Update Ubuntu
**Command**
```bash
sudo apt update
```
If the Ubuntu is outdated then it may not be able to download OSQuery.

## Step 2 - Installing OSQuery

**Command**
```bash
sudo apt install osquery -y
```
To verify installation:
**Command**
```bash
osqueryi --version
```

If you get an error, then OSQuery repository has to be added manually on Ubuntu.
In this case, first add a GPG key, then add the repository, then update package and install OSQuery.

For adding GPG key : 
**Command**
```bash
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://pkg.osquery.io/deb/pubkey.gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/osquery.gpg
```
For adding the repository: 
**Command**
```bash
echo "deb [signed-by=/etc/apt/keyrings/osquery.gpg] https://pkg.osquery.io/deb deb main" | \
sudo tee /etc/apt/sources.list.d/osquery.list
```
Then update package and install OSQuery and verify installation.


## Step 3 - Start the OSQuery Service

**Command**
```bash
sudo systemctl start osqueryd
sudo systemctl status osqueryd
```
The first line starts the service and the second line displays the status (active/inactive).
Here, `sudo` is required because the process needs root privileges.
And `systemctl` is used

**Screenshot:**
Starting OSQuery

<img width="933" height="368" alt="Screenshot 2026-05-28 003821" src="https://github.com/user-attachments/assets/ae2ce3df-8ef8-43dd-9283-88574f331247" />


## Step 4 - Stop the OSQuery service

**Command**
```bash
sudo systemctl stop osqueryd
sudo systemctl status osqueryd
```
After the second command, the process stops running / becomes inactive.

**Screenshot:**
Stopping OSQuery
<img width="927" height="370" alt="Screenshot 2026-05-28 004106" src="https://github.com/user-attachments/assets/2f35df84-d3c7-4cff-9c0a-4062aeac97f6" />


## Step 5 - Open OSQuery interactive shell

**Command**
```bash
osqueryi
```

This allows the user to directly use SQL to do tasks.

## Step 6 - Run SQL Queries

For JSON format output,
**Command**
```bash
.mode json
```
If in your case, this is not supported by existing OSQuery, you can manually convert it to `json` while adding.

### For System Info :

Use the below command in query interactive shell
**Command**
```sql
SELECT * FROM system_info;
```
Selects all from table named system_info in Ubuntu.

The `json` output is :
**Output**
```json
[
  {
    "hostname": "Mauve.localdomain",
    "uuid": "c40b2672-1d5b-4e60-97be-5bdeab01fdd8",
    "cpu_type": "x86_64",
    "cpu_subtype": "68",
    "cpu_brand": "AMD Ryzen 7 7735HS with Radeon Graphics",
    "cpu_physical_cores": "8",
    "cpu_logical_cores": "16",
    "cpu_sockets": "1",
    "cpu_microcode": "0xffffffff",
    "physical_memory": "7677755392",
    "hardware_vendor": "",
    "hardware_model": "",
    "hardware_version": "",
    "hardware_serial": "",
    "board_vendor": "",
    "board_model": "",
    "board_version": "",
    "board_serial": "",
    "computer_name": "Mauve",
    "local_hostname": "Mauve.localdomain"
  }
]
```

### For Platform Info :

Use the below command in query interactive shell.
**Command**
```sql
SELECT * FROM os_version;
```
Selects all from table named os_version.
This gives us information about system/platform such as Ubuntu version,platform name etc.

The `json` output is :
**Output**
```json
[
  {
    "name": "Ubuntu",
    "version": "24.04.1 LTS (Noble Numbat)",
    "major": "24",
    "minor": "4",
    "patch": "0",
    "build": "",
    "platform": "ubuntu",
    "platform_like": "debian",
    "codename": "noble",
    "arch": "x86_64"
  }
]
```

### For Battery Info

For getting battery info write inside query shell:
**Command**
```sql
SELECT * FROM battery;
```
Selects all from table named battery.

A lot of times, no output is given in this case, or an error as :
```text
Error: no such table: battery
```
This can be because of many reasons, some of which are :
- Using Virtual Machine
- Your PC system may not have a battery
- Ubuntu cannot detect battery hardware
- Battery data no exposed to OS guest

In such case use the steps below:

## Step 7 - Check if OSQuery diplays power sources

**Command**
```bash
upower -e
```
This should display all power sources like battery and AC supply.
If not installed, it should be installed
### Installing upower
**Command**
```bash
sudo apt install upower
```
Not that this requires root privileges.
After installation of `upower`, install ACPI tools
### Installing APCI tools
**Command**
```bash
sudo apt install acpi -y
```
This installs the `acpi` advanced package tools which gives tools to read battery and power status.
`-y` installs everything required, no prompts appear.

Now, check battery or power status
**Command**
```bash
acpi -V
```
This shows detailed information about the battery percentage, charging/discharging.
If `apci -V` gives errors or no output then either the device has no battery or it cannot be detected.
Output can be seen
```text
Battery 0: Discharging, 87%, 12:17:44 remaining
```
In `json` format:
```json
[
  {
    "battery": "Battery 0",
    "state": "Discharging",
    "percentage": "87%",
    "time_remaining": "12:17:44"
  }
]
```

### Or after installing you can use `upower` for getting battery level

First, write
```bash
upower -i $(upower -e | grep BAT)
```
Step-by-Step explanation of this is :
- `upower -e` gives all power devices in Ubuntu like AC source and battery.
- `grep BAT` finds the line that shows battery only.
   The betteries are represented by `upower` as BAT0, BAT1, and so on.
- `$(...)` takes the output of command in paranthesis and uses it where $ sign is.
- `-i` shows detailed information about the device.
- So, the whole command finds the battery device and displays detailed information about it.

 The output in `json` format is :
 ```json
[
  {
    "native_path": "BAT1",
    "model": "Microsoft Hyper-V Virtual Battery",
    "serial": "Virtual",
    "power_supply": "yes",
    "updated": "Wed May 27 12:48:30 2026",
    "has_history": "yes",
    "has_statistics": "yes",
    "battery": {
      "present": "yes",
      "rechargeable": "yes",
      "state": "discharging",
      "warning_level": "none",
      "energy_wh": "4.354",
      "energy_empty_wh": "0",
      "energy_full_wh": "5",
      "energy_full_design_wh": "5",
      "energy_rate_w": "0.432",
      "voltage_v": "5",
      "charge_cycles": "N/A",
      "time_to_empty_hours": "10.1",
      "percentage": "87%",
      "capacity": "100%",
      "icon_name": "battery-full-symbolic"
    },
    "history": {
      "charge": [
        {
          "timestamp": "1779886023",
          "percentage": "87.000",
          "state": "discharging"
        }
      ],
      "rate": [
        {
          "timestamp": "1779886023",
          "rate_w": "0.432",
          "state": "discharging"
        }
      ]
    }
  }
]
```

## Results or What I learned
- Install OSQuery on your Linux system. 
- Start the OSQuery service. 
- Stop the OSQuery service.
- Open the OSQuery interactive shell (osqueryi).
- Run SQL queries to get the following
 - Platform info
 - Battery info 
- While trying to get battery info, a lot of new steps have to be done and new processes were introduced.
- Converting terminal output to `json` output.
