> Tested: April 2026

## Objective
Simulate real-world Group Policy configurations and validate their application on domain-joined devices.
<br>

---

## Part 1 窶・RDP Security

- Policy Name: GPO-RDP-Hardening
- Target OU: HQ > Computers

### 1. Enforce Network Level Authentication (NLA)
   
Require user authentication for remote connections by using Network Level Authentication > Enabled

Path: 
`Computer Configuration
竊・Policies
竊・Administrative Templates
竊・Windows Components
竊・Remote Desktop Services
竊・Remote Desktop Session Host
竊・Security`

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/13-GPO%20simulation/01.%20NLA_Config.jpg" width="600">

<br>

### 2. Disable Clipboard Redirection

Do not allow clipboard redirection > Enabled

Path:
`Computer Configuration
竊・Policies
竊・Administrative Templates
竊・Windows Components
竊・Remote Desktop Services
竊・Remote Desktop Session Host
竊・Device and Resource Redirection`

---

## Part 2 窶・Password Policy

Policy: Default Domain Policy (edited)
> Note: Password policies must be configured at the domain level to apply to domain users.

Path:
`Computer Configuration
竊・Policies
竊・Windows Settings
竊・Security Settings
竊・Account Policies
竊・Password Policy`

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/13-GPO%20simulation/02.%20Password_config.jpg" width="600">

<br>

---

## Part 3 - Windows update policy

- Policy Name: GPO-WindowsUpdate
- Target OU: HQ > Computers

Path:
`Computer Configuration
竊・Policies
竊・Administrative Templates
竊・Windows Components
竊・Windows Update`

- Configure Automatic Updates > Enabled
  - 3 - Auto download and notify for install

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/13-GPO%20simulation/03.%20windows_update_auto.jpg" width="600">

<br>

---

 ## Verification

Validation was performed from both the server side and the client side.

### 1. Group Policy Results Wizard

Using Group Policy Results in Group Policy Management Console:

The configured GPOs apper under Applied GPOs.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/13-GPO%20simulation/04.%20validation%20on%20server.jpg" width="600">

### 2. Client-side validation

Commnad:
`gpresult /r /scope computer`

The configured GPOs appear under Applied Group Policy Objects.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/13-GPO%20simulation/05.%20validation%20on%20endpoint.jpg" width="600">



  

