## Objective

This lab demonstrates how to centrally manage user experience, privacy controls, and update behavior for Microsoft 365 Apps after deployment using Cloud Policy and Intune.

---

## Example Settings to Configure Cloud Policy

In Office 365 admin portal, navigate Customization > Policy Management as shown in the image below.
![01-allow_feedback](https://github.com/user-attachments/assets/38971332-2545-4bff-bb61-36d4a351c7de)

- Commonly configured settings include:
  - Disable “Allow users to submit feedback to Microsoft”
  - Restrict “Connected experiences” (depending on organizational requirements)
  - Configure diagnostic data level (e.g., Required only)
  - Disable “Show LinkedIn features in Office applications”
  - Block macros from running in Office files from the Internet

---

## Example Settings to Configure Device Configuration

In Intune, navigate Device > Configuration.
![02-DeviceConfig](https://github.com/user-attachments/assets/2427b5c8-b598-414e-9445-378d09f931ab)

- Things enabled in the example configuration.
  - Enable Automatic Updates (required for update enforcement)
  - Hide Update Notifications (optional, improves user experience)
  - Update Channel (controls when updates become available)
  - Update Deadline (controls how long users can defer updates)

- Point to notice
  
Cloud Policy does not require device enrollment in Intune, as it applies user-based settings when users sign in to Office applications.

⚠️ Common Misconceptions > “App Protection / App Config can manage desktop Office”

Desktop Office applications on Windows do not support Intune App Protection (MAM) or App Configuration policies, which are primarily designed for mobile platforms.

---

## Final Note

While deployment tools such as Intune and ODT ensure applications are installed, Cloud Policy and Intune configuration profiles provide centralized control over user experience, security posture, and update behavior across the organization.
