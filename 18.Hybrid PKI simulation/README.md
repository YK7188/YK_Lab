Tested: May 2026

# Lab Goal

To build a bybrid PKI structure like below using my developer's Entra ID tenant and Hyper-v on premises tenant.

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
- Intune Certificate Connector

ADPC1 (Windows Client 1)
- Windows 10
- AD joined

AADPC1 (Windows Client 2)
- Windows 11
- Entra joined / Intune enrolled
```

# STEP 1 — Confirm AD CS Role Installed

Confirm installed:

`Active Directory Certificate Services > Certification Authority`

image 01

# STEP 2 — Configure the CA

Click:

`Configure Active Directory Certificate Services`

image 02

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

CORP-ROOT-CA is up and running

image 03

# STEP 4 — Verify Root Trust on Domain PC

On a test AD device, open certmgr.msc:

`CORP-ROOT-CA appears under Trusted Root Certification Authorities > Certificates`

image04

> Active Directory automatically distributed CA trust to all AD joined devices.

# STEP 5 — Publish a certificate template

In Certificates Templates Console (certtmpl.msc):

Right click Computer > Duplicate Template

- Compatibility tab
  - Compatibility settings > Choose the latest versions for this lab. *But more considertion may be required in production environments.

- General tab
  - Template display name > LabComputerCert

- Security tab
  - Ensure Domain computers has Read and Enroll permissions

In certsrv:

`Certificate Templates > New > Certificate Template to issue`

Select LabComputerCert and Click OK

image

> Clients may now request that cert type
> 
> Enterprises commonly duplicate templates rather than modifying/using defaults directly

# STEP 6 — Test manual certificate enrollment

Move to a domain-joined PC, and open certlm.msc as an admin

Personal > All Tasks > Request New Certificate

Request LabComputerCert instead of the default Computer certificate

Certificate now appears in Personal folder

image



