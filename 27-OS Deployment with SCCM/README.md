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

Use SMBios GUID as identifier for this lab.

# Step 7 – Deploy the Task Sequence
