> Tested: June 2026

# Lab Object

To verify app deployment, management and protection for Android devices by simulating two seperate cases.

- Configure Microsoft Edge for non-intune-enrolled BYOD Android
- Configure Microsoft Edge for intune-enrolled BYOD Android

# Test configure Edge for non-intune-enrolled BYOD device

## STEP 1 — Create app configuration policy

Go to:

Apps > Android > Configuration > Create > `Managed Apps`

and select Edge to configure.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/04.App_config_basics.jpg" width="600">

For testing, set bookmarks:

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/05.appconfig_Bookmark.jpg" width="500">

## STEP 2 — Create app protection policy

Go to:

Apps > Android > Protection > Create > Android

Keep the default configuration for this test.
 
## STEP 3 — Verify the behavior on the phone

Prompted to set a PIN as shown below.

image

> App protection is applied.

Bookmarks apper as configured.

image 

> App configuration is applied.


# Test configure Edge for intune-enrolled BYOD devices

## STEP 1 — Add Android app

Go to:

Apps > Android > Create

Select:

Store app > Managed Google Play

and add Microsoft Edge.

image

The app appears as a deployable app.

## STEP 2 — Assign the app

Go to:

Apps > Android > Edge > Assignments > Add group

to target users/devices.

## STEP 3 — Create app configuration policy

Configure the same way as non-intune-enrolled devices.

## STEP 4 — Create app protection policy

Configure the same way as non-intune-enrolled devices.


# Device configuration for application restriction

Devices > Android > Configuration > New Policy > Android Enterprise > Templates > Device restrictions

Allow installation from unknown sources > Not configured

App auto-updates (work profile-level) > User choice

Allow access to all apps in Google Play store (work profile-level) > Block




What if a user access normal Android Store instead of Managed Google play 




