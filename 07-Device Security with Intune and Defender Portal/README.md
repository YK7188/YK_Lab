## Object

Simulate a real-world security baseline by utilizing Intune and Defender Portal.
Configure AV policy, Firewall policy and Attack surface reduction policy, followed up by observing an security event in Defender Portal. 

-----

## Configure Antivirus policy

🔹 Endpoint Security > Antivirus > Create Policy


Commonly set up configurations include:
1. Allow Behavior Monitoring

Detects threats not only by known malware signatures, but also by analyzing process behavior. It can block new malware by detecting suspicious actions such as mass file modification (ransomware-like activity), abnormal PowerShell usage, or attempts to disable security features. 

2. Allow Cloud Protection

Without cloud protection, malware detection relies solely on locally stored malware signatures. With it turned on, suspicious files can be inspected by Microsoft's cloud intelligence for unknown malware.

3. Submit Samples Consent > Send safe samples automatically
   
Allows Defender to upload suspicious files to Microsoft for deeper analysis when local and cloud checks are inconclusive.

4. Allow Archive Scanning

Scan inside conpressed files such as .zip, .rar.

5. Scanning
- Scan Parameter > Quick Scan
- Schedule Quick Scan Time > 180 (3:00 daily)
- Schedule Scan Day > Every day

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/01.%20configuring%20policies.jpg" width="600">

---

## Configure Firewall policy

🔹1. Endpoint Security > Windows Firewall > Create Policy

Typical configurations include:
- Enable firewall on all profiles
  - Domain → ON
  - Private → ON
  - Public → ON

- Default traffic behavior
  - Inbound → Block
  - Outbound → Allow
 
- Enable Log Dropped Packets
- Open a paticular TCP port
  - i.e., TCP 8443 for an internal app access
    
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/02.%20FWPolicies.jpg" width="600">

🔹2. Endpoint Security > Weindows Firewall Rules > Create Policy

- Rule 1 (Allow TCP port 8080 to access a web application)
  - Direction: Inbound
  - Protocol: TCP (integar 6)
  - Local Port Ranges: 8080
  - Remote Address Ranges: *
  - Network types: All networks (Doamin, Private, Public)

- Rule 2 (Block TCP port 445 to block network share on Public)
  - Direction: Outbound
  - Protocol: TCP (integar 6)
  - Remote Port Ranges: 445
  - Remote Address Ranges: *
  - Network types: Public

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/05.%20FW_Rules_Policy.jpg" width="600">

---

## Configure Attack Surface Reduction Policy

🔹 Endpoint Security > Attack surface reduction > Create Policy

- Block all Office applications from creating child processes

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/07.%20ASR_Creation1.jpg" width="600">

---

## Verify the applied policies on the endpoint.

- Antivirus Policy: "setting is managed by administrator" message appears
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/03.%20AVApplied.jpg" width="600">

- Windows Firewall Policy: "setting is managed by administrator" message appears
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/04.%20FW%20policy%20applied.jpg" width="600">

- Windows Firewall Rules Policy: wf.msc > Monitoring > Firewall
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/06.%20FW_rules_policy_shown.jpg" width="600">

  - For an issue where the configured Firewall policy rules are not seen on the endpoint:
    - [08-FW rules policy do not appear on endpoint](/08-FW%20rules%20policy%20do%20not%20appear%20on%20endpoint/)

- Attack Surface Reduction Policy: "Get-MpPreference" command
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/08.%20ASR_applied.jpg" width="600">

---

## Onboard endpoint to Defender Portal

- Navigate Settings > Endpoints and download the onboard script.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/11.%20DefenderOnboardingScript.jpg" width="600">

- Run the script on the target endpoint and it will appear in Device Inventory
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/12.deviceshown.jpg" width="600">

---

## Simulate a security event

- Run a macro to launch cmd.exe and the "Action Blocked" pop up appears.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/10.%20action_blocked.jpg" width="600">

- Check Timeline of the test endpoint and the message "EXCEL.EXE was blocked by the attack surface reduction (ASR) rule" appears.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/13.Timeline.jpg" width="600">



