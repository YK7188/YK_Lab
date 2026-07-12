> Labbed July 2026


# Objective

Deploy Microsoft Entra Connect Sync to establish hybrid identity between on-premises Active Directory and Microsoft Entra ID, and verify successful directory synchronization.

# Environment

SRV1
- Active Directory Domain Services
- DNS

SRV3
- Microsoft Entra Connect Sync

Microsoft Entra ID
- Developer Tenant

Microsoft Entra Connect Sync
- Installation file is downloaded from Entra ID
  
  Path: Microsoft Entra Connect > Connect Sync

# Design Considerations

### User Principal Name (UPN)

The Microsoft Entra tenant only contained the default domain and it does not match the on-premises Active Directory domain.

Therefore, the synchronization wizard displayed:

Continue without matching all UPN suffixes to verified domains

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/29-Hybrid-Setup/12.NoMatchingUPN.jpg" width="650">

For this lab:

- The warning was acknowledged.
- Synchronized users received a Microsoft Entra sign-in name using the tenant's primary domain.
- Microsoft 365 authentication was performed using the generated Microsoft Entra sign-in name instead of the on-premises UPN.

> Available and verified domains can be reviewed in **Microsoft Entra ID → Domain names**.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/29-Hybrid-Setup/05.DomainNames.jpg" width="650">

### Source Anchor

Since the environment contains a single Active Directory forest, **Users are represented only once across all directories** was selected. This allows Microsoft Entra Connect to uniquely identify each synchronized object without cross-forest matching.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/29-Hybrid-Setup/08.Wizard_SourceAnchor.jpg" width="650">

### Deployment

| Setting | Selection |
|---------|-----------|
| Authentication | Password Hash Synchronization |
| Seamless SSO | Disabled |
| OU Filtering | Hybrid OU only |
| Source Anchor | Users represented only once across all directories |
| Staging Mode | Disabled |

# Verification

After the initial synchronization completes, open miisclient and confirm that tasks appear as success.

 <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/29-Hybrid-Setup/11.Import_Success.jpg" width="650">

> Manual synchronization:
>
> - Delta Import (On-premises connector)
> - Delta Synchronization (On-premises connector)
> - Export (Microsoft Entra connector)

<br>

- Synced users appeared in Entra ID successfully.
  
 <img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/29-Hybrid-Setup/13.ApperOnEntra.jpg" width="650">

- Confirmed that synchronized users could successfully authenticate to Microsoft 365 using the generated Microsoft Entra sign-in name.




