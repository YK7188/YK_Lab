> Tested: June 2026

# Lab Scenario 1

The company requires:

- Windows Firewall enabled
- Password minimum length of at least 12 characters
- Device encrypted

SCCM should determine whether devices are compliant.

# Step 1 - Create Configuration Item

Open SCCM Console and go to

Assets and Compliance > Compliance Settings > Configuration Items > Create Configuration Item

Select Windows 10 or later for "Settings for devices managed with the Configuration Manager client"

and complete the wizard.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/01.create_configItem.jpg" width="600">

For Select the device setting groups to configure, select
- System Security
- Password
- Encryption

Configure the following settings.

- Password settings
  - Minimum password length >= 12
  - Remediate noncompliant settings > Checked

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/02.password_setting.jpg" width="500">

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

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/05.Create_CB.jpg" width="400">

And then deploy the configuration baseline.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/06.deploy_CB.jpg" width="500">

On a test device, go to

Configuration properties > Configurations

and the configuration baseline appears.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/07.CB_shown.jpg" width="300">

> Device compliance status shown in Software Center does not appear to be driven by Configuration Baseline results. The exact evaluation mechanism was not investigated further during this lab.

# Troubleshoot

### CI Shown As Not Applicable

On one of the devices, CI is shown as not applicable.

Go to Configuration manager properties > Configurations > View Report, it appears as below.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/09.CI_NotApplicable.jpg" width="500">

Cause and Solution:

In SCCM, reviewed the CI settings and found in Supported Platform tab, Windows 11 was not ticked so I ticked it.

CI is now evaluated and shown not compliant.

> Windows 11 was not included in the Configuration Item applicability settings by default.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/21.only_win10.jpg" width="400">


<br>

### File encryption not turned compliant by enabling Bitlocker

After turning on Bitlocker, report keeps showing it not compliant

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/11.CI_NoPass_EncryptionNotCom.jpg" width="500">

> Even after enabling BitLocker and confirming the drive was fully encrypted, the setting remained non-compliant.

<br>

### Password minimum length not shown in report

To rule out the possibility that domain default policy affects the evaluation, I set the rule undefined for the policy.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/13.GPO_Corrected.jpg" width="600">

The password setting still not shown in report.

> The password setting was not reported in the compliance results despite multiple tests. Further investigation is required to determine how the built-in Password settings are evaluated.

<br>

### Firewall setting verification

Disabling Windows Firewall immediately caused the device to become non-compliant, confirming that the built-in Firewall compliance setting was evaluated successfully.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/12.FW_NotCompliant.jpg" width="500">

The Microsoft article below mentions password settings will be indiscriminately compliant if conditions are not met. But I have not been able to discover anything conclusive why encryption setting is not evaluated as expected.

https://learn.microsoft.com/en-us/intune/configmgr/compliance/deploy-use/create-configuration-items-for-windows-10-devices-managed-with-the-client

<br>

# Lab scenario 2

The company still requires:

- Windows Firewall enabled
- Password minimum length of at least 12 characters
- Device encrypted

SCCM should determine whether devices are compliant.

# Step 1 - Create Configuration Item

Go to Go to Assets and Compliance > Compliance Settings > Configuration Items > Create Configuration Item

- Select "Windows Desktops and Servers (custom)" for "Settings for devices managed with the Configuration Manager client"
- Create custom settings using discovery scripts and define corresponding compliance rules.

```
# BitLocker
[int](Get-BitLockerVolume -MountPoint "C:").ProtectionStatus

# Firewall
(Get-NetFirewallProfile -Profile Domain).Enabled

# Password Length
$line = net accounts | Select-String "Minimum password length"
[int](($line -split ":")[1].Trim())
```

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/19.Disco_Scripts.jpg" width="400">

and complete the wizard.

# Step 2 - Create a Configuration Baseline

Go to

Assets and Compliance > Compliance Settings > Configuration Baselines > Create Configuration Baseline

Add the configuration item and complete the wizard.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/05.Create_CB.jpg" width="400">

And then deploy the configuration baseline.

# Step 3 - Troubleshoot and verification

### Error 

Setting Discovery Error 0x87d00327 Script is not signed CCM

appeared on test devices' reports.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/15.CI_errors.jpg" width="400">

### Solution

In SCCM, go to Administration > Client Settings > Default Client Settings > Computer Agent

Changed PowerShell execution policy setting from Signed to Bypass as below.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/17.Shell_Policy.jpg" width="500">

The CB now evaluates the devices properly. Verified that compliance status changed when BitLocker, local password policy, and Windows Firewall settings were modified.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/18.All_compliant.jpg" width="500">

Status starts showing in Monitoring as well.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/26-Security%20compliance%20policy%20with%20SCCM/20.Deployment_status.jpg" width="650">

# Final Note

Unlike the built-in Windows 10 compliance settings tested in Scenario 1, the custom Configuration Item provided predictable, verifiable, and repeatable compliance results.
