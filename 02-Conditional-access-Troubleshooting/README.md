## Scenario

A Conditional Access policy was created in Microsoft Entra ID to restrict Microsoft 365 access to Windows devices marked as compliant by Microsoft Intune.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/02-CA_TS_Compliance/01.jpg" width="750">



---

## Observed behavior

The user attempted to access office.com and web applications from a Windows device that appears compliant in Intune.

- Desktop apps (Outlook, Teams, Excel)	> Access granted

- Browser access (Edge, Chrome, Firefox)	> Access blocked as shown below

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/02-CA_TS_Compliance/02.jpg" width="350">



---

## Key discovery

Even though the device itself was compliant, browser access was still blocked.
Conditional Access does not simply check whether a device is compliant in Microsoft Intune.
It requires the authentication request to include the device identity so compliance can be verified.
Desktop apps worked because they automatically authenticate using the Windows session and include the device identity through the Primary Refresh Token (PRT).


---

## Troubleshooting note

During testing, the blocked browser attempts did not appear in the Sign-in logs at all.
This suggests that the request may be rejected before a full authentication event is recorded.


---

## Important limitation

Private browsing sessions do not work because they do not provide the device identity required by Conditional Access.

Browser Mode	| Result

- Edge (signed-in profile)	| Works
- Chrome + Windows Accounts extension	| Works
- Chrome Incognito	| Blocked
- Edge InPrivate	| Blocked

This may appear as inconvenient to some users.

---

## Alternative approach used in many enterprises
Instead of verifying the device directly with Microsoft Intune, some organizations restrict SaaS access based on trusted network egress IPs like Netskope.

