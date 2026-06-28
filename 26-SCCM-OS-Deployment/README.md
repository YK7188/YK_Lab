> Tested: June 2026

# Lab objective

Achieve OS installation by PXE servered by SCCM.

# Step 1 - Add Windows Installation Media

Download Windows 11 ISO.

In SCCM go to:

Software Library > Operating Systems > Operating System Image > Add Operating System Image

Complete the wizard to add the OS image.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/01.addOS.jpg" width="600">

# Step 2 – Verify and Distribute the Boot Image

Go to:

Software Library > Operating Systems > Boot Images

Select a Boot image to distribute and complete the wizard.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/02.DistributeBoot.jpg" width="600">

# Step 3 – Distribute the Windows 11

Go to:

Software Library > Operating Systems > Operating System Images

Right-click the added Windows 11 image and select Distribute Content to complete the wizard.

# Step 4 – Configure PXE Support on the Distribution Point

Go to:

Administration > Site Configuration > Servers and Site System Roles

From the bottom pane, navigate:

Distribution Point Role > Properties > PXE tab

Configure the followings:
- check: Enable PXE support for clients
- check: Allow this distribution point to respond to incoming PXE requests
- uncheck: Enable unknown computer support
- check: Enable a PXE responder without Windows Deployment Service
- uncheck: Enable Preferred Management Point(s) for PXE requests
- check: Require a password when computers use PXE
- check: Respond to PXE requests on all network interfaces

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/03.DPRole_PXE.jpg" width="500">

# Step 5 – Create Task Sequence (Bare Metal Deploy)

Software Library > Operating Systems > Task Sequences > Create Task Sequence

Select "Install an existing image package" for a new task sequence to be created.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/04.Create_Task.jpg" width="500">

Additionally, to simplify the process, choose no updates and applications to be installed in the sequence.

# Step 6 – Import the test PC information

Assets and Compliance > Devices > Import Computer Information

At this point, the Hyper-V VMId was used:

Powershell on the Hyper-V host: Get-VM TestVM | Select-Object VMId

> This value was later found incorrect. VMId does not equal SMBIOS UUID.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/05.Import_VMInfo.jpg" width="500">

# Step 7 – Deploy the Task Sequence

Software Library > Operating Systems > Task Sequences

Select the newly created task sequence and deploy.

# Step 8 – Verification 1

Check the state of the VM:
- Network adapter set for the virtual internal switch
- Boot is set to "from Network adapter"

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/06.VM_State.jpg" width="600">

DHCP is up.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/07.DHCP_state.jpg" width="600">

Result:

"A boot image was not found" error appeared.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/08.Error_PXE.jpg" width="600">

# Troubleshoot

The error indicates that PXE boot succeeds and SCCM responds, but no boot image is provided.

Checked the follwoing that are closely related to boot image deployment.

- Boot image is successfully distributed accrording to the content status.
  
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/09.Boot_ditributed.jpg" width="600">

- Boot image is set to be PXE available in the wizard as below.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/10.PXE_Enabled.jpg" width="500">

- Deployed Task sequence is PXE available in the wizard as below.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/12.Deploy_PXEAvailable.jpg" width="500">

#### - SMSPXE.log shows a different GUID.

SMSPXE.log shows that neither SMBIOS UUID nor MAC address matched an existing device record.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/13.SMSPXE_Log.jpg" width="600">

> Hyper-V VMId is not same as SMBios GUID.
> At the time of configuration, Hyper-V VMId was the only available GUID exposed in my lab environment and at this point it is invalidated. 

Fix:

The issue was resolved after re-importing the computer using the correct identity observed during PXE boot (SMBIOS UUID or MAC address from SMSPXE.log).

Result:

PXE boot began.

# Verification 2

- Password required in the task sequence as configured.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/14.Password_required.jpg" width="400">

- Task sequence appears as an avalable option.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/15.Task_Available.jpg" width="400">

- Progress bar appears.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/16.ProgressBar.jpg" width="400">

- PC is domain joined.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/17.DomainJoined.jpg" width="300">

- The following command confirms the SMBIOS UUID of the operating system:

Within the test device: (Get-CimInstance Win32_ComputerSystemProduct).UUID

This value matches the SMBIOS UUID used by PXE for device identification.
