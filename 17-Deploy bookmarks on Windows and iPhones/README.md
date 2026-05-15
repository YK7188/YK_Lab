Tested: May 2026

# LAB SCENARIO

> IT wants standardized bookmarks deployed to managed browsers for Windows PCs and iPhones to achieve faster onboarding of new employees.

---

# PART 1 — Edge on Windows

## Step 1 — Create Configuration Profile

Path: `Devices > Windows > Configuration > Create > Windows 10 and later > Settings catalog`

For Configuration settings, select Microsoft Edge > Configure favorites (User) and set the JSON payload below in Configuration settings. 

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
- The managed bookmarks appeared regardless of which browser profile was signed in.
- They appear in an InPrivate window too.
- Edge://policy can be useful in troubleshooting when the policy shows "Succeeded" in Intune but bookmarks do not appear.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/02.bookmarks_appeared.jpg" width="400">

---

# PART 2 — Chrome on Windows

## Step 1 — Upload Windows ADMX and ADML files in Intune

1. Download the msi file from the page below and execute it.

   https://www.microsoft.com/en-us/download/details.aspx?id=108394

2. ADMX and ADML file are created in the paths below.

- Windows.ADMX
  C:\Program Files (x86)\Microsoft Group Policy\Windows 11 Sep 2025 Update (25H2)\PolicyDefinitions

- Windows.ADML
  C:\Program Files (x86)\Microsoft Group Policy\Windows 11 Sep 2025 Update (25H2)\PolicyDefinitions\en-US

3. Upload the files in Intune.
   Path: `Devices > Configuration > Import ADMX`


<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/05.windows_admx_upload.jpg
" width="600">
   

## Step 2 Upload Google ADMX and ADML files in Intune

Download the ADM/ADMX templates in the page below and extract the zip file.

https://chromeenterprise.google/intl/en_us/download/


Path: `Devices > Configuration > Import ADMX`

- google.ADMX
  - In the download templates:
  - Path: `policy_templates > windows > ADMX`

- google.ADML
  - In the download templates:
  - Path: `policy_templates > windows > ADMX > en-US`

- chrome.ADMX
  - In the download templates:
  - Path: `policy_templates > windows > ADMX`

- chrome.ADML
  - In the download templates:
  - Path: `policy_templates > windows > ADMX > en-US`

All three ADMX templates were uploaded successfully as shown in the image.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/15.admx_appear.jpg" width="600">



#### Key point

- Windows.ADMX and Google.ADMX need to be uploaded before Chrome.ADMX.
- When you open the Chrome.ADMX file, prefix="Google" and prefix="windows" are present under policyNamespaces.
- This means uploading chrome.ADMX depends on these two files.

```
  <policyNamespaces>
    <target namespace="Google.Policies.Chrome" prefix="chrome"/>
    <using namespace="Google.Policies" prefix="Google"/>
    <using namespace="Microsoft.Policies.Windows" prefix="windows"/>
```


## Step 3 — Create Configuration profile

Path: Devices > `Windows > Configuration > Create > Windows 10 and later > Templates > Imported Administrative templates`

For Configuration settings, select Managed Bookmarks and enter the same JSON as used in PART 1 — Edge on Windows. 

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/07.managed_bookmarks.jpg" width="600">


## Step 4 — Verify on Endpoint

- Bookmarks appeared as expected.
- The managed bookmarks appeared regardless of which browser profile was signed in.
- They appear in an InPrivate window too.
- Chrome://policy can be useful in troubleshooting when the policy shows "Succeeded" in Intune but bookmarks do not appear.


---

# PART 3 — Edge on iPhone

## Step 1 — Create Edge app

Path: `Apps > iOS/iPadOS > Create > iOS store app`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/08.Create_Edge_app.jpg" width="600">

## Step 2 — Create Edge configuration policy

Path: `Apps > iOS/iPadOS > Configuration > Managed Devices`

Select Configuration settings format > Enter XML data

The XML payload format is documented in the Microsoft article below:

https://learn.microsoft.com/en-us/deployedge/microsoft-edge-mobile-policies#managedfavorites

-> ManagedFavorites

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/17.create_appconfig_edge.jpg" width="500">


## Step 3 — Verify on Endpoint

- Bookmarks appeared as expected.
- As long as the device is enrolled in Intune and the browser app is managed by Intune, the bookmarks appear regardless of which browser profile is signed in.
- They appear in an InPrivate window too.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/13.Edge_Policy.jpg" width="250">

---

# PART 4 — Chrome on iPhone

## Step 1 — Add Chrome app

Path: `Apps > iOS/iPadOS > Create > iOS Store App`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/17-Bookmarks%20on%20Windows%20and%20iPhone/14.Create_Google_app.jpg" width=300">


## Step 2 — Create App Configuration Policy

Path: `Apps > iOS/iPadOS > Configuration > Managed Devices`

Select Configuration settings format > Enter XML data

The XML payload structure was referenced from the macOS example in the Google Chrome Enterprise policy documentation below:

https://chromeenterprise.google/policies/#ManagedBookmarks

## Step 3 — Verify on Endpoint

- Bookmarks appeared as expected.
- As long as the device is enrolled in Intune and the browser app is managed by Intune, the bookmarks appear regardless of which browser profile is signed in.
- They appear in an InPrivate window too.

---

# Final Note

- For iPhone deployment, the configuration must be entered as raw XML data rather than Key/Type/Value pairs.
- On iPhone, apps already installed before Intune enrollment may not immediately appear as managed apps in Intune. 
Reinstalling the app after enrollment ensured the application became associated with Intune app management and allowed app configuration policies to apply successfully.
