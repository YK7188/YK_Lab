## Scenario

A Conditional Access policy was created in Microsoft Entra ID as shown below to restrict Microsoft 365 access to Windows devices marked as compliant by Microsoft Intune.
![Image](https://github.com/user-attachments/assets/098f900b-ca7f-4c46-adcc-9fb3e3a166f3)


---

## Observed behavior

The user attempted to access office.com and web applications from a Windows device that appears compliant in Intune.

Desktop apps (Outlook, Teams, Excel)	> Access granted
Browser access (Edge, Chrome, Firefox)	> Access blocked as shown below

![Image](https://github.com/user-attachments/assets/f3107ac0-846f-4123-ab06-b94051e79000)


---

## Key discovery

Even though the device itself was compliant, browser access was still blocked.
Conditional Access does not simply check whether a device is compliant in Microsoft Intune.
It requires the authentication request to include the device identity so compliance can be verified.
Desktop apps worked because they automatically authenticate using the Windows session and include the device identity through the Primary Refresh Token (PRT).


---

## Important limitation

Private browsing sessions do not work.

Browser Mode	| Result
Edge (signed-in profile)	| Works
Chrome + Windows | Accounts extension	Works
Chrome Incognito	| Blocked
Edge InPrivate	| Blocked

This may appear as inconvenient to some users.

---

## Alternative approach used in many enterprises
Instead of verifying the device directly with Microsoft Intune, some organizations restrict SaaS access based on trusted network egress IPs like Netskope.

