





> Labbed: October 2026

# Scenario

An existing guest user could be added to one private Microsoft Teams team but not another. Both teams belonged to the same tenant, and the issue was observed by **multiple team owners**.

- In the affected team, the Teams client returned:

  **"We didn't find any matches. Talk to your admin."**

  <img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/titbits/02-Teams_GuestAdditionIssue/01.png" width="600">

- The same guest could be added through the **Teams admin center**, suggesting that guest membership was not completely blocked.

# Investigation

1. Confirmed that the affected team was backed by a **Microsoft 365 group**.

2. Inspected its group-specific settings using Microsoft Graph PowerShell:

```powershell
Get-MgGroupSetting -GroupId "<GroupId>" |
    Select-Object -ExpandProperty Values |
    Format-Table Name, Value
```

**Result:**

```text
Name             Value
----             -----
AllowToAddGuests False
```

- The affected group had an explicit **`AllowToAddGuests = False`** setting, while the working group had no group-specific settings object and inherited the applicable defaults.
- This group-specific setting was **not exposed in the standard Teams or Entra admin center GUI**.

# Resolution

After changing **`AllowToAddGuests` to `True`**, the Teams client successfully allowed the existing guest user to be added to the affected team.

The **Add members** dialog also displayed the option to invite people outside the organization.

The reason the group originally had **`AllowToAddGuests = False`** remains unknown.



