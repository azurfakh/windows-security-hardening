# Windows Security Hardening

A hands-on project from my cybersecurity training on securing Windows with
its built-in tools: local group policies, PowerShell automation, BitLocker
disk encryption, user rights assignment, and Windows Defender Firewall
rules. The goal was to learn the settings that protect a Windows machine,
and to automate checking them, so the same approach works on a server.

> Note: the work was done in a Windows virtual machine with a Russian
> interface, so some output files (such as the BitLocker status) are in
> Russian. This README summarizes them in English.

## Tasks

### 1. Password Policy and Policy Export Script
Configured the local security policy (`gpedit.msc`):
- Minimum password length: 8 characters
- Password complexity requirement: enabled
- Maximum password age: 30 days

Wrote `get_sec_pol.ps1`, a PowerShell script that refuses to run unless
it has Administrator rights and then exports the device's current security
policy with `secedit`. This makes it quick to inspect the settings of any
Windows machine, including servers.
- **Files:** `Task_1/get_sec_pol.ps1`, `Task_1/secpol.txt`

### 2. Volume Encryption with BitLocker
Encrypted the Windows system volume with BitLocker, using a password
protector. The `manage-bde -status` output shows the volume fully
encrypted (100%) with XTS-AES 128 and protection turned on.
- **Files:** `Task_2/crypt.txt`

### 3. User Rights Assignment
Changed user rights in the Local Security Policy, then reused the Task 1
script to export the result. The exported policy shows:
- Network logon denied for the Guest account
- The backup right limited to the Administrators group (by default,
  Backup Operators also had it)
- The "Shut down the system" right no longer assigned to any group
- A deny rule for Remote Desktop (RDP) logon, applied to the
  Authenticated Users group (a deny rule overrides any allow, so this
  also covers administrators)
- **Files:** `Task_3/get_sec_pol.ps1`, `Task_3/secpol_2.txt`

### 4. Windows Firewall Rules
Created four named firewall rules and wrote `get_fw_rules.ps1`, which
lists only these rules with their name, state, direction, protocol,
ports, action and profile.

| Rule | Direction | Traffic | Action |
|------|-----------|---------|--------|
| Block_http_conn | Inbound | TCP port 80 | Block |
| Allow_rdp_conn | Inbound | TCP port 3389 | Allow |
| Block_ftp_conn | Outbound | TCP port 21 | Block |
| Block_ping_conn | Inbound | ICMPv4 (ping) | Block |

All rules are enabled and apply to every profile.
- **Files:** `Task_4/get_fw_rules.ps1`, `Task_4/result.txt`

## Skills Demonstrated
- Windows local security policy and group policy
- PowerShell scripting (privilege check, exporting settings, filtering
  and formatting objects)
- Full-disk encryption with BitLocker
- Principle of least privilege (user rights, backup and RDP restrictions)
- Host firewall rules for inbound and outbound traffic

## Key Takeaways
- Windows security works in layers (firewall, policies, encryption,
  access control), and all of them need to be configured
- Scripts make security settings repeatable and easy to audit
- Exporting the applied policy and reading it is the reliable way to
  check that a setting really is what you intended
- Explicit deny rules take priority over allow rules in the Windows
  firewall, and more specific rules win over general ones

## Disclaimer
All work was done for educational purposes in a lab environment.
