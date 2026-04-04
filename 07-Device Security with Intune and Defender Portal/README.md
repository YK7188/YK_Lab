## Object

This lab simulates a real-world endpoint security baseline using:
- Microsoft Intune
- Microsoft Defender Portal

---

## 1. Configuring Endpoint Protection Policies

🔹 Antivirus Policy
<br>
<br>
Path: `Endpoint Security → Antivirus → Create Policy`

<br>


- Behavior Monitoring

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Detects suspicious activity such as ransomware-like file changes or abnormal script execution.

- Cloud Protection

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Extends detection using Microsoft’s cloud intelligence for unknown threats.

- Automatic Sample Submission

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Allows suspicious files to be uploaded for deeper analysis.

- Archive Scanning

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Enables scanning inside compressed files (.zip, .rar).

- Scheduled Scanning
  - Scan type: Quick Scan
  - Time: 03:00 daily
  - Frequency: Every day
<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/01.%20configuring%20policies.jpg" width="600">

---

🔹 Firewall Policy
<br>
<br>
Path: `Endpoint Security → Firewall → Create Policy`

Configured to enforce strict inbound control while allowing outbound traffic:

- Firewall enabled on all profiles:
  - Domain / Private / Public → ON
- Default behavior:
  - Inbound → Block
  - Outbound → Allow
- Logging enabled for dropped packets

<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/02.%20FWPolicies.jpg" width="600">

---

<br>
🔸 Firewall Rules

Path: `Endpoint Security → Firewall Rules → Create Policy`
<br>

Example rules:

- Allow inbound TCP 8080 (internal web app access)
- Block outbound TCP 445 (Public networks) to prevent SMB exposure

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/05.%20FW_Rules_Policy.jpg" width="600">

---

## 🔹 Attack Surface Reduction (ASR)

Path: `Endpoint Security → Attack Surface Reduction → Create Policy`

<br>
Configured rule:

Block all Office applications from creating child processes

>This directly targets macro-based attack techniques

<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/07.%20ASR_Creation1.jpg" width="600">

---

## 2. Verifying Policy Deployment
<br>

After deployment, policies are validated on the endpoint:

- Antivirus / Firewall
  
  → “Managed by your organization” message confirms enforcement

- Firewall Rules
  
  → Verified via wf.msc → Monitoring
  
- ASR Policy
  
  → Verified using: `Get-MpPreference` Powershell command



- Troubleshooting reference:
  
    → [08-FW rules policy do not appear on endpoint](/08-FW%20rules%20policy%20do%20not%20appear%20on%20endpoint/)

---

## 3. Onboarding to Defender

Steps:
- Download onboarding package

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Settings → Endpoints → Onboarding
- Run the onboarding script on the endpoint
- Confirm device appears in Device Inventory

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/12.deviceshown.jpg" width="600">

---

## 4. Simulating a Threat

To validate the security controls, a macro-based attack scenario is simulated:

A macro attempts to launch cmd.exe from an excel file but the ASR rule blocks the action
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/10.%20action_blocked.jpg" width="600">


---
<br>

## 5. Detection & Visibility

Although the attack was blocked, the activity is still recorded in:

Microsoft Defender Portal → Device → Timeline

Observed the event "EXCEL.EXE was blocked by the attack surface reduction (ASR) rule".
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/07-Device%20Security%20Config/13.Timeline.jpg" width="600">

