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
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/%20%20%20%2009-Windows-Update-Management-Intune/01.%20updatering.jpg" width="650">

✔ Windows Update driver delivery may introduce instability depending on hardware and driver quality

✔ Enterprises often block driver updates and instead rely on OEM tools
   such as Lenovo Vantage, managed via Intune

✔ Multiple update rings are typically used to implement staged rollout (e.g., Pilot -> Broad -> Production)

---

## Create Feature update policy

Path: `Devices > Windows Updates > Feature updates > Create Profile`
- Feature update to deploy > Windows 11, version 24H2

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/%20%20%20%2009-Windows-Update-Management-Intune/02.%20featureUD_config.jpg" width="650">

---

## Troubleshooting notes

✔ Observation 1: About "Pending restart" showing unexepected OS version
  
After assigning a Feature Update Policy for 24H2, the test device
(Windows 10 22H2) showed: 

`Pending restart for Windows 11 23H2`

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/04.%2023H2_Downloaded.jpg" width="600">

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

> This indicates the Feature Update Policy is active

<br>

✔ Analysis
  
Policy application was confirmed via registry:
Path: `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Update`

- Values matched configured policy 
  - DeferFeatureUpdatesPeriodInDays
  - DeferQualityUpdatesPeriodInDays

<br>

✔ Additional observation

When the setting `"Option to check for Windows updates" = disabled` was applied,

the "settings are managed by your organization" message appeared.

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/14.%20managed%20by%20org%20appears.jpg" width="600">

<br>

> Conclusion: The presence of the message depends on UX-impacting restrictions,
not simply whether policies are applied.

---

## Create Device configuration

Path: `Devices > Windows > Configuration > Create New Policy > Settings catalog > `

- Allow Auto Update > Auto install the update and then notify the user to schedule a device restart. Updates are downloaded automatically
- Allow Optional Content > Don't receive optional updates
- Disable WFfB Safeguards > Disabled (safeguards enabled)
- Manage Preview Builds > Disable Preview builds


<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/03.%20DevConfig.jpg" width="600">

---

## Troubleshooting - Conflict State

After assigning the device configuration:
- Devices reported Conflict in check-in status

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/17.%20conflict_deviceconfig.jpg" width="600">

<br>

✔ Cause 

The conflict also appeared on the assigned Update Ring:
> Overlapping settings between Update Ring and Device Configuration

<br>

✔ Resolution

- Reviewed Per-setting status
- Identified overlapping configurations
- Adjusted settings to remove duplication

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/15.%20conflict%20list.jpg" width="600">

<br>

✔ Result
> Status changed from Conflict → Succeeded

---

## Key points

✔ Feature Update Policy overrides Update Ring for OS version control

✔ Once an update reaches “Pending restart,” it cannot be skipped

✔ Update Ring and Device Configuration must not define overlapping settings

✔ “Managed by your organization” is NOT a reliable indicator of policy application

✔ Registry (PolicyManager) provides the most accurate validation

