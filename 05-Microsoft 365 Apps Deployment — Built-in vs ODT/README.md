## Objective

This lab demonstrates two deployment approaches for Microsoft 365 Apps for enterprise using Microsoft Intune:

Built-in Intune app deployment
Office Deployment Tool (ODT) via Win32 app

---

## Scenario 1 — Clean Environment (Built-in Intune)

✔ For New or freshly provisioned device

✔ Best suited for existing devices with no Office apps installed

✔ Standardized configuration

⚙️ Configuration (Intune Built-in)

- App type: Microsoft 365 Apps
- Architecture: 64-bit
- Channel: Monthly Enterprise
- Apps to be installed: Word, Excel, Outlook, PowerPoint, OneNote
- Apps to be Excluded: Access, Publisher, Teams
- Remove other versions: Yes

![01 app addition](https://github.com/user-attachments/assets/76aa7659-7dd8-4f95-9aba-993bba7a1794)

✅ Result

✔ Office installs successfully

✔ Selected apps deployed correctly

✔ No conflicts or leftover components

## Scenario 2 — Unorganized Environment (ODT preferred)

✔ There are Existing Office installations:
   - Office 2016 (MSI)
   - Office 2019 (Click-to-Run)
   - OEM Office (Home edition)
✔ Standalone apps may exist (Teams, Access Runtime)

“Remove other versions” in the built-in Intune app is not very consistent so ODT approach is better suited.

Step 1 Download ODT from the page below.

https://www.microsoft.com/en-us/download/details.aspx?id=49117&msockid=26bb9383db066fc7030b849fda986e71

Step 2 Prepare the xml files.

--xml for installation
```
<Configuration>

  <!-- Remove all Click-to-Run Office -->
  <Remove All="TRUE" />

  <!-- Install clean Microsoft 365 Apps -->
  <Add OfficeClientEdition="64" Channel="MonthlyEnterprise">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Publisher" />
      <ExcludeApp ID="Teams" />
    </Product>
  </Add>

  <Display Level="None" AcceptEULA="TRUE" />
  <Property Name="AUTOACTIVATE" Value="1" />
  <Updates Enabled="TRUE" />

</Configuration>
```


--xml for removal
```
<Configuration>
  <Remove All="TRUE" />
</Configuration>
```

Step 3 Package the ODT folder to upload on Intune.
![03 office folder downloaded](https://github.com/user-attachments/assets/a30948a9-cca7-4fab-baed-8874180fed80)

https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/releases/tag/v1.8.7

*Office resource Folder is optional for a case where offline standalone installation is required.

Step 4 

Configure Win32 app on Intune

- Install behavior > Choose System over User as Office apps are business critical, necessary tools.
- Device restart behavior > Choose No specific action as Office installation does not require rebooting the machine.


