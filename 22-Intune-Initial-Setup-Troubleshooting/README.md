> Labbed: May 2026

# Issue

When an Entra ID user attempted to sign in to an Intune-managed Windows device, the following behavior occurred:

- Setting up for work or school appeared unexpectedly after login.
- The setup process eventually failed.
- Apps (Error) appeared in the status screen.
- User sign-in could not complete successfully.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/23-Troubleshoot_Intune_InitialSetupFailure/03.apps_error.jpg" width="500">

# Environment

- Microsoft Intune
- Microsoft Entra ID joined device
- Windows Autopilot enrolled device
- Intune MDM managed
- PKCS certificate deployment configured

# Cause

A newly created Intune device configuration policy caused the issue.

The failing policy appeared with Error status for the affected device in Intune.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/23-Troubleshoot_Intune_InitialSetupFailure/01.user2_error.jpg" width="500">

# Resolution

After the problematic policy configuration was corrected:

- the Setting up for work or school screen no longer appeared
- the user was able to sign in normally
- the policy status changed from Error to Success

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/23-Troubleshoot_Intune_InitialSetupFailure/04.user2_nowsuccess.jpg" width="500">


