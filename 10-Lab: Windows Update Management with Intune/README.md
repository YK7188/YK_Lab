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
  - Deadline for feature updates: 30
  - Deadline for quality updates: 4
  - Grace period: 2 days

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/10-Lab%3A%20Windows%20Update%20Management%20with%20Intune/01.%20updatering.jpg" width="600">

✔ Windows Update driver delivery may introduce instability

✔ Enterprises often block driver updates and rely on OEM tools
   such as Lenovo Vantage, deployed and controlled via Intune

✔ Enterprises create multiple rings for testing and staged rollout instead of automatic, all at once updates

## Create Feature update policy

Path: `Devices > Windows Updates > Feature updates > Create Profile`
- Feature update to deploy > Windows 11, version 24H2

       image

## Troubleshoot note

- Observation 1
  
After I created the feature update policy for version 24H2, the test machine (Windows 10 22H2) was ready to install 23H2 instead of 24H2, showing "Pending restart".
     image

- Analysis 1
  
I confirmed that an existing feature update policy for 23H2 was assigned to the test machine. It appears that this policy let it download the 23H2 update before the new policy for 24H2 applied. Even after I removed the machine from the 23H2 policy, the machine showed "Pending restart 23H2"

> Once an update is set to the "Pending restart" state, the machine can no longer skip the update. In this case, 22H2 cannot skip 23H2 to update to 24H2.

- Observation 2
  
I let it install 23H2 to further observe its behaviour. As opposued to the expectation, it did not show "some settings are managed by your organization" and settings are not locked. When clicking Check updates, it started downloading 24H2 instead of the current latest 25H2 that is a good indicator that the policy is applied.

- Analysis 2
  
Confirmed that the policy is applied by Registry value.

Path: `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Update`

- Values below are what are configured in the policy
  - DeferFeatureUpdatesPeriodInDays
  - DeferQualityUpdatesPeriodInDays

Later when "Option to check for Windows updates" is disabled in the policy, the "settings are managed by your organization" message appears.

image 



## Create Device configuration

Path: `Devices > Windows > Configuration > Create New Policy > Settings catalog > `
image

- Allow Auto Update > Auto install the update and then notify the user to schedule a device restart. Updates are downloaded automatically
- Allow Optional Content > Don't receive optional updates
- Disable WFfB Safeguards > Safeguards are enabled
- Manage Preview Builds > Disable Preview builds

## Troubleshoot Note

A while after the device configuration is created and assigned, the policy-assigned devices' check-in status showed Conflict in the report.

As the Conflict status appeared for the update ring the devices are assigned too, which indicated that it clashed with the configuration policy. I 

   conflict status image

Corrected conflicted settings referring to Per setting status in the report.

    per setting status image

The status changed to Succeeded.

    succeeded image

## Key points

✔ Feature Update Policy overrides Update Ring for version.

✔ When there is conflict between Update ring configs and override device configs, the settings will not apply properly.



