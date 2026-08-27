> Labbed: August 2026

# Scenario

Following:
- [Lab29-Hybrid-Setup_User-Identity](https://github.com/YK7188/YK_Lab/tree/main/29-Hybrid-Setup_User-Identity)
- [Lab30-Hybrid-Setup_Device-Identity](https://github.com/YK7188/YK_Lab/tree/main/30-Hybrid-Setup_Device-Identity)

Use Tenant Attach to expose a domain-joined, ConfigMgr-managed Windows machine, TAPC1, in the Intune admin center and test cloud-based device management capabilities.

---

# Step 1 - Enable Cloud Attach

Go to **Administration > Cloud Services > Cloud Attach**.

Enable the following option:

**Upload to Microsoft Intune admin center**

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/33-ConfigMgr_CloudAttach/01.jpg" width="400">

After synchronization completed, TAPC1 appeared in the Intune admin center.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/33-ConfigMgr_CloudAttach/02.jpg" width="700">

> An important observation was that TAPC1 did not need to be Intune-enrolled for this functionality. The device remained managed by ConfigMgr while selected management capabilities became available through the Intune admin center.

---

# Step 2 - Configure Administrative Access

When initially accessing ConfigMgr-backed information from Intune, features such as Resource Explorer, Client details, Collections, and CMPivot returned authorization errors.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/33-ConfigMgr_CloudAttach/03.jpg" width="600">

To resolve the errors, the following items were checked and updated:
- The account was granted:
  - Necessary Intune permissions (the **Help Desk Operator** role was used in this lab).
  - Necessary Configuration Manager permissions (the **Full Administrator** security role was used in this lab).
    - See the [Tenant Attach documentation](https://learn.microsoft.com/en-us/intune/configmgr/tenant-attach/) for details on the required permissions.
  - **Active Directory User Discovery** was configured in ConfigMgr.
    - Path: **Administration > Overview > Hierarchy Configuration > Discovery Methods**
  - **Microsoft Entra ID User Discovery** was configured through Azure Services.
    - Path: **Administration > Cloud Services > Azure Services**

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/33-ConfigMgr_CloudAttach/12.jpg" width="700">

After discovery, the ConfigMgr user record was associated with its Microsoft Entra tenant ID and user ID.

---

# Step 3 - Test Device Management Functions

The following Tenant Attach capabilities were tested from the Intune admin center.

### CMPivot

CMPivot was tested from both Configuration Manager and the Intune admin center.

The example query **OperatingSystem** returned information from TAPC1 in both consoles.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/33-ConfigMgr_CloudAttach/06.jpg" width="700">
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/33-ConfigMgr_CloudAttach/07.jpg" width="700">


### Applications

7-Zip was deployed from ConfigMgr as an available application to TAPC1 and appeared in Software Center.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/33-ConfigMgr_CloudAttach/08.jpg" width="600">

The same ConfigMgr application was exposed through the Intune admin center, where the installation was initiated remotely.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/33-ConfigMgr_CloudAttach/09.jpg" width="700">


### Scripts

A PowerShell script was created and approved in ConfigMgr and then executed against TAPC1 from the Intune admin center.

The script execution and output were visible from both **ConfigMgr > Monitoring > Script Status** and **Intune > TAPC1 > Scripts**.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/33-ConfigMgr_CloudAttach/13.jpg" width="700">

This demonstrated that ConfigMgr Run Scripts can be initiated and monitored through the Intune admin center.

---

# Conclusion

Cloud Attach allowed TAPC1 to remain ConfigMgr-managed while exposing selected ConfigMgr management capabilities through the Intune admin center.

The lab demonstrated CMPivot, application actions, and PowerShell script execution without moving the device management workload to Intune.

