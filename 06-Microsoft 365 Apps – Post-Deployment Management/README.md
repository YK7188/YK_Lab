## Objective

This lab demonstrates how to manage user experience, privacy settings, and update behavior of Microsoft 365 Apps for enterprise after deployment using the Microsoft 365 Apps admin center and Intune.

---

## Background

In enterprise environments:

- Deployment is typically handled via Microsoft Intune or ODT
- Post-deployment configuration is handled via Cloud Policy and Device Configuration.

---

## Example Settings to Configure Cloud Policy

In Office 365 admin portal, navigate Customization > Policy Management as shown in the image below.
![01-allow_feedback](https://github.com/user-attachments/assets/38971332-2545-4bff-bb61-36d4a351c7de)

- Things commonly disabled in the real-world.
  - Disable "Allow users to submit feedback to Microsoft"
  - Disable "Allow the use of connected experiences in Office"
  - Disable "Configure the level of client software diagnostic data sent by Office to Microsoft"
  - Disable "Show LinkedIn features in Office applications"
  - Disable "Block macros from running in Office files from the Internet"

---

## Example Settings to Configure Device Configuration

In Intune, navigate Devices > Windows > Configuration.
![02-DeviceConfig](https://github.com/user-attachments/assets/2427b5c8-b598-414e-9445-378d09f931ab)

- Things enabled in the example configuration.
  - Enable Automatic Updates
  - Hide Update Notifications
  - Update Channel
  - Update Deadline


To stagger update channels (i.g., Current for IT, Montly for end users), an enterprise typically creates multiple configuration profiles.


- Point to notice
  
No dependency on device enrollment in Intune

⚠️ Common Misconceptions > “App Protection / App Config can manage desktop Office”

Desktop Office apps do not use Intune MAM/App Config on Windows.

## Final Note

While deployment tools such as Intune and ODT ensure applications are installed correctly, Cloud Policy and Device Configuration provide an additional layer of control to manage user experience, security, and update behavior at scale.
