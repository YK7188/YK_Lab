## Objective

This lab demonstrates two deployment approaches for Microsoft 365 Apps for enterprise using Microsoft Intune:

Built-in Intune app deployment
Office Deployment Tool (ODT) via Win32 app

---

## Scenario 1 — Clean Environment (Built-in Intune)

## 📌 Overview

✔ New or freshly provisioned devices

✔ Existing devices with no Office installations

✔ Standardized configuration

## ⚙️ Configuration (Intune Built-in)

- App type: Microsoft 365 Apps
- Architecture: 64-bit
- Channel: Monthly Enterprise
- Apps to be installed: Word, Excel, Outlook, PowerPoint, OneNote
- Apps to be Excluded: Access, Publisher, Teams
- Remove other versions: Yes

![01 app addition](https://github.com/user-attachments/assets/76aa7659-7dd8-4f95-9aba-993bba7a1794)

## ✅ Result

✔ Office installs successfully

✔ Selected apps deployed correctly

✔ No conflicts or leftover components

## Scenario 2 — Unorganized Environment (ODT preferred)

## 📌 Overview

✔ Existing Office installations may include:
   - Office 2016 (MSI)
   - Office 2019 (Click-to-Run)
   - OEM Office (Home edition)
✔ Standalone apps may exist (e.g., Teams, Access)

## Limitation of Built-in Deployment

The “Remove other versions” option in the built-in Intune app performs best-effort cleanup, but may not consistently remove all existing Office installations.

## Step 1 Download ODT

Download the Office Deployment Tool:

https://www.microsoft.com/en-us/download/details.aspx?id=49117&msockid=26bb9383db066fc7030b849fda986e71

## Step 2 Prepare XML Configuration

## Installation XML
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

💡 O365ProPlusRetail is required for enterprise-managed deployments.
Other product types (e.g., Home editions) are not fully manageable via Intune.

## Removal XML
```
<Configuration>
  <Remove All="TRUE" />
</Configuration>
```

## Step 3 — Package as Win32 App
![03 office folder downloaded](https://github.com/user-attachments/assets/a30948a9-cca7-4fab-baed-8874180fed80)

Prepare the ODT folder and package it using:

https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/releases/tag/v1.8.7

💡 The Office “Data” folder is optional and mainly used for offline deployments.

## Step 4 — Configure Win32 App in Intune

- Install command
  
setup.exe /configure config.xml

- Install behavior

→ System
(Ensures device-wide, reliable installation)

- Device restart behavior

→ No specific action
(Office installation does not require a reboot)

- Detection rule

Configure detection to validate installation of O365ProPlusRetail

(Example shown below)

  ![04 detection rule](https://github.com/user-attachments/assets/e261fd3e-4853-4bcc-ab0d-2f79b4bd69fa)

## ✅ Result

✔ Office installs successfully

✔ Selected apps deployed correctly

✔ Removed Personal Office that had been installed

## Observations from Lab

- Microsoft 365 Apps (Click-to-Run) can be removed regardless of how they were originally installed. The uninstall process targets the product configuration rather than the deployment source.

- OneDriveForBusiness behavior differed between methods:
- Installed when using ODT (Win32 app)
- Not installed when using built-in Intune deployment

## Final Note

In this lab, I simulated a simplified scenario in which any existing Click-to-Run Office installations were removed prior to deploying Microsoft 365 Apps.

However, real-world environments often require more granular control, such as:

- Avoiding unintended removal of related products (e.g., Visio or Project)

- Correcting only the update channel for devices that already have Microsoft 365 Apps installed but are configured with an incorrect channel
