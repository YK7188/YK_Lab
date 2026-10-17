> Last Updated: Oct 2026
> 
> Initial Publication: May 2026

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

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/01.role_installation.jpg" width="600">


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

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/02.post_deployment_confg.jpg" width="600">

### 3. Confirm CA status

Open `certsrv.msc` and verify `CORP-ROOT-CA` is running.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/03.CA_up.jpg" width="600">

### 4. Verify domain computer trusts the CA

On ADPC1, open `certlm.msc` and inspect **Trusted Root Certification Authorities > Certificates**. Verify `CORP-ROOT-CA` appears.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/04.Root_Cert_shown.jpg" width="600">

This is **CA trust**, not the device identity certificate that will be issued next.

## Part 2 — AD-joined Windows certificate auto-enrollment

### 5. Publish a computer certificate template

Open `certtmpl.msc`, duplicate the **Computer** template and configure:

- **Compatibility:** CA - Windows Server 2016; Recipient - Windows 10 / Windows Server 2016
- **General:** Template display name `LabComputerCert`
- **Security:** `Domain Computers` — **Read, Enroll, Autoenroll**

In `certsrv.msc`, select **Certificate Templates > New > Certificate Template to Issue** and publish `LabComputerCert`.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/05.cert_template.jpg" width="600">

### 6. Enable auto-enrollment via GPO

In `gpmc.msc`, create and link a GPO to the OU containing ADPC1. Navigate to:

**Computer Configuration > Policies > Windows Settings > Security Settings > Public Key Policies > Certificate Services Client – Auto-Enrollment**

Set to **Enabled** and select:

- Renew expired certificates, update pending certificates, and remove revoked certificates
- Update certificates that use certificate templates

  <img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/18.GPO_Enabled.jpg" width="600">

The GPO enables auto-enrollment; it does **not** select a specific certificate template. Eligible published templates are determined by template settings and permissions.

### 7. Verify the issued device certificate

On ADPC1, refresh policy if necessary (`gpupdate /force`) and open `certlm.msc` → **Personal > Certificates**. Confirm the issued computer certificate.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/13.Cert_appears.jpg" width="600">

**Result:** ADPC1 obtains a device certificate directly through AD CS auto-enrollment, without Intune.

## Part 3 — Intune Certificate Connector and PKCS template

### 8. Create an Intune-specific template

On SRV1, duplicate `LabComputerCert` in `certtmpl.msc`:

- **General:** `LabComputerCert-Intune`
- **Subject Name:** **Supply in the request**
- **Cryptography:** Key Storage Provider, RSA
- **Security:** `svc_intunecert` (an AD account created for this test) - **Read, Enroll**

Publish `LabComputerCert-Intune` in `certsrv.msc` under **Certificate Templates > New > Certificate Template to Issue**.

This separate template allows Intune to supply the subject from the PKCS profile, without changing the template used for AD auto-enrollment.

### 9. Install the Certificate Connector

On SRV3, grant svc_intunecert **Log on as a service** through `secpol.msc` → **Local Policies > User Rights Assignment**. The right to log on as a service is distinct from the template's Read/Enroll permissions.

In Intune, navigate to **Tenant administration > Connectors and tokens > Certificate connectors > Add**, download and run `IntuneCertificateConnector.exe`.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/14.connector_download.jpg" width="600">

Select the PKCS connector feature and configure the domain service account. SCEP is not required for this lab. Confirm the connector is registered in Intune.

**Connectivity:** SRV3 needs connectivity to the on-premises CA **and** required Microsoft Intune cloud endpoints.

## Part 4 — Windows Intune PKCS deployment

### 10. Export and deploy the trusted root CA certificate

On SRV1: `certsrv.msc` → right-click CA → **Properties > View Certificate > Details > Copy to File**. Export as **Base-64 encoded X.509 (.CER)** (public certificate only).

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/25.Cert_Copy_CA.jpg" width="600">

In Intune: **Devices > Configuration > Create > New policy**:

- Platform: **Windows 10 and later**
- Template: **Trusted certificate**
- Upload the exported `.cer`
- Assign to the Windows test device group

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/17.Cert_config_intune.jpg" width="600">

### 11. Create Windows PKCS profile

In Intune, create a **Windows 10 and later > Templates > PKCS certificate** profile:

- CA: `CORP-ROOT-CA`
- Template: `LabComputerCert-Intune`
- Certificate type: **Device**
- Subject name: `CN={{DeviceName}}`
- KSP: **Enroll to TPM KSP if present, otherwise Software KSP**

Assign to AADPC1's test group.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/26.failed_PKCS_config.jpg" width="600">

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

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-Intune%20VPN%20Profiles%20%26%20Certificate%20Deployment/08.pkcs_shown_sSwan.jpg" width="400">

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

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/18-Hybrid%20PKI%20simulation/20.pkcs_error.jpg" width="600">

The issue was resolved by granting `svc_intunecert` **Read** and **Enroll** on `LabComputerCert-Intune`.

### 2. Android PKCS error despite successful root CA deployment

The Android trusted certificate deployed, but the PKCS profile initially reported an error. The connector server had no internet connection. After restoring connectivity, the PKCS certificate appeared in strongSwan and the Intune profile error subsequently cleared.

**Lesson:** Deploying a root CA certificate and issuing a PKCS identity certificate are separate processes. Check connector cloud connectivity, CA issued certificates, connector events, and Intune reporting.

### 3. Android PKCS certificate not visible in Trusted credentials

Android displayed the CA trust certificate but not the PKCS client identity certificate in its normal trust list. strongSwan could still select the client certificate.

**Lesson:** A trusted root CA certificate is different from a client identity certificate. Microsoft's PKCS documentation notes that Android Enterprise PKCS certificates aren't visible in the normal device certificate interface; check Intune deployment status.

## Microsoft documentation

- [Use PKCS certificate profiles with Microsoft Intune — Microsoft Learn](https://learn.microsoft.com/en-us/intune/device-configuration/certificates/pkcs-profiles) — includes the note about Android Enterprise PKCS certificate visibility.

