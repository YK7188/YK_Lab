## Objective

This lab demonstrates how to centrally manage user experience, privacy controls, and update behavior for Microsoft 365 Apps after deployment using Cloud Policy and Intune.

---

## Cloud Policy Configuration

In Microsoft 365 Apps admin center, navigate Customization > Policy Management as shown in the image below.
![01-allow_feedback](https://github.com/user-attachments/assets/38971332-2545-4bff-bb61-36d4a351c7de)

- Commonly configured settings include:
  - Disable 窶廣llow users to submit feedback to Microsoft窶・
  - Restrict 窶廚onnected experiences窶・(depending on organizational requirements)
  - Configure diagnostic data level (e.g., Required only)
  - Disable 窶彜how LinkedIn features in Office applications窶・
  - Block macros from running in Office files from the Internet

---

## Device Configuration (Intune)

In Intune, navigate Devices > Configuration.
![02-DeviceConfig](https://github.com/user-attachments/assets/2427b5c8-b598-414e-9445-378d09f931ab)

- Example configuration includes:
  - Enable Automatic Updates (required for update enforcement)
  - Hide Update Notifications (optional, improves user experience)
  - Update Channel (controls when updates become available)
  - Update Deadline (controls how long users can defer updates)

## Key Considerations
- Cloud Policy does not require device enrollment in Intune, as it applies user-based settings when users sign in to Office applications.
- Common Misconception
  - 窶廣pp Protection / App Configuration can manage desktop Office窶・

Desktop Office applications on Windows do not support Intune App Protection (MAM) or App Configuration policies, which are primarily designed for mobile platforms.

---

## Final Note

While deployment tools such as Intune and ODT ensure applications are installed, Cloud Policy and Intune configuration profiles provide centralized control over user experience, security posture, and update behavior across the organization.

