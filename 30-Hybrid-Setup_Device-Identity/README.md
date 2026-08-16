> Labbed: August 2026

# Objective

Following [Lab29-Hybrid-Setup_User-Identity](https://github.com/YK7188/YK_Lab/tree/main/29-Hybrid-Setup_User-Identity), configure Hybrid Microsoft Entra ID Join for domain-joined Windows devices and verify successful device registration.

---

# Configure Hybrid Microsoft Entra ID Join

Open Microsoft Entra Connect Sync and select:

**Configure device options > Configure Hybrid Microsoft Entra ID join**

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/30-Hybrid-Setup_Device/01.jpg" width="600">

Select the Active Directory forest and configure the Service Connection Point (SCP).

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/30-Hybrid-Setup_Device/03.jpg" width="600">

The SCP provides domain-joined Windows devices with the Microsoft Entra tenant information required to perform Hybrid Join.

---

# Synchronization Scope

The test computer object was placed in an OU included in the Microsoft Entra Connect synchronization scope (configured in Lab29).

After synchronization, the computer object appeared in Microsoft Entra ID and the Windows device completed Hybrid Join.

---

# Side Note - Verify the SCP

The SCP created by Microsoft Entra Connect can be verified from the **Configuration** naming context in ADSI Edit.

On the domain controller, open `adsiedit.msc` and select:

**Action > Connect to > Select a well known Naming Context > Configuration**

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/30-Hybrid-Setup_Device/05.jpg" width="600">

Navigate to:

`CN=Services > CN=Device Registration Configuration > CN=62a0ff2e-97b9-4513-943f-0d221bd30080`

The `keywords` attribute in Properties contains the configured Microsoft Entra tenant information.

<br>

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/30-Hybrid-Setup_Device/07.jpg" width="400">

---

# Hybrid join Verification

The computer object appeared in Microsoft Entra ID with the join type **Microsoft Entra hybrid joined**.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/30-Hybrid-Setup_Device/09.jpg" width="600">

On the client, `dsregcmd /status` confirmed both the on-premises domain join and Microsoft Entra join.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/30-Hybrid-Setup_Device/08.jpg" width="600">



