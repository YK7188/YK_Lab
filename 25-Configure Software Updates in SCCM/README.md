> Tested: June 2026

# lab objective

deploy windows update 

# step1 - deploy update

Go to Software Updates > All Software Updates

Find KB5031539 showing required = 1 

Select Deploy and complete the Wizard.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/25-Deploy%20Software%20updates%20by%20SCCM/15.deploy_required.jpg" width="600">

# Step2 - verification

Go to Software Center in a test device

KB5031539 appears as available.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/25-Deploy%20Software%20updates%20by%20SCCM/16.update_appears.jpg" width="600">

### In case it does not appear in Software center

Open Configuration Manager Properties and run actions:

- Machine Policy Retrieval & Evaluation Cycle
- Software Updates Deployment Evaluation Cycle
- Software Updates Scan Cycle

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/25-Deploy%20Software%20updates%20by%20SCCM/14.run_actions.jpg" width="300">

Go to Deployments to see Deployment Status

The test device just installed the update and it appears as In progress
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/25-Deploy%20Software%20updates%20by%20SCCM/17.deployment_status.jpg" width="600">

