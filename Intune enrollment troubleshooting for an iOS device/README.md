## Scenario
An iOS device failed to enroll into Microsoft Intune, showing an error during the “Download management profile” step in the Company Portal app.
![01 error](https://github.com/user-attachments/assets/11683877-329e-4946-8936-a924a8e04dd2)

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
![02  expired](https://github.com/user-attachments/assets/6f4d06fc-8818-4f23-8f1d-098fef6eb8d3)

## Resolution

- Renewed the certificate via the Apple Push Certificates Portal

- Uploaded the renewed .pem file back into Intune

After renewal:

- Certificate status changed to Active

- iOS enrollment completed successfully
