> Labbed: September 2026

# Scenario

This lab simulates access control for USB storage devices and Android devices connected to a Windows PC using Intune.

---

# External USB Drives

## Defining USB

Go to:

**Endpoint security > Attack surface reduction > Reusable settings**

Configure reusable settings for the following devices:

- **All USB storage devices**
  - **PrimaryID:** `RemovableMediaDevices`

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/34-USBAccessControl_withIntune/04.jpg" width="600">

- **Exception USB storage devices**
  - Use **SerialNumberID**, **VID_PID**, or **InstancePathId** for each exception device.

> In this test, different identifier types were required to successfully exclude different devices.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/34-USBAccessControl_withIntune/03.jpg" width="600">

## Configuring device control policy

Go to 

**Endpoint security > Attack surface reduction > Policies > Create Policy > Windows > Device Control**

Select **Device Control** for **Configuration settings**.

Configure the policy as follows:

- **Included Devices:** All USB storage devices
- **Excluded Devices:** Exception USB storage devices
- **Instance 1**
  - **Type:** Audit Denied
  - **Options:** Show notification
  - **Access mask:** Read, Write, Execute
- **Instance 2**
  - **Type:** Deny
  - **Options:** None
  - **Access mask:** Read, Write, Execute
    
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/34-USBAccessControl_withIntune/06.jpg" width="800">

## Result

- The policy blocked all USB storage devices (as shown below) while allowing the specifically excluded ones.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/34-USBAccessControl_withIntune/02.jpg" width="300">
  
---

# Android devices

## WPD policy (Legacy method)

Go to:

**Endpoint security > Attack surface reduction > Policies > Create Policy > Windows > Device Control**

Select **Removable Storage Access** for **Configuration settings**.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/34-USBAccessControl_withIntune/08.jpg" width="600">

> WPD (Windows Portable Devices) is a Windows device class that includes devices using certain protocols. Android phones connected in file-transfer mode are commonly exposed to Windows as WPD devices. As such, policies created by this method may affect other portable devices, such as cameras and media devices.

> This method provides broad WPD read/write restrictions and does not provide the granular per-device exception model used in the following Device Control policy.

## Device control policy

### Defining devices

Go to:

**Endpoint security > Attack surface reduction > Reusable settings**

Configure reusable settings for the following devices:

- **All WPD devices**
  - **PrimaryID:** `WpdDevices`

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/34-USBAccessControl_withIntune/09.jpg" width="600">

- **Exception WPD device** (an Android device was used in this test.)
  - **Identifier:** `InstancePathId`
    
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/34-USBAccessControl_withIntune/10.jpg" width="600">

### Configuring block policy

Go to:

**Endpoint security > Attack surface reduction > Policies > Create Policy > Windows > Device Control**

Select **Device Control** for **Configuration settings**.

Configure the policy as follows:

- **Included Devices:** All WPD devices
- **Excluded Devices:** Test Android device
- **Instance 1**
  - **Type:** Deny
  - **Options:** None
  - **Access mask:** Read, Write, Execute
- **Instance 2**
  - **Type:** Audit Denied
  - **Options:** Show notification
  - **Access mask:** Read, Write, Execute

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/34-USBAccessControl_withIntune/12.jpg" width="800">

## Result

- The policy blocked access to the test Android device's storage.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/34-USBAccessControl_withIntune/13.jpg" width="300">

- After the Android device was added to the exclusion, access was restored while other WPD devices remained subject to the block policy.

