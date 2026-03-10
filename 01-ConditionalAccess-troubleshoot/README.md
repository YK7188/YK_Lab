## Scenario

A corporate device is joined to Entra ID and automatically enrolled into Intune.
Access to Office 365 applications is restricted using Conditional Access policies
that require devices to report a compliant state. This lab simulates a troubleshooting scenario where a device fails compliance
evaluation due to antivirus protection being disabled.

---

## Test device setup

1. Start up a Windows 10 PC - AADPC1. As shown in the image it has not joined AAD yet.
![1 dsregcmd](https://github.com/user-attachments/assets/a1505543-8c00-4289-bdac-3dbca5d52337)

2. Manually join the device to Entra ID as shown in the image.
![2 joinAAD](https://github.com/user-attachments/assets/3cb7b4bb-821c-4d13-8e9d-7b616a485d7b)

3. The user has to be allowed to join devices.
![5 devicesettings](https://github.com/user-attachments/assets/c4653ca0-5b17-4f75-b85f-993990edb296)

4. Confirm that the device has joined to Entra ID.
![3 proofonPC](https://github.com/user-attachments/assets/fd64bc9b-8b26-4bb0-be66-19802f216db7)

5. The device is automatically enrolled into Intune because MDM automatic enrollment is enabled for all users.
![6 Autoenrollment](https://github.com/user-attachments/assets/a76d5272-d43e-4c39-ac3e-cac5759de7ba)


## Policy Configuration

1. Configure compliance policy to require the device to have Antivirus turned on.
   
   Antivirus > Require
![7 antivirus](https://github.com/user-attachments/assets/05826fa9-e267-447c-9cfb-ea8f329838e0)

3. Configure Conditional access for Office365.
   
   Grant access > Require device to be marked as compliant
![8 conditional](https://github.com/user-attachments/assets/4e71beb5-8eb1-47c0-87ac-f71e65719f6a)


## Policy Enforcement Test

1. Test to log into office.com on the device with Antivirus turned off and confirm the policy is effective.
![10 loginfailure](https://github.com/user-attachments/assets/d1dcefa6-d1c1-4bef-b2a7-0aa314525d2a)

2. The device is shown as non-compliant in the report.
![9 noncompliant](https://github.com/user-attachments/assets/ee494e51-c59b-4847-84f6-f6dde3d21d0b)

3. Turn Antivirus on or turn the policy off and confirm login is successfull this time.
   
