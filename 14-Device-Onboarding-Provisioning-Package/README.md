> Tested: April 2026

## Objective
Onboard an existing device (no wipe) using a provisioning package.

Join to Microsoft Entra ID
Enroll into Microsoft Intune
Preserve existing apps and user data

---

## Step 1 — Install Configuration designer

Install Windows Assessment and Deployment Kit and select Configuration Designer.

Download:

https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install


## Step 2 — Launch the tool

Open Windows Configuration Designer and select:

Provision desktop devices

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/15-ppkg%20file%20creation/01.open_designer.jpg" width="600">


## Step 3 — Create provisioning package

Enter a project name and proceed through the wizard.

### 1. Configure device name

Path: Set up device > Device name

Example:  PC-%SERIAL%

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/15-ppkg%20file%20creation/02.designer_steps.jpg" width="600">

### 2. Configure Entra ID enrollment and local admin

Path (Entra ID Enrollment):

Account management > Manage organization/school accounts
- Select Enroll in Azure AD (Entra ID)
- Generate a bulk token

Path (Local admin):

Account management > Optional: Create a local administrator account

## Step 4 — Apply the provisioning package

Execute the .ppkg file on the target device.
- Confirm the prompt
- The device will automatically restart

## Step 5 — Verification

### 1. Confirm Entra ID join
   
Command: dsregcmd /status

AzureAdJoined appears YES

### 2. Confirm device name

PC-476399072347 appears (derived from device serial number)

### 3. Confirm local admin

Run lusrmgr.msc and verify the created account is a member of Administrators

### 4. Confirm Intune enrollment

The device's "managed by" status shows Intune.

### 5. Confirm data integrity

Existing applications and user data remain intact

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/15-ppkg%20file%20creation/04.verify_endpoint.jpg" width="600">
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/15-ppkg%20file%20creation/05.verify_intune.jpg" width="600">

## Key points

- Bulk token allows silent Entra ID join and Intune enrollment
- Device can be fully managed once enrolled, regardless of the currently logged-in user
- This method is useful when:
  - Devices cannot be reset
  - User interaction must be minimized
  - Standardized onboarding is required
