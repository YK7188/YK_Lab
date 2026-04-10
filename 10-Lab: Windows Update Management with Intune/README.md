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


✔ Windows Update driver delivery may introduce instability

✔ Enterprises often block driver updates and rely on OEM tools
   such as Lenovo Vantage, deployed and controlled via Intune

✔ This allows testing and staged rollout instead of automatic updates

## Create Feature update policy

Path: `Devices > Windows Updates > Feature updates > Create Profile`
- Feature update to deploy > Windows 11, version 24H2

       image

## A Troubleshoot note

- Observation 1
After I created the feature update policy for version 24H2, the test machine (Windows 10 22H2) was ready to install 23H2 instead of 24H2, showing "Pending restart".
     image

- Analysis 1
I confirmed that an existing policy for 23H2 was assigned to the test machine. It appears that this policy let it download it before the new policy applied. Even after I removed the machine from the 23H2 policy, the machine showed "Pending restart 23H2"

> Once an update is set to the "Pending restart" state, the machine can no longer skip the update. In this case, 22H2 cannot skip 23H2 to update to 24H2.

- Observation 2
I let it install 23H2 to further observe its behaviour. As opposued to the expectation, it did not show "some settings are managed by your organization" and settings are not locked. When clicking Check updates, it started downloading 24H2 instead of the current latest 25H2.

- Analysis 2
Even without an active Update Ring, Feature Update Policy alone can control which Windows version is offered. Otherwise, 25H2 should have been downloaded.



## Create Device configuration

Path: `Devices > Windows > Configuration > Create New Policy > Settings catalog > `
image

- Allow Auto Update > Auto install the update and then notify the user to schedule a device restart. Updates are downloaded automatically
- Allow Optional Content > Don't receive optional updates
- Disable WFfB Safeguards > Safeguards are enabled
- Manage Preview Builds > Disable Preview builds

## Verification



## Key points

✔ Feature Update Policy overrides Update Ring for version
✔ Feature Update Policy adopts what are set in update ring 
i.e.) Deadline cannot be set with Feature update policy and what is set with Update ring will apply.
✔ Update ring configs override device configs



