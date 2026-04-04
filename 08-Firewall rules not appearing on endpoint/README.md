
## Issue
Rule Allow-8080-inbound is configured via Firewall rules policy in Intune's Endpoint Security but is not shown in outbound rules of wf.msc.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/08-FW%20rules%20policy%20TS/03.%20FW%20rule%20in%20intune.jpg" width="600">
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/08-FW%20rules%20policy%20TS/02.%20rule%20not%20shown.jpg" width="600">

---

## Details
- Intune record indicates that the policy is applied to the device.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/08-FW%20rules%20policy%20TS/01.%20policy_succeed.jpg" width="600">


- Powershell command below shows that no rules are applied via MDM.
  Get-NetFirewallRule | Select DisplayName, PolicyStoreSource

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/08-FW%20rules%20policy%20TS/04.%20nothing%20from%20MDM.jpg" width="600">

---

## Findings
- Even if a policy has been applied to the device via MDM, the intended rules will not appear the way above.
- The rules are seen these ways:
  - Registry Editor: Computer\HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\Mdm\FirewallRules
  - wf.msc: Monitoring > Firewall
  - Get-NetFirewallRule -PolicyStore ActiveStore
 

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/08-FW%20rules%20policy%20TS/05.%20shown%20in%20regedit.jpg" width="600">
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/08-FW%20rules%20policy%20TS/06.%20shown%20in%20wf.msc.jpg" width="600">
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/08-FW%20rules%20policy%20TS/07.%20shown%20via%20Powershell.jpg" width="600">



    
