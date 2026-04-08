> Tested: April 2026


## Create Update ring

Path: `Devices > Windows Update > Update rings > Create Profile`


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
