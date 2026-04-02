## Object




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


## Verify the applied policies on the endpoint.

- Antivirus Policy
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/03.%20AVApplied.jpg" width="600">

- Windows Firewall Policy
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/04.%20FW%20policy%20applied.jpg" width="600">

- Windows Firewall Rules Policy
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/06.%20FW_rules_policy_shown.jpg" width="600">



- For an issue where the configured Firewall policy rules are not seen on the endpoint:
  - [08-FW rules policy do not appear on endpoint](/08-FW%20rules%20policy%20do%20not%20appear%20on%20endpoint/)


---

--lab article idea 
1. how to configure endpoint policies. showcase what companies typically configure and why?
2. how to install defender on Mac (smartphones are out of scope here right?)
3. how to monitor events with the defender portal
4. cause a security event and examine
5. what if using device config instead compared to endpoint policies.



---------------

wip


| Feature              | Intune | Defender portal |
| -------------------- | ------ | --------------- |
| Policy config        | ✅      | ❌             |
| Policy status        | ✅      | ⚠️ Limited     |
| Malware alerts       | ❌      | ✅               |
| Attack investigation | ❌      | ✅               |
| Device risk          | ❌      | ✅               |



🔹 1. Endpoint Security Configuration (FOUNDATION)

Goal: Show how companies secure devices

Use Microsoft Intune

Include:

Antivirus policy
Firewall policy
(Optional) Attack Surface Reduction

💡 Explain:

Why Endpoint Security > Config Profiles
Real-world use (ransomware, compliance)


🔹 2. Defender Deployment (Mac focus 👍)

Use:

👉 Microsoft Defender for Endpoint

Include:

Why Mac still needs enterprise protection
Deployment via Intune
macOS permissions (system extension, full disk)

💡 Good call:

Smartphones → out of scope ✅ (keeps it clean)


🔹 3. Monitoring (THIS IS WHERE IT GETS INTERESTING)

Show:

Device appears in Defender portal
Security dashboard
Device timeline


🔹 4. Simulate an attack (🔥 key differentiator)

Do:

Use EICAR test file
Trigger detection

Then show:

File detected
   ↓
Alert generated
   ↓
Incident created

Explain:

What Defender is actually seeing
Why this matters for security teams


🔹 5. Compare with Configuration Profiles (VERY SMART)

This is where you stand out.

Show:

Same AV setting via:
Endpoint Security
Settings Catalog

Then explain:

Aspect	Endpoint Security	Config Profile
Ease	✅ Easy	❌ Complex
Coverage	⚠️ Limited	✅ Full
Use case	Security baseline	Advanced config


