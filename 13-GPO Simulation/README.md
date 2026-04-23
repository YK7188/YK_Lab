> Tested: April 2026

## Objective
Simulate real-world Group Policy configurations and validate their application on domain-joined devices.
<br>

---

## Part 1 — RDP Security

Policy Name: GPO-RDP-Hardening

OU: HQ > Computers

1. Enforce Network Level Authentication (NLA)
   
Require user authentication for remote connections by using Network Level Authentication > Enabled

Path: 
`Computer Configuration
→ Policies
→ Administrative Templates
→ Windows Components
→ Remote Desktop Services
→ Remote Desktop Session Host
→ Security`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/13-GPO%20simulation/01.%20NLA_Config.jpg" width="600">

<br>

2. Disable Clipboard Redirection

Do not allow clipboard redirection > Enabled

Path:
`Computer Configuration
→ Policies
→ Administrative Templates
→ Windows Components
→ Remote Desktop Services
→ Remote Desktop Session Host
→ Device and Resource Redirection`

---

## Part 2 — Password Policy

Policy: Default Domain Policy (edited)
> Note: Password policies must be configured at the domain level to apply to domain users.

Path:
`Computer Configuration
→ Policies
→ Windows Settings
→ Security Settings
→ Account Policies
→ Password Policy`

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/13-GPO%20simulation/02.%20Password_config.jpg" width="600">

<br>

---

## Part 3 - Windows update policy

Policy Name: GPO-WindowsUpdate

OU: HQ > Computers

Path:
`Computer Configuration
→ Policies
→ Administrative Templates
→ Windows Components
→ Windows Update`

- Configure Automatic Updates > Enabled
  - 3 - Auto download and notify for install

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/13-GPO%20simulation/03.%20windows_update_auto.jpg" width="600">

<br>

---

 ## Verification

1. Group Policy Results Wizard

Using Group Policy Results in Group Policy Management Console:

The test policies apper under Applied GPOs.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/13-GPO%20simulation/04.%20validation%20on%20server.jpg" width="600">

2. Client-side validation

Power shell commnad:
`gpresult /r /scope computer`

The test policies appear under Applied Group Policy Objects.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/13-GPO%20simulation/05.%20validation%20on%20endpoint.jpg" width="600">



  
