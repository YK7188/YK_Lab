> Tested: June 2026

# Lab Goal

Deploy an application from SCCM and install it through Software Center.

# Step 1 — Download Installer

On the SCCM server, create and share a source folder for the 7-zip msi file.

# Step 2 — Create Application

Go: Software Library > Applications >Create Application

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/24-App%20deployment%20by%20SCCM/01.Create_app.jpg" width="500">

- Select: Automatically detect information about this application from installation files
- Type: Windows Installer (*.msi)
- Browse to: The shared msi file

# step 3 — Enter App Detail

Enter:

- Name: 7-Zip 26.01 (x64)
- Publisher: Igor Pavlov
- Software version: 26.01
- Installation program: msiexec /i "7z2601-x64.msi" /qn

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/24-App%20deployment%20by%20SCCM/03.specify_info.jpg" width="500">

# Step 4 — Distribute Content

Go: Software Library > Applications > 7-Zip > Distribute Content

and the wizard starts.

Ensure: The site server is in the Content destination list.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/24-App%20deployment%20by%20SCCM/04.distribution_point.jpg" width="500">

and finish the wizard.

Go: Monitoring > Distribution Status > Content Status > 7-Zip 26.01 (x64)

It appears as success within a few minutes.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/24-App%20deployment%20by%20SCCM/05.content_status.jpg" width="600">

# Step 5 — Create a Test Device Collection

Go: Assets and Compliance > Device Collections > Create Device Collection

and create a device collection for 7-zip deployment.

# Step 6 — Deploy Application

Go: Software Library > Applications > 7-Zip > Deploy

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/24-App%20deployment%20by%20SCCM/06.deploy.jpg" width="500">

and the wizard starts.

# Step 7 — Verify on Client

7-zip appears as an available application in Software Center.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/24-App%20deployment%20by%20SCCM/06.SWCentre.jpg" width="400">

If it takes long to appear, on a target device,

Go: Control Panel > Configuration Manager > Actions > Run Machine Policy Retrieval & Evaluation Cycle

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/24-App%20deployment%20by%20SCCM/07.machine_PRetrieval.jpg" width="300">

To see the deployment status,

Go: Monitoring > Deployments > 7-zip > Summary

- Once the app is installed by the user, it counts as success in completion Statistics.
- Once the app is deployed to a distribution point, it counts as success in Content Status.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/24-App%20deployment%20by%20SCCM/08.Install_success.jpg" width="700">


