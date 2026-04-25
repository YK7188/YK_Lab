> Tested: April 2026

## Objective

Simulate how to prepare for and deploy Remote Help.

---

## Start Remote Help trial

Path: `Tenant administration > Intune add-ons`

Linked page leads to a trail option in MS 365 admin center.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/01.%20trial.jpg" width="600">

---

## Assign the license to a test user

Open MS 365 admin center and assign Microsoft Intune Remote Help

Path: `Users > Active Users`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/02.%20licensing.jpg" width="600">

---

## Assign an admin role to a test user

> Deafult role Helpdesk Operator allows all features for Remote Help

Path: `Tenant administration > Roles > Helpdesk Operator > Assignments`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/04.%20assign%20role.jpg" width="600">

---

## Enable Remote Help

Path: `Tenant administration > Remote Help > Settings`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/03.%20enabling%20remote%20help.jpg" width="600">

---

## Remote Help client deployment

1. Download the app at `https://learn.microsoft.com/en-us/intune/remote-help/deploy?tabs=windows#download-remote-help-apps`
2. Prepare the app folder and package it using: `https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/releases/tag/v1.8.7`
   
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/05.%20run%20prep%20tool.jpg" width="600">

<br>
   
3. Create Win32 app in Intune
   - Path: Apps > Windows > Create > App type (Win32)
   - Referrence article for Configurations: `https://learn.microsoft.com/en-us/intune/remote-help/deploy?tabs=windows`
  > insall command, uninstall command and detection rule has to be exact. Otherwise it causes failed installation, installation loop.

4. Verify that the app installs on an endpoint

remotehelpinstaller.exe can be installed in Company Portal.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/14-Remote%20Help%20app%20deployment/06.%20companyportal.jpg" width="600">


