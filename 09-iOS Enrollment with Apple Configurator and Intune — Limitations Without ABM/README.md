
## Objective
Test whether an iPhone can be enrolled into Microsoft Intune using Apple Configurator without Apple Business Manager.

## Environment
- Intune (MDM authority configured)
- Apple MDM Push Certificate (valid)
- iPhone (reset)
- Apple Configurator on macOS

## Method

1. Created MDM server in Configurator using: `https://enrollment.manage.microsoft.com`
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/09-ios-configurator-intune/04.%20serverURL.jpg" width="600">


2. Prepared device:
- Manual configuration
- Supervised
- Assigned to MDM server

3. Completed Setup Assistant

## Result

Device displayed: `This iPhone is owned by [Organization]`

Then: `The configuration for your iPhone could not be downloaded`

> Enrollment failed before any user sign-in prompt.

## Additional Testing — Enrollment Profile Assignment

1. To rule out missing enrollment configuration, an Apple Configurator profile was created in Intune.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/09-ios-configurator-intune/01.%20Profile%20Creation.jpg" width="600">

2. The device serial number was imported and associated with the profile.

3. The enrollment URL exported from Intune was also tested in Apple Configurator.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/09-ios-configurator-intune/05.%20profile.jpg" width="600">

4. Ensured that no restrictions were configured.
<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/09-ios-configurator-intune/03.%20enrollment%20restrictions.jpg" width="600">

-> The same error occurred: `The configuration for your iPhone could not be downloaded`



## Analysis

✔ Remote Management was triggered, but no enrollment configuration was successfully delivered to the device.

✔ It appears that without Apple Business Manager, the device cannot be recognized by Intune.

## Conclusion

Apple Configurator can successfully place an iOS device into a supervised state and trigger the Remote Management screen.

However, without Apple Business Manager, Intune is unable to complete device-driven enrollment, 
even when a profile is created and the device serial number is assigned.

This suggests that Apple Business Manager is required for Intune to recognize the device
during Setup Assistant and deliver enrollment configuration.

