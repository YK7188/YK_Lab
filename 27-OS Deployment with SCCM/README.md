> Tested: June 2026

# Lab objective

Achieve OS installation by PXE servered by SCCM.

# Step 1 - Add Windows Installation Media

Download Windows 11 ISO.

In SCCM go to:

Software Library > Operating Systems > Operating System Image > Add Operating System Image

Complete the wizard to add the OS image.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/01.addOS.jpg" width="600">

# Step 2 – Verify and Distribute the Boot Image

Go to:

Software Library > Operating Systems > Boot Images

Select a Boot image to distribute and complete the wizard.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/02.DistributeBoot.jpg" width="600">

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

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/03.DPRole_PXE.jpg" width="600">

# Step 5 – Create Task Sequence (Bare Metal Deploy)

Software Library > Operating Systems > Task Sequences > Create Task Sequence

Select "Install an existing image package" for a new task sequence to be created.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/04.Create_Task.jpg" width="600">

Additionally, to simplify the process, choose no updates and applications to be installed in the sequence.

# Step 6 – Import the test PC information

Assets and Compliance > Devices > Import Computer Information

Use SMBios GUID obtained by the command below as identifier for this lab.

Powershell on the Hyper-V host: Get-VM TestVM | Select-Object VMId

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/05.Import_VMInfo.jpg" width="600">

# Step 7 – Deploy the Task Sequence

Software Library > Operating Systems > Task Sequences

Select the newly created task sequence and deploy.

# Step 8 – Verification 1

Check the state of the VM:
- Network adapter set for the virtual internal switch
- Boot is set to "from Network adapter"

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/06.VM_State.jpg" width="600">

DHCP is up.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/07.DHCP_state.jpg" width="600">

Result:

"A boot image was not found" error appeared.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/08.Error_PXE.jpg" width="600">

# Troubleshoot

The error message indicates that it works up to:

VM > DHCP works > PXE server responds > SCCM receives request but cannot provide a boot image

- Boot image is successfully distributed accrording to the content status.
  
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/09.Boot_ditributed.jpg" width="600">

- Boot image is set to be PXE available in the wizard as below.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/10.PXE_Enabled.jpg" width="600">

- Deployed Task sequence is PXE available in the wizard as below.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/12.Deploy_PXEAvailable.jpg" width="600">

#### - SMSPXE.log shows a different GUID.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/13.SMSPXE_Log.jpg" width="600">

Fix:

Import the computer information with the MAC using the command below instead.

Get-VMNetworkAdapter -VMName TestVM | Select-Object MacAddress

image

Result:

PXE boot began.

# Verification

- Password required.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/14.Password_required.jpg" width="600">

- Task sequence appears as an avalable option.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/15.Task_Available.jpg" width="600">

- Progress bar appears.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/16.ProgressBar.jpg" width="600">

- PC is domain joined.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/27-OS%20Deployment%20with%20SCCM/17.DomainJoined.jpg" width="400">

- The command below confirms that the machine's GUID matches what PXE recognized it as.
  
  (Get-CimInstance Win32_ComputerSystemProduct).UUID

  > Reason is unknown but running Get-VM TestVM | Select-Object VMId on a host can return a wrong GUID.
