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

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/01.role_installation.jpg" width="600">

# STEP 2 - Configure the CA

Click:

`Configure Active Directory Certificate Services`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/02.post_deployment_confg.jpg" width="400">


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

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/03.CA_up.jpg" width="400">

# STEP 4 - Verify Root Trust on Domain PC

On the AD-joined test device, open certmgr.msc:

`CORP-ROOT-CA appears under Trusted Root Certification Authorities > Certificates`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/04.Root_Cert_shown.jpg" width="500">

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

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/05.cert_template.jpg" width="500">

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

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/18.GPO_Enabled.jpg" width="600">

On the AD-joined test device, Certificate now appears in Personal folder

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/13.Cert_appears.jpg" width="600">

> For better management, easier troubleshooting, creating a new object is better than adding to the default domain policy object.

# Step 7 - Install Intune Certificate Connector

Microsoft's recommendation is:
- Windows Server 2012 R2 or later.
- Intune connector server better not be colocated with the CA.

On connector server, go to Intune and download the .exe file.

Path: Tenant admin > Connectors and tokens > Certificate Connectors > Add

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/14.connector_download.jpg" width="600">

Run downloaded IntuneCertificateConnector.exe and proceed with the wizard.

- Service Account > Domain Account
  - Created a new domain account for best practice. No administrative privileges were required for this lab's purpose.
  - Open secpol.msc and add the account to `Local policies > User Rights assignment > Log on as a service`
- Features > SCEP unticked (not required for this lab), all the others ticked
- Service account type > Domain Account

The connector now appears in Intune.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/15.connector_appear.jpg" width="600">

# Step 8 - Deploy Trusted Root Certificate profile

> Intune managed devices need to trust the on-prem CA

## Export Root CA certificate

On CA server, run certsrv.msc and right-click CA

Path: `Properties > View Certificate > Details > Copy to File`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/25.Cert_Copy_CA.jpg" width="700">

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

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/17.Cert_config_intune.jpg" width="600">

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

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/26.failed_PKCS_config.jpg" width="600">

Result:

Error appeared in Intune

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/20.pkcs_error.jpg" width="600">


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

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/22.Denied_By_Module.jpg" width="600">

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

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/28-Intune%20VPN%20Profiles%20%26%20Certificate%20Deployment/08.pkcs_shown_sSwan.jpg" width="300">

## Extending PKCS Deployment to iPhone

##### Step 1 - Trusted Certificate Profile

In Intune, create a new configuration profile for the CA certificate.

Path: Devices > Apple mobile > Configuration > Create > New Policy > iOS/iPadOS > Templates > Trusted Certificate

##### Step 2 - PKCS Certificate Profile 

In Intune, create a new configuration profile for the PKCS certificate.

Path: Devices > Apple mobile > Configuration > Create > New Policy > iOS/iPadOS > Templates > PKCS Certificate

##### Step 3 - Verification

The certificates appear on the iPhone. The management profile shows both the Trusted Certificate profile and PKCS Certificate profile as successfully applied. Intune reporting also shows successful deployment.
