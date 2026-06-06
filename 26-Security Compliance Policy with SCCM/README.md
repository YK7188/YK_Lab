> Tested: June 2026

# Lab Scenario

The company requires:

- Windows Firewall enabled
- Password required
- Device evaluated for compliance

SCCM should determine whether devices are compliant.

# Step 1 - Create Configuration Item

Open SCCM Console and go to

Assets and Compliance > Compliance Settings > Configuration Items > Create Configuration Item

and complete the wizard.

- For Select the device setting groups to configure, select
  - System Security
  - Password
  - Encryption

Set settings as below.

- Password settings
  - Minimum password length > 11
  - Remediate noncompliant settings > Checked

   image

- Encryption settings
  - File encryption on device > On
  - Remediate noncompliant settings > Checked

- System security settings 
  - Network firewall > Required
  - Remediate noncompliant settings > Unchecked
 
# Step 2 - Create a Configuration Baseline

Go to

Assets and Compliance > Compliance Settings > Configuration Baselines > Create Configuration Baseline

Add the configuration item and complete the wizard.

And then deploy the configuration baseline.

image

On a test device, go to

Configuration properties > Configurations

and the configuration baseline appears.

image



Machine Policy Retrieval & Evaluation Cycle
