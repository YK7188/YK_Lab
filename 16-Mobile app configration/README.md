> Tested: May 2026

# Objective

Configure an Intune App Protection Policy (MAM only) and observe how each configuration behaves on unmanaged iOS devices.

---

# Notes about testing

- Testing was performed on unmanaged iOS devices using Intune App Protection Policies (MAM only).
- Behavior may differ between Microsoft apps even when the same App Protection Policy is applied.

---

# App Protection Policy (MAM only)

Path: `Apps → protection → Create`

Choose: `iOS/iPadOS`

Selected apps:
   
- Microsoft Outlook
- Microsoft Teams
- Microsoft OneDrive

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/01.add_apps.jpg" width="600">

<br>

## 1️⃣ Data Protection

Image from the policy wizard

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/02.data_protection.jpg" width="600">



|Setting | Value|
|---|---|
|Send org data to other apps | Policy managed apps|
|Receive data from other apps | All apps|
|Restrict cut, copy, and paste between other apps | Policy managed apps only|
|Save copies of org data |	Block|
|Allow user to save copies to selected services | OneDrive for Business, SharePoint|
|Screen capture | Block|

<br>

## 2️⃣ Access requirements

Image from the policy wizard

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/03.access_reqirements.jpg" width="600">


|Setting|Value|
|---|---|
|PIN for access|Require|
|PIN type|Numeric|
|Simple PIN|Block|
|Select Minimum PIN length|6|
|Touch ID instead of PIN for access (iOS 8+/iPadOS)|allow|
|Recheck the access requirements after (minutes of inactivity)|30 minutes|
|Work or school account credentials for access|Not required|


<br>

## 3️⃣ Conditional launch

Image from the policy wizard

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/04.conditional_launch.jpg" width="600">

### App conditions

|Setting|Value|
|---|---|
|Max PIN attempts|5|
|Offline grace period|10080 (7days) > Block access (minutes)|
|Offline grace period|90 (days) > Wipe data (days)|

<br>

### Device conditions


|Setting|Value|
|---|---|
|Jailbroken/rooted devices|Block access|
|Min OS version|16.0 > Block access|


---

# App Protection Policy Validation

Validation was performed using a test user account on unmanaged iOS devices.

When signing in, the following message appeared:

> `Your organization is now protecting its data in this app.`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/08.Initial_notice_protection.jpg" width="400">


## 1️⃣ Data Protection Validation

### 1. Send org data to other apps (Policy managed apps)

A test image was shared from managed apps to both managed and unmanaged apps.

#### Unmanaged apps

1. Files

  - When the configuration was in effect, sharing was blocked with: `Sharing not allowed`

    <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/05.Files_blocked.jpg" width="400">

  - When the configuration was removed, sharing succeeded.

2. Freeform

  - When the configuration was in effect, sharing appeared to complete, but the received image could not be properly rendered as in the image below.

    <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/07.Image_FreeForm.jpg" width="400">

  - When the configuration was removed, the image displayed normally.

3. Notes

  - When the configuration was in effect, sharing appeared to complete, but the received image could not be properly rendered.

  - When the configuration was removed, the image displayed normally.


#### Managed apps

Sharing between managed apps succeeded regardless of the configuration.

Tested:

- Outlook
- OneDrive
- OneNote

#### Key observations

- Sharing restrictions behaved differently depending on the destination app.
- Some apps (AirDrop, Messages and Mail) were completely removed from the iOS share sheet.
- Some apps displayed explicit blocking messages.
- Some apps accepted the shared data but could not properly render it.

<br>

### 2. Receive data from other apps (All apps with incoming org data)

The behavior of this setting was unclear from the configuration description alone, so each option was tested individually.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/12.receive_data_from_other_apps.jpg" width="600">

<br>

### Common observation

Across all tested configurations:

- sharing from managed apps to Files, Freeform, and Notes was primarily affected by the "Send org data to other apps configuration" rather than the "Receive data from other apps" configuration.

<br>

1. All apps

Observed behavior:

- Outlook, OneDrive, and OneNote successfully received data from Teams.
- Outlook, OneDrive, and OneNote also successfully received data from Files, Freeform, and Notes.

<br>

2. None

Observed behavior:

- Outlook failed to receive data from Teams with:

  Security Notice: Your organization doesn't allow the use of external libraries and files

<br>
  
  <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/13.OutlookBlocked_OrgData.jpg" width="300">


- OneDrive failed to receive data from Teams with:

- Sign in to Personal OneDrive

<br>

  <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/14.OneDrive_Blocked_OrgData.jpg" width="300">

- OneNote successfully received data from Teams.
- Data from Files, Freeform, and Notes could not be shared into Outlook, OneDrive, or OneNote.

> Behavior differed between Microsoft apps even when the same Intune App Protection Policy was applied.

<br>

3. Policy managed apps

Observed behavior:

- Outlook, OneDrive, and OneNote successfully received data from Teams.
- Data from Files, Freeform, and Notes could not be shared into Outlook, OneDrive, or OneNote. 

<br>

4. All apps with incoming org data

Observed behavior:

- Outlook, OneDrive, and OneNote successfully received data from Teams.
- Outlook, OneDrive, and OneNote also successfully received data from Files, Freeform, and Notes.
    
<br>

#### Further testing - Any app with incoming org data

The following description appears in the App Protection Policy wizard:

`Any app with incoming org data: Allow receiving data in org documents or accounts from from any app and treat all incoming data without an user account as org data`

The wording appears to suggest that:

- data can be received regardless of whether the originating app is managed, and
- if the originating app is unmanaged, the received data may be treated as organizational data once imported into a managed app.

Based on this interpretation, the following behavior was expected.

#### Scenario 1 — “All apps” selected for “Receive data from other apps”

Configuration:

- Receive data from other apps: All apps
- Send org data to other apps: Policy managed apps

Expected behavior:

- Data from an unmanaged app can be received by a managed app.
- The imported data can then be shared from the managed app to an unmanaged app because the data is not treated as organizational data.
- Therefore, the Send org data to other apps restriction would not be applied to the imported data.

#### Scenario 2 — “Any app with incoming org data” selected

Configuration:

Receive data from other apps: Any app with incoming org data
Send org data to other apps: Policy managed apps

Expected behavior:

- Data from an unmanaged app can be received by a managed app.
- The imported data cannot later be shared from the managed app to an unmanaged app because the data is treated as organizational data.
- Therefore, the Send org data to other apps restriction would apply to the imported data.

#### Results

The behavior did not match the hypothesis.

In both configurations:

- data from unmanaged apps could be received by managed apps, but
- the imported data could not later be shared from managed apps to unmanaged apps.

This suggests that the imported data was effectively treated as organizational data in both scenarios.

As a result, the practical effect of “treat as org data” remains unclear based on this testing alone.

<br>

### 3. Restrict cut, copy, and paste between other apps (Policy managed apps only)

#### Managed app → unmanaged app


Copying/cutting text from managed apps into unmanaged apps failed.

Tested:

- From: Outlook, OneDrive, Teams
- To: Notes, Freeform, Files

Observed behavior: `Your organization's data cannot be pasted here`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/15.CannotBe_Pasted.jpg" width="400">

<br>




#### Unmanaged app → managed app

Copying/cutting text from an unmanaged app and pasting it into a managed app shows different behaviours.

Tested:

- From: Notes, Freeform, Files
- To: Outlook, OneDrive, Teams, OneNote

Observed behavior:

- From unmanaged apps to Teams, a message appears: `Your organization's data cannot be pasted here`
- From unmanaged apps to Outlook, the Paste option fails to return any texts.
- From unmanaged apps to OneNote, pasting succeeds
- From unmanaged apps to OneDrive, past option does not appear.  


#### Managed app → managed app

Copying/cutting and pasting between the protected apps is allowed.

Tested between:

- Outlook
- OneDrive
- Teams

#### OneNote behavior

Microsoft OneNote behaved differently from the other Microsoft apps during testing.

Observed behavior:

- Copying text from OneNote to Notes, Freeform, or Files was blocked.
- Copying text from Notes, Freeform, or Files into OneNote succeeded.

#### Key points

- Paste blocking behavior differed depending on the destination app.
- Some apps displayed explicit errors.
- Others simply hid the Paste option.
- Microsoft apps excluded from App Protection Policy testing may behave differently from protected apps.

<br>


### 4. Save copies of org data (Block)
#### Initial testing

Observed behavior:

- Saving an attachment from Outlook to Dropbox failed with: `Save not allowed`

<br>
  <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/16.save_not_allowed.jpg" width="300">

- OneDrive and Teams could send a test image to Dropbox, but the image could not be previewed properly.

  <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/17.Dropbox_no_preview.jpg" width="300">

<br>
- Saving/sending data from Teams and Outlook to OneDrive succeeded.

#### Additional validation

To further isolate the behavior:

- Send org data to other apps was changed from Policy managed apps to All apps.
- This automatically greyed out the Save copies of org data setting.

Observed behavior:

- Teams and Outlook could send a test image to Dropbox successfully.
- The received image could be opened normally.
- Outlook attachment saving to Dropbox still failed with: `Unexpected error`

#### Result

Teams and OneDrive behaved as expected once the restriction was relaxed, while Outlook continued to fail when saving attachments directly to Dropbox.

This suggests Outlook may handle attachment export differently from the other Microsoft apps tested.

<br>

### 5. Screen capture (Block)

Screen capture was blocked in:

- Outlook
- OneDrive
- Teams

`with: Action Not Allowed`

Screen capture remained allowed in:

- OneNote
- SharePoint


<br>

### 6. PIN for access (Require)

The device passcode on the iPhone was removed for testing purposes.

Observed behavior:

- Outlook, OneDrive, and Teams displayed: Device Passcode Required
- OneNote also required a device passcode despite not being included in the App Protection Policy testing scope.
- SharePoint did not require a device passcode.

#### Result

Behavior differed between Microsoft apps even under similar conditions.

<br>

### 7. PIN requirements

Observed behavior:

- Device passcode existence enforcement worked consistently.

<br>
  <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/20.Passcode_required.jpg" width="300">
 
- Protected apps also required an Intune App PIN.
- The Intune App PIN:
  - required 6 numeric digits
  - rejected simple combinations
    
    <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/%20%20%20%2016-Mobile%20app%20configration/19.AppPIN_required.jpg" width="300">

<br>
consistent with the configured policy.









