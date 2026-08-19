> Labbed: August 2026

# Scenario

Following [29-Hybrid-Setup_User-Identity](https://github.com/YK7188/YK_Lab/tree/main/29-Hybrid-Setup_User-Identity) and [30-Hybrid-Setup_Device-Identity](https://github.com/YK7188/YK_Lab/tree/main/30-Hybrid-Setup_Device-Identity), this lab demonstrates two methods of enrolling Hybrid Microsoft Entra joined Windows devices into Intune:

- GPO-based automatic MDM enrollment
- Configuration Manager co-management enrollment
  
# Part 1 - GPO Automatic Enrollment

### 1. Check Intune automatic enrollment

In Intune, go to:

**Devices > Enrollment > Windows > Automatic Enrollment**

Ensure the synchronized test user is included in the **MDM user scope**.

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/31-IntuneEnrollment_HybridDevices/01.jpg" width="500">

### 2. Configure the GPO

On the domain controller, open `gpmc.msc` and create a GPO linked to the target device OU.

Enable:

**Enable automatic MDM enrollment using default Azure AD credentials**

Use **User Credential** for the enrollment.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/31-IntuneEnrollment_HybridDevices/03.jpg" width="600">

### 3. Troubleshoot enrollment

Log on to the test device with the synchronized user.

Although the GPO applied successfully, the device did not enroll into Intune.

`dsregcmd /status` showed:

- `AzureAdPrt : NO`
- `AADSTS50034`
- the on-premises UPN as the identity used for PRT acquisition

<br>

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/31-IntuneEnrollment_HybridDevices/06.jpg" width="700">

The UPN mismatch between the on-premises user and the synchronized Entra user prevented the signed-in user from obtaining a Microsoft Entra Primary Refresh Token (PRT), which prevented user-credential MDM enrollment.

> This condition resulted from the UPN design used in [29-Hybrid-Setup_User-Identity](https://github.com/YK7188/YK_Lab/tree/main/29-Hybrid-Setup_User-Identity), where the on-premises AD suffix was not verified in Microsoft Entra ID.

### 4. Correct the UPN mismatch

On the domain controller, open **Active Directory Domains and Trusts**.

Go to **Properties > Alternative UPN suffixes** and add the Entra UPN suffix used by the synchronized user.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/31-IntuneEnrollment_HybridDevices/05.jpg" width="600">

In Active Directory Users and Computers, update the test user's UPN to use the matching suffix.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/31-IntuneEnrollment_HybridDevices/08.jpg" width="600">

After signing out and back in, `dsregcmd /status` showed:

`AzureAdPrt : YES`

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/31-IntuneEnrollment_HybridDevices/07.jpg" width="600">

The device, **HBPC2**, then completed automatic enrollment and appeared in Intune as **Managed by: Intune**.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/31-IntuneEnrollment_HybridDevices/15.jpg" width="500">

### Requirements observed in this lab

- The device is Hybrid Microsoft Entra joined.
- The synchronized user is assigned Microsoft Entra ID P1 or P2 and Microsoft Intune Plan 1 (or licenses that include these capabilities).
  > [Microsoft Intune Licensing](https://learn.microsoft.com/en-us/intune/fundamentals/licensing#license-requirements)
- The user is included in the Intune MDM user scope.
- The signed-in user's on-premises UPN can be resolved to the corresponding Entra identity so that a PRT can be obtained.

---

# Part 2 - Configuration Manager Co-management Enrollment

### 1. Configure Cloud Attach

In the Configuration Manager console, go to:

**Administration > Cloud Services > Cloud Attach**

Run **Configure Cloud Attach**.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/31-IntuneEnrollment_HybridDevices/04.jpg" width="600">

For this lab:

- **Upload to Microsoft Intune admin center** was disabled because tenant attach was not required for the enrollment test.
- **Automatic enrollment in Intune** was set to **Pilot**.
- A device collection containing only **HBPC1** was selected for the enrollment pilot.

> Tenant attach uploads Configuration Manager device information to the Intune admin center without requiring those devices to be Intune MDM-enrolled. It is separate from co-management enrollment.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/31-IntuneEnrollment_HybridDevices/13.jpg" width="600">

### 2. Verification

After receiving the co-management policy, **HBPC1** automatically enrolled into Intune and appeared as:

**Managed by: Co-managed**

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/31-IntuneEnrollment_HybridDevices/15.jpg" width="600">

Unlike the GPO user-credential method, Configuration Manager co-management automatic enrollment uses the Microsoft Entra device token and does not require an interactive user sign-in.
> [How to enable co-management in Configuration Manager](https://learn.microsoft.com/en-us/intune/configmgr/comanage/how-to-enable)

The Intune device record reflected the device-based enrollment:

- **Primary user:** None
- **Enrolled by:** Blank
- **Compliance:** See ConfigMgr

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/31-IntuneEnrollment_HybridDevices/16.jpg" width="600">

### Requirements observed in this lab

- The device is Hybrid Microsoft Entra joined.
- The Configuration Manager client is installed and healthy.
- The device is included in the co-management automatic-enrollment scope.

---

# Result

Two Hybrid Microsoft Entra joined devices were successfully enrolled using different methods:

| Device | Enrollment method | Management state |
|---|---|---|
| HBPC1 | Configuration Manager co-management | Co-managed |
| HBPC2 | GPO automatic MDM enrollment | Intune |

