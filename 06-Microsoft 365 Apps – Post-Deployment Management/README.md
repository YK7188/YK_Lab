## Objective

This lab demonstrates how to manage user experience, privacy settings, and update behavior of Microsoft 365 Apps for enterprise after deployment using the Microsoft 365 Apps admin center.

---

## Background

In enterprise environments:

- Deployment is typically handled via Microsoft Intune or ODT
- Post-deployment configuration is handled via Cloud Policy and Servicing Profiles

This separation allows centralized control of Office behavior without reinstalling applications.

---

## 🟢 Section 1 — Cloud Policy Configuration

---

## Example Settings to Configure

Navigate Customization > Policy Management in the portal as shown in the image below.
![01-allow_feedback](https://github.com/user-attachments/assets/38971332-2545-4bff-bb61-36d4a351c7de)

- Disable user feedback submission > Disable "Allow users to submit feedback to Microsoft"
- Disable optional connected experiences > Disable "Allow the use of connected experiences in Office"
- Control diagnostic data level > Disable "Configure the level of client software diagnostic data sent by Office to Microsoft"




---

No dependency on device enrollment in Intune
⚠️ Common Misconceptions
❌ “App Protection / App Config can manage desktop Office”
Desktop Office apps do not use Intune MAM/App Config on Windows.


📝 Final Note

This lab demonstrates post-deployment configuration of Microsoft 365 Apps using the Microsoft 365 Apps admin center.

While deployment tools such as Intune and ODT ensure applications are installed correctly, Cloud Policy and Servicing Profiles provide an additional layer of control to manage user experience, security, and update behavior at scale.
