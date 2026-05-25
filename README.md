# Power Watchdog
*This script is for a lab environment and meant for learning purposes only*

## What does it do?
- The script pings two network devices that are ideally not connected to a backup power supply like a UPS,
- Issue a shutdown command to Proxmox when two network devices are unreachable for longer than the threshold.

## What does it solve?
- Data Corruption Mitigation: Prevents dirty power cycles that corrupt core databases (such as Active Directory's ntds.dit).
- Cluster Integrity: Eliminates DFS-R (Distributed File System Replication) desynchronization issues caused by abrupt node failures.
- Hardware Longevity: Ensures enterprise local storage (ZFS/RAID arrays) commits all data to disk before loss of power.

## Who's it for?
Home lab enthusiasts or small business environments running a headless Proxmox VE or 
Linux server attached to an unmanaged ("dumb") UPS that lacks a native USB/network signaling interface.

## Requirements
Before deploying this script, ensure your environment meets the following conditions:
- A working Proxmox VE or Debian/Ubuntu-based host.
- At least two target network devices assigned Static IPs that sit outside your UPS power backup loop (e.g., your primary ISP gateway and an auxiliary network switch).
- Root or sudo privileges on the host machine.

## Warning
- You should absolutely let Proxmox handle the VM shutdown in sequence. 

## Limitations
- No UPS runtime awareness — it doesn't know how much battery is left, it only infers power state from ping reachability
- ICMP dependent — if targets block ping, this won't work
- Shutdown is immediate once threshold is reached — no pre-shutdown notification or hook
- Not a replacement for proper UPS management tools like NUT or apcupsd if your UPS supports them


### Run in SystemD

```bash
# Create systemd service
nano /etc/systemd/system/power-watchdog.service

[Unit]
Description=Power Loss Detection Script
After=network.target

[Service]
ExecStart=/usr/local/bin/power-watchdog.sh
Restart=always

[Install]
WantedBy=multi-user.target


# Enable
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable power-watchdog
systemctl start power-watchdog

# Check Status
systemctl status power-watchdog

# Verification
systemctl is-enabled power-watchdog
```
