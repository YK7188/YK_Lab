Tested: May 2026

# LAB SCENARIO

> IT wants standardized bookmarks deployed to managed browsers for faster onboarding of new employees.

---

# PART 1 — Edge on Windows

## Step 1 — Create Configuration Profile

Path: `Devices > Windows > Configuration > Create > Windows 10 and later > Settings catalog`

Set the script below in Configuration settings. 

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

image

## Step 2 — Verify on Endpoint

- Bookmarks appeared as expected.
- As long as Window is logged on by the target user, which Edge profile to use does not matter.
- They appear in an InPrivate window too.

imag

---

# PART 2 — Chrome on Windows

## Step 1 — Upload Windows admx and adml files in Intune

1. Download an msi file from the page below and excute it.

   https://www.microsoft.com/en-us/download/details.aspx?id=108394

2. admx and adml file is created in the paths below.

- Windows.admx
  C:\Program Files (x86)\Microsoft Group Policy\Windows 11 Sep 2025 Update (25H2)\PolicyDefinitions

- Windows.adml
  C:\Program Files (x86)\Microsoft Group Policy\Windows 11 Sep 2025 Update (25H2)\PolicyDefinitions\en-US

3. Upload the files in Intune.
   Path: `Devices → Configuration → Import ADMX`


Image
   

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


#### Key point

- Windows.admx and Google.admx need to be uploaded before Chrome.admx.
- When you open the Chrome.admx file, prefix="Google" and prefix="windows" are present.
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


## Step 4 — Verify on Endpoint

- Bookmarks appeared as expected.
- As long as Window is logged on by the target user, which Edge profile to use does not matter.
- They appear in an InPrivate window too.

imag


# PART 3 — Edge on iPhone

## Step 1 — Create Edge app

Apps > iOS/iPadOS > Create > iOS store app

image 


