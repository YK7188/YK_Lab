# Lab Goal

Deploy an application from SCCM and install it through Software Center.

# Step 1 — Download Installer

Create and share a source folder for the 7-zip msi file.

# Step 2 — Create Application

Go: Software Library > Applications >Create Application

              image

- Select: Automatically detect information about this application from installation files
- Type: Windows Installer (*.msi)
- Browse to: The msi file

# step 3 — Enter App Detail

Enter:

- Name: 7-Zip 26.01 (x64)
- Publisher: Igor Pavlov
- Software version: 26.01
- Installation program: msiexec /i "7z2601-x64.msi" /qn

      image

# Step 4 — Distribute Content

Go: Software Library > Applications > 7-Zip > Distribute Content

and the wizard starts.

Ensure: The site server is in the Content destination list.

and finish the wizard.

Go: Monitoring > Distribution Status > Content Status > 7-Zip 26.01 (x64)

It appears as success within a few minutes.

# Step 5 — Create a Test Device Collection

Go: Assets and Compliance > Device Collections > Create Device Collection

and create a device collection for 7-zip deployment.

# Step 6 — Deploy Application

Go: Software Library > Applications > 7-Zip > Deploy

and the wizard starts.

Ensure: Deployment settings are set to Install and Available for testing and observation purpose

# Step 7 — Verify on Client

7-zip appears as an available application in Software Center.

If it takes long to appear, on a target device,
Go: Control Panel > Configuration Manager > Actions > Run Machine Policy Retrieval & Evaluation Cycle

Go: Monitoring > Deployments > 7-zip > Summary
Once the app is installed by the user, it 

