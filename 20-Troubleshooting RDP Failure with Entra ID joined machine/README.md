Tested: May 2026

# Scenario

An AAD user fails to connect to a Entra ID joined PC over RDP.

Root cause was eventually isolated to legacy Per-user MFA.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/20-Troubleshooting%20Entra%20ID%20RDP%20Failure/01.Error.jpg" width="600">

# Isolation Steps Performed

## 1. Verified basic RDP functionality

Confirmed:

- RDP worked with a local user
- The AAD user was in the Remote desktop users group

Result:

> RDP infrastructure itself was healthy.


## 2. Tested other Entra ID users

Tested multiple AAD users against the same device.

Result:

- Some Entra users could RDP successfully.
- Specific users consistently failed.

Conclusion:

> Issue was likely user-specific, not device-wide.

## 3. Tested reverse direction

Reversed the RDP direction.

Result:

- The exact same users failed regardless of target device.

Conclusion:

> Issue followed the user identity, not the endpoint.


## 4. Checked Conditional Access

Reviewed:

Entra Admin Center
- Sign-in Logs
- Conditional Access
- Device Configuration

Result:

- No Conditional Access policy, Device configuration was blocking sign-in.

Conclusion:

> Intune policy was not the root cause.

## 5. Checked local security policy / RDP rights

Reviewed:

secpol.msc > User Rights Assignment

Checked:

- Allow log on through Remote Desktop Services
- Deny log on through Remote Desktop Services

Result:

> No deny assignment or obvious restriction found.

## 6. Verified local interactive login

Affected users successfully logged in locally to the device.

Conclusion:

> Accounts themselves were valid and functional.

## 7. Reset authentication methods

Reset/checked:

- MFA methods
- Authentication methods
- WHfB/PIN registration

Result:

> No improvement.

## 8. Disabled legacy Per-user MFA

Disabled:

- Per-user multifactor authentication

for affected users.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/20-Troubleshooting%20Entra%20ID%20RDP%20Failure/02.Legacy_MFA.jpg" width="600">

Result:

> RDP immediately worked successfully.

## 9. Reproduced issue intentionally

Enabled legacy Per-user MFA on previously working users.

Result:

- RDP failures reproduced consistently.

Conclusion:

> Legacy Per-user MFA was confirmed as the root cause.

# Key takeaway

Legacy “Per-user MFA” can cause edge case like this. In modern settings, the use of it better be avoided.
