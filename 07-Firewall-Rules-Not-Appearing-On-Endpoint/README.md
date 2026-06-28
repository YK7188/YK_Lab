
## Issue

A firewall rule (`Allow-8080-inbound`) was configured via Intune Endpoint Security.

Although the policy shows as successfully applied, the rule does not appear in `wf.msc` under Inbound Rules.

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/08-FW%20rules%20policy%20TS/03.%20FW%20rule%20in%20intune.jpg" width="600">
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/08-FW%20rules%20policy%20TS/02.%20rule%20not%20shown.jpg" width="600">

---

## Investigation

- Intune record indicates that the policy is applied to the device.

  <br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/08-FW%20rules%20policy%20TS/01.%20policy_succeed.jpg" width="600">


- The following command does not show rules from MDM:

`Get-NetFirewallRule | Select DisplayName, PolicyStoreSource`

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/08-FW%20rules%20policy%20TS/04.%20nothing%20from%20MDM.jpg" width="600">

---

## Findings

**Firewall rules deployed via Intune (MDM) are not always visible in the default rule view in `wf.msc` or standard PowerShell queries.**

This is because:

- MDM-managed firewall rules are stored in a separate policy store
- They are not displayed in the same way as locally configured rules
 

The rules can be verified using the following methods:

- **Registry**
  : `HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\Mdm\FirewallRules`

- **wf.msc**
  : Monitoring 竊・Firewall

- **PowerShell**
  : `Get-NetFirewallRule -PolicyStore ActiveStore`


<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/08-FW%20rules%20policy%20TS/05.%20shown%20in%20regedit.jpg" width="600">
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/08-FW%20rules%20policy%20TS/06.%20shown%20in%20wf.msc.jpg" width="600">
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/08-FW%20rules%20policy%20TS/07.%20shown%20via%20Powershell.jpg" width="600">



    

