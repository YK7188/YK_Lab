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


