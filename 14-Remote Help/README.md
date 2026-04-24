

---

1. start trial

   
3. assign the license to a test user


4. Assign a admin role
   Tenant administration > Roles > Helpdesk Operator > Assignments
> Helpdesk operator role has everything needed for Remote Help

## Remote Help client deployment

1. Download the app at https://learn.microsoft.com/en-us/intune/remote-help/deploy?tabs=windows#download-remote-help-apps
2. Prepare the app folder and package it using: https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/releases/tag/v1.8.7
3. Create Win32 app
   
✔ Path: Apps > Windows > Create > App type (Win32)

✔ Key Configurations
- Install command: remotehelpinstaller.exe /quiet /norestart
- Uninstall command: remotehelpinstaller.exe /uninstall /quiet
- Detection rule:
  - Rule type: MSI
  - MSI product code > 04963637-6AC0-48BC-AEA8-2074763EF7D5
  - 
