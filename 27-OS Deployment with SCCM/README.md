> Tested: June 2026



# Step 1 - Add Windows Installation Media

Download Windows 11 ISO.

In SCCM go to:

Software Library > Operating Systems > Operating System Image > Add Operating System Image

Complete the wizard to add the OS image.

# Step 2 – Verify and Distribute the Boot Image

Go to:

Software Library > Operating Systems > Boot Images

Select a Boot image to distribute it and complete the wizard.

# Step 3 – Distribute the Windows 11 WIM

Go to:

Software Library > Operating Systems > Operating System Images

Right-click your Windows 11 image:

Distribute Content

Select your DP.

# Step 4 – Configure PXE Support on the Distribution Point

Go to:

Administration > Site Configuration > Servers and Site System Roles

From the bottom pane,

Distribution Point Role > Properties > PXE tab

Configure the followings:
- check: Enable PXE support for clients
- check: Allow this distribution point to respond to incoming PXE requests
- uncheck: Enable unknown computer support
- check: Enable a PXE responder without Windows Deployment Service
- uncheck: Enable Preferred Management Point(s) for PXE requests
- check: Require a password when computers use PXE
- check: Respond to PXE requests on all network interfaces

image

# Step 5 – Create Task Sequence (Bare Metal Deploy)

Software Library > Operating Systems > Task Sequences > Create Task Sequence

To simplify the process, I chose no updates, applications installed in the sequence.

# Step 6 – Import 

Assets and Compliance > Devices > Import Computer Information

Use SMBios GUID obtained by the command below as identifier for this lab.

Powershell on the Hyper-V host: Get-VM TestVM | Select-Object VMId

# Step 7 – Deploy the Task Sequence

Software Library > Operating Systems > Task Sequences

Select the newly created task sequence and deploy.

# Step 8 – Verification

Check the state of the VM:
- Network adapter set for the virtual internal switch
- Boot is set to from Network adapter

DHCP is up.

Result:

"A boot image was not found" error appeared.

# Troubleshoot

The error message indicates that it works up to:

VM > DHCP works > PXE server responds > SCCM receives request but cannot provide a boot image

- Boot image is successfully distributed as below.

- Boot image is set to be PXE available as below.

- Deployed Task sequence is PXE available as below.

- SMSPXE.log shows a different GUID.

Fix:

Import the computer information with the MAC instead.

Get-VMNetworkAdapter -VMName TestVM | Select-Object MacAddress

image

Result:

PXE boot began.

# Verification

- Password required.

- Task sequence appears as an avalable option.

- Progress bar appears.

- PC is domain joined.

- The command below confirms that the machine's GUID matches what PXE recognized it as.
  
  (Get-CimInstance Win32_ComputerSystemProduct).UUID

  > Reason is unknown. Running Get-VM TestVM | Select-Object VMId on a host can return a wrong GUID.
