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

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/06.app_protection.jpg" width="500">

## STEP 3 — Verify the behavior on the phone

Prompted to set a PIN as shown below.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/08.PIN.jpg" width="200">

> App protection is applied.

Bookmarks apper as configured.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/09.favorite.jpg" width="400">

> App configuration is applied.

<br>

# Test configure Edge for intune-enrolled BYOD device

## STEP 1 — Add Android app

Go to:

Apps > Android > Create

Select:

Store app > Managed Google Play

and add Microsoft Edge.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/11.add_Edge.jpg" width="400">

The app appears as a deployable app.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/15.App_ReadyToDeploy.jpg" width="400">

## STEP 2 — Assign the app

Go to:

Apps > Android > Edge > Assignments > Add group

to target users/devices.

## STEP 3 — Create app configuration policy (MAM)

Configure the same way as non-intune-enrolled devices.

## STEP 4 — Create app protection policy

Configure the same way as non-intune-enrolled devices.

## STEP 5 — Device configuration for application restriction

Devices > Android > Configuration > New Policy > Android Enterprise > Templates > Device restrictions

- Allow installation from unknown sources > Not configured
- App auto-updates (work profile-level) > Always
- Allow access to all apps in Google Play store (work profile-level) > Block

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/16.Device_Config.jpg" width="400">

## STEP 6 — Verify the behavior on the phone 

- Prompted to set a PIN as configured.
- Bookmarks apper as configured.
- Edge appears in Work profile Google play.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/12.App_shown.jpg" width="200">

- When trying to install an apk file, installation is blocked with the message "Blocked by work policy".

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/13.APK_blocked.jpg" width="200">

> Device configuration is effective.

- Accessing a Play Store on a Work profile browser, trying to install an app using a non-corporate Google account. Installation fails with the error "Your administrator has not given you access".

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/14.install_blocked.jpg" width="200">

> Device configuraion is effective.





