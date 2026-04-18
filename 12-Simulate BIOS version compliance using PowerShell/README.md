## Add Script to collect Bios version in Intune

Path: `Devices → Compliance → Scripts > Add > Windows 10 and later`

Add the script below to configure a compliance policy.

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

---

## Create compliance policy

Path: `Devices → Compliance > Policies > Create Policy > Windows 10 and later`

- JSON file

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

---

## Key points

✔ Compliance policy may take as long as 8 hours to be effective.
✔ Although Bios version is listed in Hardware blade of a device, it cannot be used for a compliance policy.
