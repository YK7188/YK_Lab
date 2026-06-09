> Tested: June 2026

# Lab Goal

Verify Android app deployment, configuration, and protection in Microsoft Intune by testing the following scenarios:

- Microsoft Edge on a non-enrolled BYOD Android device
- Microsoft Edge on an Intune-enrolled BYOD Android device

# Configure Edge for a non-enrolled BYOD Android device

## STEP 1 — Create an app configuration policy

Go to:

Apps > Android > Configuration > Create > `Managed Apps`

and select Microsoft Edge to configure.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/04.App_config_basics.jpg" width="600">

For testing, configure bookmarks.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/05.appconfig_Bookmark.jpg" width="500">

## STEP 2 — Create an app protection policy

Go to:

Apps > Android > Protection > Create > Android

Keep the default settings for this test.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/06.app_protection.jpg" width="500">

## STEP 3 — Verify the behavior

When signing in to Microsoft Edge using a corporate account, the user is prompted to configure an application PIN.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/08.PIN.jpg" width="200">

> App protection policy is applied.

Configured bookmarks appear in Microsoft Edge.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/09.favorite.jpg" width="400">

> App configuration policy is applied.

<br>

# Configure Microsoft Edge for an Intune-enrolled BYOD Android device

## STEP 1 — Add Microsoft Edge

Go to:

Apps > Android > Create

Select:

Store app > Managed Google Play

and add Microsoft Edge.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/11.add_Edge.jpg" width="400">

The application appears as a deployable app.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/15.App_ReadyToDeploy.jpg" width="400">

## STEP 2 — Assign the application

Go to:

Apps > Android > Microsoft Edge > Assignments

and target the required users or devices.

## STEP 3 — Create an app configuration policy

Configure the same policy used for the non-enrolled device.

## STEP 4 — Create an app protection policy

Configure the same policy used for the non-enrolled device.

## STEP 5 — Verify the behavior

- User is prompted to configure an application PIN.
- Configured bookmarks appear in Microsoft Edge.
- Microsoft Edge appears in the Work Profile Google Play Store.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/12.App_shown.jpg" width="200">

- Attempting to install an APK file is blocked with the message "Blocked by work policy".

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/13.APK_blocked.jpg" width="200">

> The restriction was observed without any device configuration policy assigned.

- When accessing Google Play Store from a Work Profile browser and attempting to install an application using a personal Google account, installation fails with the message "Your administrator has not given you access to this item".

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2022-Android%20applications%20configuration/14.install_blocked.jpg" width="200">

> The restriction was observed without any device configuration policy assigned.









