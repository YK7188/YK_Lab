## Objective
Test how a custom policy is configured.

<br>
---

## Add Script to collect Bios version in Intune

Path: `Devices → Compliance → Scripts > Add > Windows 10 and later`

Add the script below, which will be used to configure a compliance policy.

This script will gather Bios version of a device; xx.yy.zz and convert it to integar xxyyzz.

<pre>
$raw = (Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion

if ($raw -match '^\d+(\.\d+)+$') {
    $version = [version]$raw

    # Convert to comparable integer: 01.42.00 → 014200
    $normalized = ($version.Major * 10000) + ($version.Minor * 100) + $version.Build
}
else {
    $normalized = 0
}

@{
    BIOSVersion = $normalized
} | ConvertTo-Json -Compress
</pre> 


<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/12-custom%20compliance/01.%20add_Bios_script.jpg" width="600">

<br>
---

## Create compliance policy

Path: `Devices → Compliance > Policies > Create Policy > Windows 10 and later`

Upload the JSON file below in compliance creation.

This JSON file is to decide a device's compliance depending on the integer value obtained from it.

<pre>
{
  "Rules": [
    {
      "SettingName": "BIOSVersion",
      "Operator": "GreaterEquals",
      "DataType": "Int64",
      "Operand": 12000,
      "MoreInfoUrl": "https://example.com",
      "RemediationStrings": [
        {
          "Language": "en_US",
          "Title": "BIOS too old",
          "Description": "Update BIOS."
        }
      ]
    }
  ]
}
</pre>

<br>

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/12-custom%20compliance/02.%20compliance%20policy.jpg" width="600">
<br>

---

## Validation

YAS-LAB (Bios version 1.42) appears as compliant and the other test devices appear as non-compliant as expected.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/12-custom%20compliance/05.%20hostcompliant.jpg" width="600">


---

## Key points

✔ Compliance policy may take as long as 8 hours to be effective.

✔ Although Bios version is listed in Hardware blade of a device, it cannot be used for a compliance policy.
