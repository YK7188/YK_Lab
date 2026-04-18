## Objective
Validate how a custom compliance policy is configured and evaluated in Intune using a BIOS version check.

---

## Add script to collect BIOS version

Path: `Devices → Compliance → Scripts > Add > Windows 10 and later`

Add the script below. It collects the BIOS version (format: xx.yy.zz) and converts it into a comparable integer (xxyyzz).

<pre>
$raw = (Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion

if ($raw -match '^\d+(\.\d+)+$') {
    $version = [version]$raw

    # Convert to comparable integer: 1.42.0 → 14200
    $normalized = ($version.Major * 10000) + ($version.Minor * 100) + $version.Build
}
else {
    # Fallback for non-standard values (e.g. VM)
    $normalized = 0
}

$result = @{
    BIOSVersion = $normalized
}

# Important: Explicit output for Intune
Write-Output ($result | ConvertTo-Json -Compress)
</pre> 


<br>
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/12-custom%20compliance/01.%20add_Bios_script.jpg" width="600">
<br>

---

## Create compliance policy

Path: `Devices → Compliance > Policies > Create Policy > Windows 10 and later`

Upload the JSON file below during policy creation.

This rule evaluates compliance based on the integer value returned by the script.

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

- YAS-LAB (BIOS 1.42.0 → 14200) → Compliant
- Other test devices → Non-compliant

Results matched expectations after policy evaluation completed.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/12-custom%20compliance/06.%20hostcompliant.jpg" width="600">
<br>

---

## Key points

✔ Compliance evaluation can be delayed

Custom compliance may take several hours (up to ~8 hours in this lab even after the device synced with intune) before results appear.

✔ Hardware inventory cannot be used directly

Although BIOS version is visible under the Hardware blade, it cannot be referenced in compliance policies.

✔ User sign-in affects evaluation timing

Devices signed in with only a local account may remain in a “Not applicable” state longer.

In this lab, the device remained Not applicable under a local account and became Compliant immediately after Azure AD sign-in.
