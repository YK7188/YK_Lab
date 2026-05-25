> Tested: May 2026

# Lab Goal

IT wants to have their onboarding Windows devices obtain PKCS certificate automatically.

So I configure a bybrid PKI structure like below using my developer's Entra ID tenant and Hyper-v on premises tenant.

```
On-prem AD CS (CA)
↓
Intune Certificate Connector
↓
Intune PKCS Certificate Profile
↓
Windows device receives certificate automatically
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
- On-premises AD joined

AADPC1 (Windows Client 2)
- Windows 11
- Entra ID joined / Intune enrolled
```

# STEP 1 — Confirm AD CS Role Installed

Confirm installed:

`Active Directory Certificate Services > Certification Authority`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/01.role_installation.jpg" width="600">

# STEP 2 — Configure the CA

Click:

`Configure Active Directory Certificate Services`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/02.post_deployment_confg.jpg" width="400">


and proceed with the wizard

- Credentials > Domain admin account
- Role Services > Certification Authority
- Setup Type > Enterprise CA
- CA Type > Root CA
- Private Key > Create a new private key
- Cryptography (Leave it as dafault)
  - RSA#Microsoft Software Key Storage Provider
  - 2048
  - SHA256
- CA Name > CORP-ROOT-CA
- Validity Period > 5 years
- Database Locations > Leave it as default

# STEP 3 — Open Certification Authority Console

CORP-ROOT-CA is now up and running

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/03.CA_up.jpg" width="400">

# STEP 4 — Verify Root Trust on Domain PC

On a test AD device, open certmgr.msc:

`CORP-ROOT-CA appears under Trusted Root Certification Authorities > Certificates`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/18-Hybrid%20PKI%20simulation/04.Root_Cert_shown.jpg" width="500">

> Active Directory automatically distributed CA trust to all AD joined devices.

# STEP 5 — Publish a certificate template

In Certificates Templates Console (certtmpl.msc):

Right click Computer > Duplicate Template

- Compatibility tab
  - Compatibility settings > Choose the latest versions for this lab. *But more considertion may be required in production environments.

- General tab
  - Template display name > LabComputerCert

- Security tab
  - Ensure Domain computers has Read, Enroll, Autoenroll permissions

In certsrv:

`Certificate Templates > New > Certificate Template to issue`

Select LabComputerCert and Click OK

image

> Clients may now request that cert type

> Enterprises commonly duplicate templates rather than modifying/using defaults directly

# STEP 6 — Test manual certificate enrollment

Run gpmc.msc and create a new GPO object:

Certificate Services Client - Auto-Enrollment

> For better management, easier troubleshooting, better create a new object than adding to the default domain policy object.

Path: `Computer Configuration > Policies > Windows Settings > Security Settings > Public Key Policies `

Enable the policy and Check:

- Renew expired certificates, update pending certificates, and remove revoked certificates
- Update certificates that use certificate templates

Certificate now appears in Personal folder

image


# Step 7 — Install Intune Certificate Connector

Microsoft's recommendation is:
- Windows Server 2012 R2 or later.
- Intune connector server better not be colocated with the CA.

On SRV3, go to Intune and download the .exe file.

Path: Tenant admin > Connectors and tokens > Certificate Connectors > Add

image14

Run downloaded IntuneCertificateConnector.exe and proceed with the wizard.

- Service Account > Domain Account
  - Created a new domain account for best practice. No particular previlige required.
  - Open secpol.msc and add the account to `Local policies > User Rights assignment > Log on as a service`
- Features > SECP unticked, all the others ticked
- Service account type > Domain Account

The connector now appears in Intune.

image15

# Step 8 — Deploy Trusted Root Certificate profile

> Intune needs to trust the on-prem CA

## Export Root CA certificate

On SRV1 (CA server):

Run:

certsrv.msc

Right-click CA:

Path: `Properties > View Certificate > Details > Copy to File`

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

RootCA.cer

Assign to test device group.

The root certificate appears on a Entra ID joined PC.

image

## STEP 9 — Create PKCS certificate profile

In Microsoft Intune:

Path:

Devices > Configuration > Create > New policy

Platform: 

Windows 10 and later

Profile type: 

Templates > PKCS certificate

Configuration Settings:

Key storage provider (KSP) > Enroll to Trusted Platform Module (TPM) KSP if present, otherwise Software KSP
> TPM keeps the key hardware-protected.

Subject name format > CN={{devicename}}
> It will show the device name.

Result:

Error appears in Intune

# STEP 9 — Publish a new certificate template for Entra ID devices

On SRV1 (CA Server), in Certificates Templates Console (certtmpl.msc):

Right click LabComputerCert > Duplicate Template

- General tab
  - Template display name > LabComputerCert-Intune

- Subject Name tab
  - Select Supply in the request

- Cryptography tab
  - Select Key Storage Provider, RSA for Provider Category

> Settings need to be changed for Intune

In certsrv:

`Certificate Templates > New > Certificate Template to issue`

Select LabComputerCert and Click OK

Results:

Error appears in the report.

## Troubleshoot

Check Event Viewer on Connector server (SRV3)
Path: Applications and Services Logs > Microsoft > Intune > CertificateConnectors

Error appears:
- PKCSRequestFailure
- User > Connector account (svc_intunecert)
- Denied by Policy Module

Fix:

- run certtmpl.msc on CA server
- Open LabComputerCert-Intune > Properties > Security 

Add svc_intunecert with Read, Enroll permissions

Result:

On test Entra ID device, run certlm.msc

PKCS cert appears


