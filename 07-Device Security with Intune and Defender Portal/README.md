



-----

## Configure endpoint policies

🔹 Step 1 — Create Antivirus Policy
Endpoint Security > Antivirus > Create Policy


Commonly set up configurations include:
1. Allow Behavior Monitoring

Detects threats not only by known malware signatures, but also by analyzing process behavior. It can block new malware by detecting suspicious actions such as mass file modification (ransomware-like activity), abnormal PowerShell usage, or attempts to disable security features. 

Disabling it is generally not recommended, except for troubleshooting or compatibility scenarios.


2. Allow Cloud Protection

Without cloud protection, malware detection relies solely on locally stored malware signatures. With it turned on, suspicious files can be inspected by Microsoft's cloud intelligence for unknown malware.

3. Submit Samples Consent > Send safe samples automatically
   
Allows Defender to upload suspicious files to Microsoft for deeper analysis when local and cloud checks are inconclusive.

4. Allow Archive Scanning

Scan inside conpressed files such as .zip, .rar.

5. Scan Parameter > Quick Scan

If Real-time protection, Behavior monitoring, Cloud protection is all enabled, most threats are caught before full scan is required.



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


