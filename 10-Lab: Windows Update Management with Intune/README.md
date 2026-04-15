> Tested: April 2026


## Create Update ring

Path: `Devices > Windows Updates > Update rings > Create Profile`


- Update settings
  - Microsoft product updates: Block
  - Windows drivers: Allow
  - Quality update deferral: 3 days
  - Feature update deferral: 30 days


- User experience settings
  - Automatic update behavior: Auto install and restart at maintenance time
  - Active hours: 8 AM – 6 PM
  - Deadline for feature updates: 30 days
  - Deadline for quality updates: 4 days
  - Grace period: 2 days

<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/01.%20updatering.jpg" width="600">

✔ Windows Update driver delivery may introduce instability

✔ Enterprises often block driver updates and instead rely on OEM tools
   such as Lenovo Vantage, managed via Intune

✔ Multiple update are typically used to implement staged rollout (e.g., Pilot -> Broad -> Production)

---

## Create Feature update policy

Path: `Devices > Windows Updates > Feature updates > Create Profile`
- Feature update to deploy > Windows 11, version 24H2

<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/02.%20featureUD_config.jpg" width="600">

---

## Troubleshooting notes

✔ Observation 1: About "Pending restart" showing unexepected version
  
After assigning a Feature Update Policy for 24H2, the test device
(Windows 10 22H2) showed: 

`Pending restart for Windows 11 23H2`

<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/04.%2023H2_Downloaded.jpg" width="600">

<br>
✔ Analysis
  
An existing Feature Update Policy for 23H2 had previously been assigned.

- The device had already downloaded 23H2
- Even after unassignment, it remained in Pending restart

> Key behaviour: `Once an update reaches “Pending restart,” it cannot be skipped.`

<br>
✔ Observation 2: About "Managed by your organization" not shown
  
After upgrading to 23H2:

- The message “Some settings are managed by your organization” did NOT appear
- However, selecting Check for updates triggered download of 24H2 (instead of latest public version 25H2)

> This indicated the Feature Update Policy was active

<br>
✔ Analysis
  
Confirmed that the policy was applied by Registry value.

Path: `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Update`

- Values below matched what were configured in the policy
  - DeferFeatureUpdatesPeriodInDays
  - DeferQualityUpdatesPeriodInDays

Later, when "Option to check for Windows updates" was disabled in the policy, the "settings are managed by your organization" message appeared.

<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/14.%20managed%20by%20org%20appears.jpg" width="600">

---

## Create Device configuration

Path: `Devices > Windows > Configuration > Create New Policy > Settings catalog > `

- Allow Auto Update > Auto install the update and then notify the user to schedule a device restart. Updates are downloaded automatically
- Allow Optional Content > Don't receive optional updates
- Disable WFfB Safeguards > Safeguards are enabled
- Manage Preview Builds > Disable Preview builds


<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/03.%20DevConfig.jpg" width="600">

---

## Troubleshoot Note

A while after the device configuration had been created and assigned, the policy-assigned devices' check-in status showed as Conflict in the report.

<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/17.%20conflict_deviceconfig.jpg" width="600">

The Conflict status appeared for the update ring the devices are assigned too. It indicated that the ring clashed with the configuration policy.
I Corrected the conflicted settings referring to Per setting status in the report.

<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/15.%20conflict%20list.jpg" width="600">

Later, the status changed to Succeeded.

---

## Key points

✔ Feature Update Policy overrides Update Ring for version.

✔ When there is conflict between Update ring and device config, the settings will not apply properly.



