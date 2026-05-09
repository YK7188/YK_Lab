> Tested: May 2026

# Objective

---

# App Protection Policy (MAM only)

Path: `Apps → protection → Create`

Choose: `iOS/iPadOS`

Selected apps:
   
- Microsoft Outlook
- Microsoft Teams
- Microsoft OneDrive

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/01.add_apps.jpg" width="600">

## 1️⃣ Data Protection

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/02.data_protection.jpg" width="600">

1. Send org data to other apps

   Policy managed apps

2. Receive data from other apps

   All apps with incoming org data

3. Restrict cut, copy, and paste between other apps

   Policy managed apps only

4. Save copies of org data

   Block

5. Allow user to save copies to selected services

   OneDrive for Business, SharePoint

6. Screen capture

   Block
   

## 2️⃣ Access requirements

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/03.access_reqirements.jpg" width="600">

1. PIN for access

   Require

2. PIN type

   Numeric

3. Simple PIN

   Allow

4. Select minimum PIN length

   6

5. Touch ID instead of PIN for access (iOS 8+/iPadOS)

   Allow

6. Recheck the access requirements after (minutes of inactivity)

   30 minutes

7. Work or school account credentials for access

   Not required

## 3️⃣ Conditional launch

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/04.conditional_launch.jpg" width="600">

### App conditions

1. Max PIN attempts

   5

2. Offline grace period

   10080 (7days) > Block access (minutes)

3. Offline grace period

   90 (days) > Wipe data (days)

### Device conditions

1. Jailbroken/rooted devices

   Block access

2. Min OS version

   16.0 > Block access

---

# App Protection Policy (MAM only) Validation

Validate wether the app protection is in effect for the test user.

When signing in, the notice below appears.

`Your organization is now protecting its data in this app.`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/08.Initial_notice_protection.jpg" width="400">


## 1️⃣ Data Protection

### 1. Send org data to other apps (Policy managed apps)

Send a copy of a test image both when the configuration is in effect and not.

   - Files:
     - When the configuration is in effect, sharing not allowed message appears.

       <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/05.Files_blocked.jpg" width="400">

     - When the configuration is not in effect, the image is successfully shared.
   
   - Freeform:
     - When the configuration is in effect, sharing appears completed but when accessing the shared image, it appears encrypted (the image on the left). 
     - When the configuration is not in effect, the image appears properly (the image on the right).

     <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/07.Image_FreeForm.jpg" width="400">


   - Notes:
     - When the configuration is in effect, sharing appears completed but when accessing the shared image, it appears encrypted (the 17:32 image). 
     - When the configuration is not in effect, the image appears properly (the 18:45 image).

     <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/06.Image_Notes.jpg" width="300">

   - Outlook, OneDrive, OneNote: Sharing is completed successfully regardless of the configuration.

> The behaviour above indicates that the restriction is successfully in effect.

> In addition to that, now AirDrop, Messages and Mail apps are displayed in the share sheet.

`Key points:`

- How apps are restriced in sharing veries.
- Some apps (AirDrop, Messages and Mail in this test) are not shown in the share sheet at all.
- Some apps (Freeform and Notes in this test) can be shared the data but it appears encrypted.
- Some apps (Files in this test) are blocked sharing with the message "Sharing not allowed".

### 2. Receive data from other apps (All apps with incoming org data)

As shown in the image below, what each option does is not really clear so I tested it one by one.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/12.receive_data_from_other_apps.jpg" width="600">

- All Apps
  - A image is shared from Teams to Files, Freeform, notes. Sharing to all these apps is the same way for Send org data to other apps config.
    > Files, Freeform, and Notes were blocked by the “Send org data to other apps” configuration rather than the “Receive data from other apps” configuration.
  - A image is shared from Teams to Outlook, OneDrive, OneNote. All successfully receive the data.

- None
  - A image is shared from Teams to Files, Freeform, notes. All is blocked the same way for Send org data to other apps configuration.
    > Send org data to other apps config affects.
  - Outlook fail to be shared from Teams with the error in the image below "Security Notice Your organisation doesn't allow the use of external libraries and files".
    
    <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/13.Outlook_Blocked_OrgData.jpg" width="300">

  - OneDrive fail to be shared from Teams with the error in the image below "Sign in to Personal OneDrive".
    
    <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/14.OneDrive_Blocked_OrgData.jpg" width="300">

  - OneNote
    > Successfully receive the data shared from Teams.

> Behavior may differ between Microsoft apps even when the same Intune App Protection Policy is applied.

- Policy managed apps
  - Files, Freeform, notes are blocked the same way for Send org data to other apps config.
    > Send org data to other apps config affects.
  - Outlook, OneDrive, OneNote successfully receive the data.

- All Apps with incoming org Data
  - Files, Freeform, notes are blocked the same way for Send org data to other apps config.
    > Send org data to other apps config affects.
  - Outlook, OneDrive, OneNote successfully receive the data.





This is not to protect against incoming data but more like opt to maintain the protection that has been applied to incoming corporate data.

For example, Purview sensitivity labeling maintains while copying between applilcation that the configuration applies to.






4. Restrict cut, copy, and paste between other apps

   Policy managed apps only

5. Save copies of org data

   Block

6. Allow user to save copies to selected services

   OneDrive for Business, SharePoint

7. Screen capture

   Block
