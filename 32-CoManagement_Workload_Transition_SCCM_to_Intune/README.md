> Labbed: Aug 2026

# Scenario

The organization currently manages Windows devices with Configuration Manager. It plans to gradually migrate selected management workloads to Intune, starting with a pilot co-managed device before expanding the rollout.

This lab simulates the scenario using the synchronized Hybrid Microsoft Entra joined device (HBPC1) prepared in:
- [30-Hybrid-Setup_Device-Identity](https://github.com/YK7188/YK_Lab/tree/main/30-Hybrid-Setup_Device-Identity)
- [31-IntuneEnrollment_HybridDevices](https://github.com/YK7188/YK_Lab/tree/main/31-IntuneEnrollment_HybridDevices)

---

# Part 1 - Windows Update Workload

### 1. Existing Configuration Manager management

HBPC1 is currently managed by Configuration Manager for Windows updates. As shown in the image, the device is compliant with a deployed cumulative update.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/01.jpg" width="600">

### 2. Prepare the Intune policy

Create an Update Ring for HBPC1 in Intune.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/02.jpg" width="600">

### 3. Move Windows Update policies to Pilot Intune

On the SCCM server, open the ConfigMgr console and go to:

**Administration > Cloud Services > Cloud Attach > CoMgmtSettingsProd > Properties > Workloads**

Change **Windows Update policies** from **Configuration Manager** to **Pilot Intune**.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/03.jpg" width="400">

Go to the **Staging** tab and, for **Windows Update policies**, select the collection containing HBPC1.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/04.jpg" width="400">

### 4. Stop ConfigMgr Software Updates for HBPC1

In the ConfigMgr console, go to:

**Administration > Client Settings > Create Custom Client Device Settings**

Select **Software Updates** and set:

**Enable software updates on clients = No**

> The Default Client Settings have Enable software updates on clients set to Yes, so the custom Client Settings override this setting for the pilot device.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/06.jpg" width="600">

Deploy the custom Client Settings to the target device collection.

### 5. Verification

On HBPC1, open **Configuration Manager Properties**.

Under **Actions**, the following actions are no longer available:

- Software Updates Scan Cycle
- Software Updates Deployment Evaluation Cycle

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/08.jpg" width="400">

In the Intune admin center, the Update Ring also shows the device check-in status as **Succeeded**.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/07.jpg" width="600">

> **Note:** A successful policy status in Intune confirms that the policy was processed successfully, but reporting should not be treated as the sole verification of the endpoint's effective configuration. In a production migration, verify the resulting settings on pilot devices before expanding the rollout.

---

# Part 2 - Endpoint Protection

### 1. Existing Configuration Manager management

HBPC1 is currently managed by Configuration Manager for Endpoint Protection. As shown in the image, the device's **Endpoint Protection Deployment State** appears as **Managed**.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/09.jpg" width="600">

### 2. Prepare the Intune policy

Create a Microsoft Defender Antivirus policy for HBPC1 in Intune.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/11.jpg" width="600">

### 3. Move Endpoint Protection to Pilot Intune

In the ConfigMgr console, change the **Endpoint protection** workload from **Configuration Manager** to **Pilot Intune**.

Go to the **Staging** tab and, for **Endpoint protection**, select the collection containing HBPC1.

### 4. Stop ConfigMgr Endpoint Protection for HBPC1

In the ConfigMgr console, use Client Settings to set:

**Manage Endpoint Protection client on client computers = No**

for HBPC1.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/10.jpg" width="600">

### 5. Verification

In the Intune admin center, the Defender Antivirus policy shows the device check-in status as **Succeeded**.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/12.jpg" width="600">

After the workload transition, the device's **Endpoint Protection Deployment State** changes to **Managed by Microsoft Intune**.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/32-CoManagement_Workload_Transition_SCCM_to_Intune/16.jpg" width="600">

---

# Result

HBPC1 was used as a pilot device to transition two co-management workloads from Configuration Manager to Intune:

| Workload | Before | After |
|---|---|---|
| Windows Update policies | Configuration Manager | Pilot Intune |
| Endpoint protection | Configuration Manager | Pilot Intune |

The migration demonstrates how individual co-management workloads can be moved gradually to Intune while other workloads remain under Configuration Manager control.


