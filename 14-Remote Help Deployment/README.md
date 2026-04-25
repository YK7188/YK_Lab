> Tested: April 2026

## Objective

Simulate the preparation and deployment of Remote Help in a Microsoft Intune environment.

---

## Start Remote Help trial

Path: `Tenant administration > Intune add-ons`

The linked page redirects to the trial option in the Microsoft 365 admin center.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/01.%20trial.jpg" width="600">

---

## Assign license to a test user

Assign the Microsoft Intune Remote Help license in the Microsoft 365 admin center.

Path: `Users > Active Users`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/02.%20licensing.jpg" width="600">

---

## Assign Admin Role to a Test User

> The default Help Desk Operator role includes permissions required for Remote Help.

Path: `Tenant administration > Roles > Helpdesk Operator > Assignments`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/04.%20assign%20role.jpg" width="600">

---

## Enable Remote Help

Path: `Tenant administration > Remote Help > Settings`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/03.%20enabling%20remote%20help.jpg" width="600">

---

## Deploy Remote Help Client

### 1. Download the installer
Download from: 

`https://learn.microsoft.com/en-us/intune/remote-help/deploy?tabs=windows#download-remote-help-apps`

### 2. Prepare the package
Place the installer in a source folder and package it using:

`https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/releases/tag/v1.8.7`
   
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/05.%20run%20prep%20tool.jpg" width="600">

<br>
   
### 3. Create Win32 App in Intune

Path: Apps > Windows > Create > App type (Win32)

Use the following reference for configuration: 

`https://learn.microsoft.com/en-us/intune/remote-help/deploy?tabs=windows`

> ⚠️ The install command, uninstall command, and detection rules must be exact.
> Incorrect configuration can result in:
> - Installation failure
> - Silent install doing nothing
> - Continuous reinstall loops

### 4. Verify Deployment

&nbsp;&nbsp;Confirm that the app installs successfully on the endpoint via Company Portal.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/06.%20companyportal.jpg" width="600">

---

## Notes

- Unsupported operating systems (e.g., older Windows Server versions) may result in false-success installations.
- In a BYOD environment, the app can be assigned User-based.
