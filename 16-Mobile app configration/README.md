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

image

## 1️⃣ Data Protection

image

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

image

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

## 3️⃣ Data protection

### App conditions

image

1. Max PIN attempts

   5

2. Offline grace period

   10080 (7days) > Block access (minutes)

3. Offline grace period

   90 (days) > Wipe data (days)

### Device conditions

image

1. Jailbroken/rooted devices

   Block access

2. Min OS version

   16.0 > Block access

