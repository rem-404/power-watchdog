# Power Management Watchdog
*A poorman's UPS signaling system*

### What does it do?
- The script pings two network devices that are ideally not connected to a backup power supply like a UPS,
- Issue a shutdown command to Proxmox when two network devices are unreachable for longer than the threshold.

### What does it solve?
- Data Corruption Mitigation: Prevents dirty power cycles that corrupt core databases (such as Active Directory's ntds.dit).
- Cluster Integrity: Eliminates DFS-R (Distributed File System Replication) desynchronization issues caused by abrupt node failures.
- Hardware Longevity: Ensures enterprise local storage (ZFS/RAID arrays) commits all data to disk before loss of power.

### Who's it for?
Home lab enthusiasts or small business environments running a headless Proxmox VE or 
Linux server attached to an unmanaged ("dumb") UPS that lacks a native USB/network signaling interface.

### Prerequisites
Before deploying this script, ensure your environment meets the following conditions:
- A working Proxmox VE or Debian/Ubuntu-based host.
- At least two target network devices assigned Static IPs that sit outside your UPS power backup loop (e.g., your primary ISP gateway and an auxiliary network switch).
- Root or sudo privileges on the host machine.

### Warning
- You should absolutely let Proxmox handle the VM shutdown in sequence. 
