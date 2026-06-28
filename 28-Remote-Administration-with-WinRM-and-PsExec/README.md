Labbed: June 2026

# Lab Objective

Enable and validate remote administration of Windows devices using PowerShell Remoting (WinRM) and PsExec in both Intune-managed and on-premises environments.

# Scenario 1 —PowerShell Remoting on Intune Devices

## Environment

- Both source (AADPC1) and target (AADPC3) devices are Entra ID joined and Intune managed.
- Both devices reside within the same Hyper-V LAN.

## Configuration

### Step 1 —Assign local administrator permissions using Intune

Navigate to:

Endpoint security > Account protection > Create policy > Windows > Local user group membership

and add the required user or group to the local Administrators group on the remote devices.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-RemoteAdministration_WinRM%20%26%20PSExec/01.LocalAdmin_Deployment.jpg" width="600">

### Step 2 —Create and assign an Intune PowerShell script

Navigate to:

Devices > Windows > Scripts and remediations > Platform scripts > Add

and deploy the following script to enable WinRM on the remote device.

```
# Enable WinRM / PowerShell Remoting
Enable-PSRemoting -Force -SkipNetworkProfileCheck

# Disable default WinRM firewall rules
Disable-NetFirewallRule -DisplayGroup "Windows Remote Management"

# Create restricted lab firewall rule
New-NetFirewallRule `
    -DisplayName "WinRM_Lab_5985_From_HyperV_LAN" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 5985 `
    -RemoteAddress "172.23.224.0/19" `
    -Profile Private `
    -Action Allow
```

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-RemoteAdministration_WinRM%20%26%20PSExec/11.Intune_script.jpg" width="600">

## Verification

### Using an Entra ID

Test the Invoke-Command cmdlet using an Entra ID account that has local administrator privileges on the remote device.

```
$cred = get-credential
Invoke-Command -ComputerName 172.23.224.1 -Credential $cred -ScriptBlock { hostname; whoami }
```

Result:

- An Access is denied error was returned.
- Testing various username formats, including removing the AzureAD\ prefix, did not resolve the issue.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-RemoteAdministration_WinRM%20%26%20PSExec/04.Error_EntraID.jpg" width="600">

### Using a local administrator account

Repeat the test using the built-in local Administrator account.

Result:

The command executed successfully and returned the hostname of the remote device.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-RemoteAdministration_WinRM%20%26%20PSExec/12.WinRM_EntraDev_Succeed.jpg" width="600">

---

# Scenario 2 —PsExec on Intune Devices

## Environment

- Both source and remote devices are Entra ID joined and Intune managed.
- Both devices reside within the same Hyper-V LAN.

## Configuration —Enable SMB access using an Intune firewall policy

Create an Intune firewall rule to allow inbound TCP port 445 on the remote device.

Path: Endpoint security > Firewall > Create policy > Windows Firewall Rules

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-RemoteAdministration_WinRM%20%26%20PSExec/13.intune_Port445.jpg" width="700">

## Verification

Run the following command:

```
.\PsExec.exe \\TargetIP -u AADPC3\Administrator -p password -i hostname
```

Result:

- Both local administrator accounts and Entra ID accounts in AzureAD\user@tenant.onmicrosoft.com format successfully authenticated and executed commands remotely.
- During testing, omitting the -i switch resulted in the following error:
> Logon failure: the user has not been granted the requested logon type at this computer.

Adding the -i switch allowed the command to execute successfully using the same credentials.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-RemoteAdministration_WinRM%20%26%20PSExec/05.succeeded_EntraID.jpg" width="700">

---

# Scenario 3 —PowerShell Remoting on On-Premises AD Devices

## Environment

- Both source (ADPC1) and target (ADPC3) devices are joined to on-premises Active Directory.
- Both devices are managed using Group Policy.
- Both devices reside within the same Hyper-V LAN.

## Configuration

### Step 1 —Assign local administrator permissions using Group Policy

Create a GPO to add the required users or groups to the local Administrators group.

Path: Computer Configuration > Preferences > Control Panel Settings > Local Users and Groups

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-RemoteAdministration_WinRM%20%26%20PSExec/06.LocalAdmins.jpg" width="600">

### Step 2 —Create a startup PowerShell script using Group Policy

Create a startup script policy.

Path: Computer Configuration > Policies > Windows Settings > Windows PowerShell Scripts

```
Enable-PSRemoting -Force -SkipNetworkProfileCheck

Disable-NetFirewallRule -DisplayGroup "Windows Remote Management"

$ruleName = "WinRM_Lab_5985_From_HyperV_LAN"

if (-not (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule `
        -DisplayName $ruleName `
        -Direction Inbound `
        -Protocol TCP `
        -LocalPort 5985 `
        -RemoteAddress "172.23.224.0/19" `
        -Profile Domain,Private `
        -Action Allow
}
```

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-RemoteAdministration_WinRM%20%26%20PSExec/07.Script_GPO.jpg" width="600">

## Verification

```
Invoke-Command -ComputerName ADPC3 -ScriptBlock { hostname }
```

Result:

- The command executed successfully and returned the hostname of the remote device.
- Unlike the Intune scenario, explicit credentials were not required because Kerberos authentication was used automatically between the two domain-joined machines.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-RemoteAdministration_WinRM%20%26%20PSExec/08.WinRM_Success.jpg" width="600">

---

# Scenario 4 —PsExec on On-Premises AD Devices

## Environment

- Both source (ADPC1) and target (ADPC3) devices are joined to on-premises Active Directory.
- Both devices are managed using Group Policy.
- Both devices reside within the same Hyper-V LAN.

## Configuration

Create a GPO to allow inbound SMB traffic on TCP port 445.

Path: Computer Configuration > Policies > Windows Settings > Security Settings > Windows Defender Firewall with Advanced Security > Inbound Rules

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-RemoteAdministration_WinRM%20%26%20PSExec/09.Open_SMB.jpg" width="700">

## Verification

Run the following command:

```
.\PsExec.exe \\ADPC3 hostname
```

Result:

- The command successfully returned the hostname of the remote device.
- Explicit credentials using -u and -p were not required because PsExec automatically leveraged Kerberos authentication between the two domain-joined machines.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/28-RemoteAdministration_WinRM%20%26%20PSExec/10.psexec_succeed.jpg" width="600">



