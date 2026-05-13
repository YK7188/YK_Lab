Tested: May 2026

# Lab Goal

To build a bybrid PKI structure like below using my developer's AAD tenant and Hyper-v on premises tenant.

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
- Active Directory
- Enterprise Root CA

[Connector Server or SRV1]
- Intune Certificate Connector

ADPC1 (Windows Client 1)
- AD joined

AADPC1 (Windows Client 2)
- Entra joined / Intune enrolled
```
