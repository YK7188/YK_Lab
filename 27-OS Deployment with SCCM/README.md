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

# Step 4 – Confirm PXE Support on the Distribution Point

Go to:

Administration > Site Configuration > Servers and Site System Roles

From the bottom pane,

Distribution Point Role > Properties > PXE tab

