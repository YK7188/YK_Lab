>Labbed: May 2026

>Edited: July 2026


# Objective
Test whether an iPhone can be enrolled into Microsoft Intune using Apple Configurator without Apple Business Manager.

---

# Environment
- Intune (MDM authority configured)
- Apple MDM Push Certificate (valid)
- iPhone (reset)
- Apple Configurator on macOS

---

# Reference

This lab refers to the instructions below provided by Microsoft.

https://learn.microsoft.com/en-ca/intune/device-enrollment/apple/setup-configurator-ios

---

# Steps

1. Created MDM server in Configurator using: `https://enrollment.manage.microsoft.com`
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/04.%20serverURL.jpg" width="400">

2. Prepared device:
- Manual configuration
- Supervised
- Assigned to MDM server

3. Completed Setup Assistant

# Result

Device displayed: `This iPhone is owned by [Organization]`

Then: `The configuration for your iPhone could not be downloaded`

> Enrollment failed before any user sign-in prompt.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/06%20error.jpg" width="300">

# Additional Testing — Enrollment Profile Assignment

1. To rule out missing enrollment configuration, an Apple Configurator profile was created in Intune.
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/01.%20Profile%20Creation.jpg" width="800">

2. The device serial number was imported and associated with the profile.

3. The enrollment URL exported from Intune was also tested in Apple Configurator.
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/05.%20profile.jpg" width="900">

4. Ensured that no restrictions were configured.
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/03.%20enrollment%20restrictions.jpg" width="900">

-> The same error occurred: `The configuration for your iPhone could not be downloaded`

# Analysis (May 2026)

✔ Remote Management was triggered, but no enrollment configuration was successfully delivered to the device.

✔ Based on the evidence available at the time, it was assumed that Apple Business Manager might be required for Intune recognition during Setup Assistant enrollment.

# Conclusion (May 2026)

Even after assigning a Configurator enrollment profile and importing the device serial number,
the iPhone failed to download any enrollment configuration during Setup Assistant.

Based on the evidence available at the time, it was concluded that Apple Business Manager
might be required for Apple Configurator enrollment.

This assumption was later disproved by follow-up testing conducted in July 2026.

<br>

---

> # Follow-up Testing (July 2026)

<br>

---

# Method 1 - Setup Assistant Enrollment (Successful)

Goal: Supervised + Setup Assistant Remote Management + Corporate-owned style enrollment

- Intended for corporate devices assigned to individual users. 
- The device is enrolled into Intune and supervised, while Company Portal completes user association and Entra registration, enabling user-based management and policy assignment.

## Steps on Intune side

### Step 1 - Create a profile

Go to:

Devices > Enrollment > Apple > Apple Configurator > Profiles > Create 

Choose:

- User Affinity = Enroll with user affinity
- Select where users must authenticate = Company Portal

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/Followup1/01.Create_Profile.jpg" width="600">

### Step 2 - Add the device

Create a csv file that contains the test device's:

Serial number, device details

Then go to:

Devices > Enrollment > Apple > Apple Configurator > Devices 

and add the test device.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/Followup1/02.Add_Device.jpg" width="800">

### Step 3 - Obtain the profile URL.

Open the profile and choose Export profile to obtain the profile URL.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/Followup1/03.Profile_URL.jpg" width="900">

## Steps on Apple Configurator side

### Step 1 - Add the profile URL

Go to:

Settings > Servers > +

and add the profile URL obtained from Intune.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/Followup1/04.AddServer.jpg" width="400">

### Step 2 - Configure the device with Apple Configurator

Choose the device and Click Prepare.

Select:
- Prepare with: Manual Configuration
- Supervise devices
- Allow devices to pair with other computers
- Server: The one added in Step 1

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/Followup1/05.preparedev.jpg" width="400">

## Result

- Setup completed successfully and the device appeared in Intune with `Supervised = Yes`.
- This result disproved the earlier assumption that Apple Business Manager was required for Apple Configurator enrollment.
- The exact reason for the earlier failure could not be determined. Possible causes include delayed propagation of Intune configuration changes or differences in enrollment configuration.

## Observation Note

- After completing the Apple Configurator enrollment process, the device immediately appeared in Intune and was confirmed to be supervised.
- The device could successfully receive management actions from Intune, such as a remote device rename. At this stage, the device did not yet appear in Entra ID.
- Opening Company Portal prompted the installation of another management profile, despite an MDM profile already existing on the device.
- As a result, two profiles were visible under:
  > Settings → General → VPN & Device Management
  - The Configurator-installed MDM profile (already active)
  - The Company Portal profile (pending installation)
- Company Portal reported the device as:
  > Device not managed — finish setup
- The device appeared in Entra ID only after progressing further through the Company Portal sign-in flow.

> This suggests that Apple Configurator enrollment establishes Intune MDM management and supervision first, while Company Portal later completes user association and Entra registration.
  
---

# Method 2 - Direct Enrollment without User Affinity (Unsuccessful)

Goal: Supervised + No User Affinity + Corporate-owned style enrollment

- Intended to target kiosk, shared, or other corporate-owned devices that do not have a dedicated user.
- In this model, the device can be supervised and managed by Intune without requiring Company Portal or user sign-in.

## Steps on Intune side

### Step 1 - Create a profile

Go to:

Devices > Enrollment > Apple > Apple Configurator > Profiles > Create 

Choose:

User Affinity = Enroll without user affinity

### Step 2 - Export a profile file

Go to the profile created above and: 

Export Profile > Download SCEP Profile

> It is mentioned that ACME profile does not work in the Microsoft article as of July 2026.

## Steps on Apple Configurator side

Connect the wiped iPhone.

Then:

Add > Profiles

to select the downloaded .mobileconfig file so that Configurator will push the enrollment profile directly to the device.

## Result

Adding a profile was attempted using both:
- ACME profile
- SCEP profile

However, both profiles failed during profile installation with: 0xFA1 (4001) although the procedure followed the Microsoft documentation referenced above.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/Followup1/07.error_AddProfile.jpg" width="400">

---

# Final Findings

| Scenario | Enrollment Type | Result |
|----------|-----------------|--------|
| Generic enrollment URL | Setup Assistant (User affinity) | Failed |
| Exported profile URL | Setup Assistant (User affinity) | Successful |
| Supervised device without ABM | Setup Assistant (User affinity) | Supported |
| Intune enrollment without ABM | Setup Assistant (User affinity) | Supported |
| Company Portal requirement | Setup Assistant (User affinity) | Required |
| Direct enrollment | No user affinity | Unsuccessful in testing |





