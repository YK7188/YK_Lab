## Scenario

A corporate device is joined to Entra ID and automatically enrolled into Intune.
Access to Office 365 applications is restricted using Conditional Access policies
that require devices to report a compliant state. This lab simulates a troubleshooting scenario where a device fails compliance
evaluation due to antivirus protection being disabled.

---

## Test device setup

1. Start up a Windows 10 PC - AADPC1. As shown in the image it has not joined AAD yet.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/01-CA-TS-01/1.dsregcmd.jpg" width="600">

2. Manually join the device to Entra ID as shown in the image.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/01-CA-TS-01/2.joinAAD.jpg" width="600">

3. The user has to be allowed to join devices.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/01-CA-TS-01/5.devicesettings.jpg" width="600">

4. Confirm that the device has joined to Entra ID.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/01-CA-TS-01/3.proofonPC.jpg" width="600">

5. The device is automatically enrolled into Intune because MDM automatic enrollment is enabled for all users.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/01-CA-TS-01/6.Autoenrollment.jpg" width="700">

## Policy Configuration

1. Configure compliance policy to require the device to have Antivirus turned on.
   
   Antivirus > Require
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/01-CA-TS-01/7.antivirus.jpg" width="600">

3. Configure Conditional access for Office365.
   
   Grant access > Require device to be marked as compliant
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/01-CA-TS-01/8.conditional.jpg" width="600">

## Policy Enforcement Test

1. Test to log into office.com on the device with Antivirus turned off and confirm the policy is effective.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/01-CA-TS-01/10.loginfailure.jpg" width="300">

2. The device is shown as non-compliant in the report.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/01-CA-TS-01/9.noncompliant.jpg" width="600">

3. Turn Antivirus on or turn the policy off and confirm login is successfull this time.
   
