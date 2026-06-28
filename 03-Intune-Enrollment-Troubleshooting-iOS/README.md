## Scenario
An iOS device failed to enroll into Microsoft Intune, showing an error during the 窶廛ownload management profile窶・step in the Company Portal app.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/03-intune-enrollment-troubleshoot/01%20error.jpg" width="200">

---

## Initial troubleshooting

Verified user credentials (successful on desktop)

Disabled Conditional Access policy in Microsoft Entra ID

Confirmed no stale device records in Entra ID / Intune

Updated iOS to latest version

Updated Microsoft Intune Company Portal app

Restarted device

---

## Key observation

Device object was created in Microsoft Entra ID and the failure consistently occurred at:

Download management profile

---

## Root cause

The Apple MDM Push Certificate in Microsoft Intune was found to be expired.
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/03-intune-enrollment-troubleshoot/02.%20expired.jpg" width="700">

## Resolution

- Renewed the certificate via the Apple Push Certificates Portal

- Uploaded the renewed .pem file back into Intune

After renewal:

- Certificate status changed to Active

- iOS enrollment completed successfully

