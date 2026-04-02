
## Issue
Rule Allow-8080-inbound is not shown in outbound rules of wf.msc.

![03  FW rule in intune](https://github.com/user-attachments/assets/f225aabc-548a-46fb-adab-3a7920324aee)

![02  rule not shown](https://github.com/user-attachments/assets/f74d2c4e-7679-4701-b158-ee0cb36a2363)

---

## Details
- Intune record indicates that the policy is applied to the device.

![01  policy_succeed](https://github.com/user-attachments/assets/c684383e-5532-4e31-acdf-fa3e3b0b3bc3)

- Powershell command below shows that no rules are applied via MDM.
Get-NetFirewallRule | Select DisplayName, PolicyStoreSource

![04  nothing from MDM](https://github.com/user-attachments/assets/75c2a4b8-de79-4b0f-8609-667954709e06)

---

## Findings
- Even if a policy has been applied to the device via MDM, the intended rules will not appear the way above.
- The rules are seen these ways:
  - Registry Editor: Computer\HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\Mdm\FirewallRules
  - wf.msc: Monitoring > Firewall
 
![05  shown in regedit](https://github.com/user-attachments/assets/1c768dae-6cde-4b6a-853f-179fe6d985fa)
![06  shown in wf msc](https://github.com/user-attachments/assets/85aae04c-e231-4380-9268-9a1bd98e06aa)


    
