> Tested: June 2026

# Lab Scenario 1

The company requires:

- Windows Firewall enabled
- Password minimum length set
- Device encrypted

SCCM should determine whether devices are compliant.

# Step 1 - Create Configuration Item

Open SCCM Console and go to

Assets and Compliance > Compliance Settings > Configuration Items > Create Configuration Item

and complete the wizard.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/01.create_configItem.jpg" width="600">

- For Select the device setting groups to configure, select
  - System Security
  - Password
  - Encryption

Set settings as below.

- Password settings
  - Minimum password length > 11
  - Remediate noncompliant settings > Checked

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/02.password_setting.jpg" width="500">

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

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/05.Create_CB.jpg" width="400">

And then deploy the configuration baseline.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/06.deploy_CB.jpg" width="500">

On a test device, go to

Configuration properties > Configurations

and the configuration baseline appears.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/07.CB_shown.jpg" width="300">

> Device compliance status in Software center is not affected by configuration baseline. It is said that it is evaluated by something in Intune on a online forum but I have not been able to verify that at the moment.

# Troubleshoot

### CI Shown As Not Applicable

On one of the devices, CI is shown as not applicable.

Go to Configuration manager properties > Configurations > View Report, it appears as below.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/09.CI_NotApplicable.jpg" width="500">

Cause and Solution:

In SCCM, reviewed the CI settings and found in Supported Platform tab, Windows 11 was not ticked so I ticked it.

CI is now evaluated and shown not compliant.

> Windows 11 was not targeted by default.

<br>

### File encryption not turned compliant by enabling Bitlocker

After turning on Bitlocker, report keeps showing it not compliant

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/11.CI_NoPass_EncryptionNotCom.jpg" width="500">

> Unfortunately unsolved.

<br>

### Password minimum length not shown in report

To rule out the possibility that domain default policy affects the evaluation, I set the rule undefined for the policy.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/13.GPO_Corrected.jpg" width="500">

The password setting still not shown in report.

> Unfortunately unsolved.

<br>

### Firewall setting verification

For testing I turned off Firewall on a test device and the report shows it not compliant.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/12.FW_NotCompliant.jpg" width="400">

> Firewall setting is evaluated properly.

The Microsoft article below mentions password settings will be indiscriminately compliant if conditions are not met. But I have not been able to discover anything conclusive why encryption setting is not evaluated as expected.

https://learn.microsoft.com/en-us/intune/configmgr/compliance/deploy-use/create-configuration-items-for-windows-10-devices-managed-with-the-client

<br>

# Lab scenario 2



