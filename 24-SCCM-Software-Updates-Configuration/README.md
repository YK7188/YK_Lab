> Tested: June 2026

# Lab Objective

deploy windows update 

# Step 1 - Deploy the Update

Go to Software Updates > All Software Updates.

Find an update that shows Required = 1 for at least one device.

Select Deploy and complete the deployment wizard.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/25-Deploy%20Software%20updates%20by%20SCCM/15.deploy_required.jpg" width="600">

# Step 2 - Verify Deployment

On the test device, open Software Center.

The deployed update should appear as available.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/25-Deploy%20Software%20updates%20by%20SCCM/16.update_appears.jpg" width="600">

### If the Update Does Not Appear

Open Configuration Manager Properties and run the following actions:

- Machine Policy Retrieval & Evaluation Cycle
- Software Updates Deployment Evaluation Cycle
- Software Updates Scan Cycle

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/25-Deploy%20Software%20updates%20by%20SCCM/14.run_actions.jpg" width="300">

Also, go to Monitoring > Deployments and review the deployment status.

In this example, the test device appears as In Progress because the update installation or compliance reporting process has not completed yet.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/25-Deploy%20Software%20updates%20by%20SCCM/17.deployment_status.jpg" width="600">

