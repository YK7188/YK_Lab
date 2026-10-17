> Last Updated: June 2026
> 
> Initial Publication: May 2026

# Original Lab

# Lab Goal

IT wants onboarding Windows devices to automatically obtain PKCS certificates.

So I configure a hybrid PKI structure like below using my developer's Entra ID tenant and Hyper-V on-premises Active Directory environment.

```
Traditional AD autoenrollment:
Device > Enterprise CA

Intune PKCS:
Device > Intune > Certificate Connector > Enterprise CA
```

# Final Architecture

```
SRV1 (Domain Controller)
- Windows server 2016
- Active Directory
- Enterprise Root CA

SRV3 (Certificate Connector Server)
- Windows server 2016

ADPC1 (Windows Client 1)
- Windows 10
- On-premises AD-joined

AADPC1 (Windows Client 2)
- Windows 11
- Entra ID-joined / Intune enrolled
```

# STEP 1 - Confirm AD CS Role Installed

Confirm installed:

`Active Directory Certificate Services > Certification Authority`

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/01.role_installation.jpg" width="600">

# STEP 2 - Configure the CA

Click:

`Configure Active Directory Certificate Services`

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/02.post_deployment_confg.jpg" width="400">


and proceed with the wizard

- Credentials > Domain admin account
- Role Services > Certification Authority
- Setup Type > Enterprise CA
- CA Type > Root CA
- Private Key > Create a new private key
- Cryptography (Leave it as default)
  - RSA#Microsoft Software Key Storage Provider
  - 2048
  - SHA256
- CA Name > CORP-ROOT-CA
- Validity Period > 5 years
- Database Locations > Leave it as default

# STEP 3 - Open Certification Authority Console

CORP-ROOT-CA is now up and running

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/03.CA_up.jpg" width="400">

# STEP 4 - Verify Root Trust on Domain PC

On the AD-joined test device, open certmgr.msc:

`CORP-ROOT-CA appears under Trusted Root Certification Authorities > Certificates`

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/04.Root_Cert_shown.jpg" width="500">

> Active Directory automatically distributed CA trust to all AD-joined devices.

# STEP 5 - Publish a certificate template

In Certificates Templates Console (certtmpl.msc):

Right click Computer > Duplicate Template

- Compatibility tab
  - Compatibility settings > Choose the latest versions for this lab.

- General tab
  - Template display name > LabComputerCert

- Security tab
  - Ensure Domain computers has Read, Enroll, Autoenroll permissions

> For traditional AD autoenrollment, Domain Computers requires Read, Enroll, and Autoenroll permissions.
> For Intune PKCS deployment, the connector service account also requires Read and Enroll permissions on the Intune-specific certificate template.
> * Missed this part first in my configuration.

In certsrv:

`Certificate Templates > New > Certificate Template to issue`

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/05.cert_template.jpg" width="500">

Select LabComputerCert and Click OK

> Clients may now request certificates based on this template, and the template is now available for autoenrollment.

> Enterprises commonly duplicate templates rather than modifying/using defaults directly

# STEP 6 - Test certificate enrollment by GPO policy

Run gpmc.msc and create a new GPO object:

Certificate Services Client - Auto-Enrollment

Path: `Computer Configuration > Policies > Windows Settings > Security Settings > Public Key Policies `

Enable the policy and Check:

- Renew expired certificates, update pending certificates, and remove revoked certificates
- Update certificates that use certificate templates

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/18.GPO_Enabled.jpg" width="600">

On the AD-joined test device, Certificate now appears in Personal folder

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/13.Cert_appears.jpg" width="600">

> For better management, easier troubleshooting, creating a new object is better than adding to the default domain policy object.

# Step 7 - Install Intune Certificate Connector

Microsoft's recommendation is:
- Windows Server 2012 R2 or later.
- Intune connector server better not be colocated with the CA.

On connector server, go to Intune and download the .exe file.

Path: Tenant admin > Connectors and tokens > Certificate Connectors > Add

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/14.connector_download.jpg" width="600">

Run downloaded IntuneCertificateConnector.exe and proceed with the wizard.

- Service Account > Domain Account
  - Created a new domain account for best practice. No administrative privileges were required for this lab's purpose.
  - Open secpol.msc and add the account to `Local policies > User Rights assignment > Log on as a service`
- Features > SCEP unticked (not required for this lab), all the others ticked
- Service account type > Domain Account

The connector now appears in Intune.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/15.connector_appear.jpg" width="600">

# Step 8 - Deploy Trusted Root Certificate profile

> Intune managed devices need to trust the on-prem CA

## Export Root CA certificate

On CA server, run certsrv.msc and right-click CA

Path: `Properties > View Certificate > Details > Copy to File`

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/25.Cert_Copy_CA.jpg" width="700">

Export:

Base-64 encoded X.509 (.CER)


## Create Trusted Certificate profile in Intune

In Microsoft Intune:

Path:

Devices > Configuration > Create > New policy

Platform: 

Windows 10 and later

Profile type: 

Templates > Trusted certificate

Upload:

The copied file from the CA

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/17.Cert_config_intune.jpg" width="600">

Assign to test device group.

The root certificate now appears on a Entra ID-joined PC.

# STEP 9 - Create PKCS certificate profile

In Microsoft Intune:

Path:

Devices > Configuration > Create > New policy

Platform: 

Windows 10 and later

Profile type: 

Templates > PKCS certificate

Configuration Settings:

Key storage provider (KSP) > Enroll to Trusted Platform Module (TPM) KSP if present, otherwise Software KSP
> TPM keeps the private key hardware-protected and non-exportable where supported.

Subject name format > CN={{DeviceName}}
> It will show the device name.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/26.failed_PKCS_config.jpg" width="600">

Result:

Error appeared in Intune

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/20.pkcs_error.jpg" width="600">


# STEP 10 - Troubleshoot

## Part 1 - Publish a new certificate template for Intune devices

On CA Server, run certtmpl.msc:

Right click LabComputerCert > Duplicate Template

- General tab
  - Template display name > LabComputerCert-Intune

- Subject Name tab
  - Select Supply in the request
> Intune PKCS supplies the certificate subject name dynamically using the PKCS profile configuration.

- Cryptography tab
  - Select Key Storage Provider, RSA for Provider Category

> A separate certificate template was created for Intune devices to avoid affecting traditional AD autoenrollment behavior.

In certsrv:

`Certificate Templates > New > Certificate Template to issue`

Select LabComputerCert-Intune and Click OK

In Intune:

- Update the target certificate template from LabComputerCert to LabComputerCert-Intune

Result:

The issue persists

## Part 2 - Correcting CA Connector account's permissions

Check Event Viewer on Connector server
Path: Applications and Services Logs > Microsoft > Intune > CertificateConnectors

Error appears as:
- PKCSRequestFailure
- User > Connector account (svc_intunecert)
- Denied by Policy Module

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/22.Denied_By_Module.jpg" width="600">

> Intune requests the certificate but it is denied by the CA.

Fix:

- run certtmpl.msc on CA server
- Open LabComputerCert-Intune > Properties > Security 

Add svc_intunecert with Read, Enroll permissions

Result:

On the Entra ID-joined test device, run certlm.msc

PKCS cert appears

The configuration report shows Success for the device as well

# Final Result

The hybrid PKI environment was successfully configured.

Traditional AD autoenrollment worked for on-premises AD-joined devices, while Intune PKCS deployment successfully delivered certificates to Entra ID-joined devices through the Intune Certificate Connector and on-premises Enterprise CA.


---

<br>
<br>

# UPDATE - June 2026

The following section was added after the original lab was completed.

## Extending PKCS Deployment to Android

##### Step 1 - Trusted Certificate Profile

In Intune, create a new configuration profile for the CA certificate.

Path: Devices > Android > Configuration > Create > New Policy > Android Enterprise > Templates > Trusted Certificate

##### Step 2 - PKCS Certificate Profile 

In Intune, create a new configuration profile for the PKCS certificate.

Path: Devices > Android > Configuration > Create > New Policy > Android Enterprise > Templates > PKCS Certificate

##### Step 3 - Verification

The CA certificate appears on the Android. Although PKCS cert is not listed alongside other certificates, it appears in the certificate picker when configuring a VPN connection. 

Device name: AADuser1test_AndroidForWork

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-Intune%20VPN%20Profiles%20%26%20Certificate%20Deployment/08.pkcs_shown_sSwan.jpg" width="300">

## Extending PKCS Deployment to iPhone

##### Step 1 - Trusted Certificate Profile

In Intune, create a new configuration profile for the CA certificate.

Path: Devices > Apple mobile > Configuration > Create > New Policy > iOS/iPadOS > Templates > Trusted Certificate

##### Step 2 - PKCS Certificate Profile 

In Intune, create a new configuration profile for the PKCS certificate.

Path: Devices > Apple mobile > Configuration > Create > New Policy > iOS/iPadOS > Templates > PKCS Certificate

##### Step 3 - Verification

The certificates appear on the iPhone. The management profile shows both the Trusted Certificate profile and PKCS Certificate profile as successfully applied. Intune reporting also shows successful deployment.









# Lab 18 — Hybrid PKI Simulation (AD CS + Intune PKCS)

**Labbed: May 2026**  
**Extended: June 2026 — Android and iOS**  
**Updated: October 2026 — Reorganized procedure and troubleshooting**

## Goal

Configure an on-premises Enterprise Root CA and demonstrate two ways of obtaining device certificates:

- **AD-joined Windows:** certificate auto-enrollment using Group Policy and AD CS.
- **Intune-managed devices:** PKCS certificate deployment through the Intune Certificate Connector and the same on-premises CA, tested on Windows, Android Enterprise and iPhone.

## Architecture

```text
Traditional AD auto-enrollment:
ADPC1 (AD-joined) → Computer GPO → AD CS / LabComputerCert → Device certificate

Intune PKCS:
AADPC1 / Android / iPhone → Intune → Certificate Connector (SRV3)
                                       → AD CS / LabComputerCert-Intune
                                       → Device certificate
```

| Machine | System | Role |
|---|---|---|
| SRV1 | Windows Server 2016 | AD DS, Domain Controller, Enterprise Root CA |
| SRV3 | Windows Server 2016 | Intune Certificate Connector |
| ADPC1 | Windows 10 | AD-joined client |
| AADPC1 | Windows 11 | Entra-joined, Intune-enrolled client |
| Android | Android Enterprise | Work-profile device |
| iPhone | iOS | Intune-managed device |

## Part 1 — Enterprise CA

### 1. Install AD CS

On SRV1, install **Active Directory Certificate Services > Certification Authority**.

![AD CS role installed](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/01.role_installation.jpg)

### 2. Configure the CA

Run **Configure Active Directory Certificate Services** with:

- Credentials: Domain administrator
- Role services: Certification Authority
- Setup type: Enterprise CA
- CA type: Root CA
- Private key: Create a new private key
- Cryptography: RSA#Microsoft Software Key Storage Provider; 2048-bit RSA; SHA256
- CA name: `CORP-ROOT-CA`
- Validity: 5 years
- Database locations: Default

![AD CS post-deployment configuration](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/02.post_deployment_confg.jpg)

### 3. Confirm CA status

Open `certsrv.msc` and verify `CORP-ROOT-CA` is running.

![Enterprise CA running](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/03.CA_up.jpg)

### 4. Verify domain computer trusts the CA

On ADPC1, open `certlm.msc` and inspect **Trusted Root Certification Authorities > Certificates**. Verify `CORP-ROOT-CA` appears.

![Trusted root certificate](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/04.Root_Cert_shown.jpg)

This is **CA trust**, not the device identity certificate that will be issued next.

## Part 2 — AD-joined Windows certificate auto-enrollment

### 5. Publish a computer certificate template

Open `certtmpl.msc`, duplicate the **Computer** template and configure:

- **Compatibility:** Supported CA and client versions for this lab
- **General:** Template display name `LabComputerCert`
- **Security:** `Domain Computers` — **Read, Enroll, Autoenroll**

In `certsrv.msc`, select **Certificate Templates > New > Certificate Template to Issue** and publish `LabComputerCert`.

![Published computer certificate template](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/05.cert_template.jpg)

### 6. Enable auto-enrollment via GPO

In `gpmc.msc`, create and link a GPO to the OU containing ADPC1. Navigate to:

**Computer Configuration > Policies > Windows Settings > Security Settings > Public Key Policies > Certificate Services Client – Auto-Enrollment**

Set to **Enabled** and select:

- Renew expired certificates, update pending certificates, and remove revoked certificates
- Update certificates that use certificate templates

![Computer certificate auto-enrollment GPO](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/18.GPO_Enabled.jpg)

The GPO enables auto-enrollment; it does **not** select a specific certificate template. Eligible published templates are determined by template settings and permissions.

### 7. Verify the issued device certificate

On ADPC1, refresh policy if necessary (`gpupdate /force`) and open `certlm.msc` → **Personal > Certificates**. Confirm the issued computer certificate.

![AD-joined computer certificate](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/13.Cert_appears.jpg)

**Result:** ADPC1 obtains a device certificate directly through AD CS auto-enrollment, without Intune.

## Part 3 — Intune Certificate Connector and PKCS template

### 8. Create an Intune-specific template

On SRV1, duplicate `LabComputerCert` in `certtmpl.msc`:

- **General:** `LabComputerCert-Intune`
- **Subject Name:** **Supply in the request**
- **Cryptography:** Key Storage Provider, RSA
- **Security:** `svc_intunecert` — **Read, Enroll**

Publish `LabComputerCert-Intune` in `certsrv.msc` under **Certificate Templates > New > Certificate Template to Issue**.

This separate template allows Intune to supply the subject from the PKCS profile, without changing the template used for AD auto-enrollment.

### 9. Install the Certificate Connector

On SRV3, prepare domain service account `svc_intunecert` and grant **Log on as a service** through `secpol.msc` → **Local Policies > User Rights Assignment**. The right to log on as a service is distinct from the template's Read/Enroll permissions.

In Intune, navigate to **Tenant administration > Connectors and tokens > Certificate connectors > Add**, download and run `IntuneCertificateConnector.exe`.

![Certificate Connector download](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/14.connector_download.jpg)

Select the PKCS connector feature and configure the domain service account. SCEP is not required for this lab. Confirm the connector is registered in Intune.

![Connector registered in Intune](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/15.connector_appear.jpg)

**Connectivity:** SRV3 needs connectivity to the on-premises CA **and** required Microsoft Intune cloud endpoints.

## Part 4 — Windows Intune PKCS deployment

### 10. Export and deploy the trusted root CA certificate

On SRV1: `certsrv.msc` → right-click CA → **Properties > View Certificate > Details > Copy to File**. Export as **Base-64 encoded X.509 (.CER)** (public certificate only).

![Export the CA certificate](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/25.Cert_Copy_CA.jpg)

In Intune: **Devices > Configuration > Create > New policy**:

- Platform: **Windows 10 and later**
- Template: **Trusted certificate**
- Upload the exported `.cer`
- Assign to the Windows test device group

![Windows trusted certificate profile](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/17.Cert_config_intune.jpg)

### 11. Create Windows PKCS profile

In Intune, create a **Windows 10 and later > Templates > PKCS certificate** profile:

- CA: `CORP-ROOT-CA`
- Template: `LabComputerCert-Intune`
- Certificate type: **Device**
- Subject name: `CN={{DeviceName}}`
- KSP: **Enroll to TPM KSP if present, otherwise Software KSP**

Assign to AADPC1's test group.

![Windows PKCS configuration screenshot from original lab](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/26.failed_PKCS_config.jpg)

### 12. Verify Windows deployment

On AADPC1, inspect `certlm.msc` → **Personal > Certificates**. Confirm the issued PKCS certificate and check that the Intune profile reports **Succeeded**.

## Part 5 — Android Enterprise PKCS

### 13. Deploy root CA trust

In Intune, create an **Android Enterprise > Trusted certificate** profile for the work-profile enrollment type. Upload the CA `.cer` and assign to the Android device.

### 14. Deploy Android PKCS profile

Create an **Android Enterprise > PKCS certificate** profile for the same work-profile enrollment type:

- CA/template: `CORP-ROOT-CA` / `LabComputerCert-Intune`
- Certificate type: **Device**
- Subject: `CN={{DeviceName}}`
- SAN: **None**
- Extended Key Usage: **Client Authentication** (`1.3.6.1.5.5.7.3.2`)
- Root certificate: previously deployed Android trusted certificate profile

### 15. Verify Android deployment

Confirm the trusted root and PKCS profiles show **Succeeded** in Intune. The trusted CA certificate appears in Android's trust settings; the PKCS client identity certificate need not appear alongside trusted CAs. In the lab, the PKCS certificate was selectable in strongSwan's VPN certificate picker and its thumbprint matched Intune.

Device: `AADuser1test_AndroidForWork`.

![PKCS client certificate visible in strongSwan](https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-Intune%20VPN%20Profiles%20%26%20Certificate%20Deployment/08.pkcs_shown_sSwan.jpg)

## Part 6 — iPhone PKCS

### 16. Deploy trusted root

Create an **iOS/iPadOS > Trusted certificate** profile with the exported root CA `.cer`; assign it to the iPhone.

### 17. Deploy PKCS certificate

Create an **iOS/iPadOS > PKCS certificate** profile using the Enterprise CA, `LabComputerCert-Intune`, **Device** certificate type, and `CN={{DeviceName}}`. Assign it to the iPhone.

### 18. Verify iPhone

Check the iPhone's management profile for the certificates and verify successful profile status in Intune.

## Final result

| Device | Method | Result |
|---|---|---|
| ADPC1 | GPO + AD CS auto-enrollment | Successful |
| AADPC1 | Intune PKCS + connector | Successful |
| Android Enterprise | Intune PKCS + connector | Successful |
| iPhone | Intune PKCS + connector | Successful |

---

## What I Missed / Troubleshooting

### 1. Wrong template configuration for Intune PKCS

Initially, the Windows PKCS deployment reported an error.

![Original Windows PKCS deployment error](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/20.pkcs_error.jpg)

The initial computer template was intended for traditional AD auto-enrollment. I created a separate `LabComputerCert-Intune` template with **Supply in the request** and an RSA Key Storage Provider. The problem still persisted until I corrected the connector account permissions.

### 2. Connector account lacked template enrollment permissions

On SRV3, Event Viewer under **Applications and Services Logs > Microsoft > Intune > CertificateConnectors** showed `PKCSRequestFailure` and **Denied by Policy Module** for `svc_intunecert`.

![Certificate Connector policy-module denial](https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/22.Denied_By_Module.jpg)

**Fix:** Grant `svc_intunecert` **Read** and **Enroll** on `LabComputerCert-Intune`. The Windows certificate was then issued successfully.

**Lesson:** **Log on as a service** permits the connector service to run; it does not authorize the account to enroll against an AD CS template.

### 3. Android PKCS error despite successful root CA deployment

The Android trusted certificate deployed, but the PKCS profile initially reported an error. The connector server had no internet connection. After restoring connectivity, the PKCS certificate appeared in strongSwan and the Intune profile error subsequently cleared.

**Lesson:** Deploying a root CA certificate and issuing a PKCS identity certificate are separate processes. Check connector cloud connectivity, CA issued certificates, connector events, and Intune reporting.

### 4. Android PKCS certificate not visible in Trusted credentials

Android displayed the CA trust certificate but not the PKCS client identity certificate in its normal trust list. strongSwan could still select the client certificate.

**Lesson:** A trusted root CA certificate is different from a client identity certificate. Microsoft's PKCS documentation notes that Android Enterprise PKCS certificates aren't visible in the normal device certificate interface; check Intune deployment status.

## Microsoft documentation

- [Use PKCS certificate profiles with Microsoft Intune — Microsoft Learn](https://learn.microsoft.com/en-us/intune/device-configuration/certificates/pkcs-profiles) — includes the note about Android Enterprise PKCS certificate visibility.
- [Trusted root certificate profiles for Microsoft Intune — Microsoft Learn](https://learn.microsoft.com/en-us/intune/intune-service/protect/certificates-trusted-root)

