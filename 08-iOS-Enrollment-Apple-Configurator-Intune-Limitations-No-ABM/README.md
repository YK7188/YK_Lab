> Labbed: May 2026

> Editted: July 2026

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
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/01.%20Profile%20Creation.jpg" width="700">

2. The device serial number was imported and associated with the profile.

3. The enrollment URL exported from Intune was also tested in Apple Configurator.
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/05.%20profile.jpg" width="800">

4. Ensured that no restrictions were configured.
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/09-ios-configurator-intune/03.%20enrollment%20restrictions.jpg" width="800">

-> The same error occurred: `The configuration for your iPhone could not be downloaded`

# Analysis

✔ Remote Management was triggered, but no enrollment configuration was successfully delivered to the device.

✔ Without Apple Business Manager, the device is not recognized by Intune during Setup Assistant.

# Conclusion

Even after assigning a Configurator enrollment profile and importing the device serial number, 
the iPhone failed to download any enrollment configuration during Setup Assistant.

This suggests that without Apple Business Manager, Intune cannot fully recognize the device
for device-driven enrollment, and enrollment fails before user authentication.


---

> # The below describes follow-up testing of iPhone enrollment in July 2026

---

# Method 1 - Setup Assistant Enrollment (Successful)

Goal: Supervised + Setup Assistant Remote Management + Corporate-owned style enrollment

## Steps on Intune side

### Step 1 - Create a profile

Go to:

Devices > Enrollment > Apple > Apple Configurator > Profiles > Create 

Choose:

- User Affinity = Enroll with user affinity
- Select where users must authenticate = Company Portal

### Step 2 - Add the device

Create a csv file that contains the test device's:

Serial number,device details

Then go to:

Devices > Enrollment > Apple > Apple Configurator > Devices 

and add the test device.

### Step 3 - Obtain the profile URL.

Open the profile and choose Export profile to obtain the profile URL.

## Steps on Apple Configurator side

### Step 1 - Add the profile URL

Go to:

Settings > Servers > +

and add the profile URL obtained from Intune.

### Step 2 - Configure the device with Apple Configurator

Choose the device and Click Prepare.

Select:
- Prepare with: Manual Configuration
- Supervise devices
- Allow devices to pair with other computers
- Server: The one added in Step 1

## Result

Setup completed successfully and the device appeared in Intune with Supervised = Yes.

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

## Steps on Intune side

### Step 1 - Create a profile

Go to:

Devices > Enrollment > Apple > Apple Configurator > Profiles > Create 

Choose:

User Affinity = Enroll without user affinity

### Step 2 - Export a profile file

Go to the profile created above and: 

Export Profile > Download ACME Profile

## Steps on Intune side

Connect the wiped iPhone.

Then:

Add > Profiles

to select the downloaded .mobileconfig file.

Configurator pushes the enrollment profile directly to the device.

## Result

Adding a profile was attempted using both:
- ACME profile
- SCEP profile

Howerver, both profiles failed during profile installation with: 0xFA1 (4001) although the procedure followed the Microsoft documentation referenced above.








