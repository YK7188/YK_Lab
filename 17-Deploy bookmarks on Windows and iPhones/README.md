Tested: May 2026

# LAB SCENARIO

> IT wants standardized bookmarks deployed to managed browsers for Windows PCs and iPhones to achieve faster onboarding of new employees.

---

# PART 1 — Edge on Windows

## Step 1 — Create Configuration Profile

Path: `Devices > Windows > Configuration > Create > Windows 10 and later > Settings catalog`

For Configuration settings, select Microsoft Edge > Configure favorites (User) and set the script below in Configuration settings. 

```json
[
  {
    "toplevel_name": "Company Resources"
  },
  {
    "name": "Helpdesk",
    "url": "https://helpdesk.contoso.com"
  },
  {
    "name": "HR",
    "url": "https://hr.contoso.com"
  },
  {
    "name": "Internal Tools",
    "children": [
      {
        "name": "SharePoint",
        "url": "https://contoso.sharepoint.com"
      },
      {
        "name": "Ticket System",
        "url": "https://tickets.contoso.com"
      }
    ]
  }
]
```
<br>

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/01.config_settings.jpg" width="600">


## Step 2 — Verify on Endpoint

- Bookmarks appeared as expected.
- As long as Window is logged on by the target user, which Edge profile to use does not matter.
- They appear in an InPrivate window too.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/02.bookmarks_appeared.jpg" width="400">

---

# PART 2 — Chrome on Windows

## Step 1 — Upload Windows admx and adml files in Intune

1. Download the msi file from the page below and excute it.

   https://www.microsoft.com/en-us/download/details.aspx?id=108394

2. admx and adml file is created in the paths below.

- Windows.admx
  C:\Program Files (x86)\Microsoft Group Policy\Windows 11 Sep 2025 Update (25H2)\PolicyDefinitions

- Windows.adml
  C:\Program Files (x86)\Microsoft Group Policy\Windows 11 Sep 2025 Update (25H2)\PolicyDefinitions\en-US

3. Upload the files in Intune.
   Path: `Devices → Configuration → Import ADMX`


<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/05.windows_admx_upload.jpg" width="600">

   

## Step 2 Upload Google admx and adml files in Intune

Download the ADM/ADMX templates in the page below and extract the zip file.

https://chromeenterprise.google/intl/en_us/download/


Path: `Devices → Configuration → Import ADMX`

- google.admx
  - In the download templates:
  - Path: `policy_templates > windows > admx`

- google.adml
  - In the download templates:
  - Path: `policy_templates > windows > admx > en-US`

- chrome.admx
  - In the download templates:
  - Path: `policy_templates > windows > admx`

- chrome.adml
  - In the download templates:
  - Path: `policy_templates > windows > admx > en-US`

All three admx files are uploaded as shown in the image.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/15.admx_appear.jpg" width="600">



#### Key point

- Windows.admx and Google.admx need to be uploaded before Chrome.admx.
- When you open the Chrome.admx file, prefix="Google" and prefix="windows" are present under policyNamespaces.
- This means uploading chrome.admx depends on these two files.

```
  <policyNamespaces>
    <target namespace="Google.Policies.Chrome" prefix="chrome"/>
    <using namespace="Google.Policies" prefix="Google"/>
    <using namespace="Microsoft.Policies.Windows" prefix="windows"/>
```


## Step 3 — Create Configuration profile

Path: Devices → `Windows > Configuration > Create > Windows 10 and later > Templates > Imported Administrative templates`

For Configuration settings, select Managed Bookmarks and enter the same JSON as used in PART 1 — Edge on Windows. 

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/07.managed_bookmarks.jpg" width="600">


## Step 4 — Verify on Endpoint

- Bookmarks appeared as expected.
- As long as Window is logged on by the target user, which Edge profile to use does not matter.
- They appear in an InPrivate window too.

---

# PART 3 — Edge on iPhone

## Step 1 — Create Edge app

Path: `Apps > iOS/iPadOS > Create > iOS store app`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/08.Create_Edge_app.jpg" width="600">

## Step 2 — Create Edge configuration policy

Path: `Apps > iOS/iPadOS > Configuration > Managed Devices`

Select Configuration settings format > Enter XML data

The XML data is on a Miocrosoft article.
https://learn.microsoft.com/en-us/deployedge/microsoft-edge-mobile-policies#managedfavorites

-> ManagedFavorites

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/17.create_appconfig_edge.jpg" width="500">


## Step 3 — Verify on Endpoint

- Bookmarks appeared as expected.
- As long as Company Portal is logged on by the target user, which Edge profile to use does not matter.
- They appear in an InPrivate window too.
- Edge://policy can be useful in troubleshooting.

image

# PART 4 — Chrome on iPhone

## Step 1 — Add Chrome app

Path: `Apps > iOS/iPadOS > Create > iOS Store App`

## Step 2 — Create App Configuration Policy

Path: `Apps > iOS/iPadOS > Configuration > Managed Devices`

Select Configuration settings format > Enter XML data

XML
```<dict>
    <key>ManagedBookmarks</key>
    <array>
        <dict>
            <key>toplevel_name</key>
            <string>Company Resources</string>
        </dict>

        <dict>
            <key>name</key>
            <string>Helpdesk</string>

            <key>url</key>
            <string>https://helpdesk.contoso.com</string>
        </dict>

        <dict>
            <key>name</key>
            <string>HR Portal</string>

            <key>url</key>
            <string>https://hr.contoso.com</string>
        </dict>
    </array>
</dict>
```

## Step 3 — Verify on Endpoint

- Bookmarks appeared as expected.
- As long as Company Portal is logged on by the target user, which Edge profile to use does not matter.
- They appear in an InPrivate window too.
- Edge://policy can be useful in troubleshooting.



