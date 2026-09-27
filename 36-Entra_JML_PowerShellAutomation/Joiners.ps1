# ============================================================
# JML - Joiner Automation
# Microsoft Entra / Microsoft Graph
# ============================================================

$TenantDomain = "contoso.onmicrosoft.com"
$InputFile    = ".\JML_Input.csv"

$Timestamp  = Get-Date -Format "yyyy-MM-dd_HHmmss"
$ReportFile = ".\JML_Results_$Timestamp.csv"
$RetryFile  = ".\JML_Retry_$Timestamp.csv"

$Results      = @()
$RetryRecords = @()

# ============================================================
# ACCESS CONFIGURATION
# ============================================================

$BaselineGroups = @(
    "SG_JML_all",
    "365_JML_all",
    "SG_LIC_PowerAutomate"
)

$DepartmentGroups = @{
    "Sales" = @("SG_Sales_all","365_Sales_all","SG_LIC_D365_Sales")
    "CS"    = @("SG_CS_all","365_CS_all","SG_LIC_D365_CS")
    "Eng"   = @("SG_Eng_all","365_Eng_all")
    "IT"    = @("SG_IT_all","365_IT_all")
    "GA"    = @("SG_GA_all","365_GA_all")
}

# ============================================================
# FUNCTIONS
# ============================================================

function New-TemporaryPassword {

    $Upper   = 'ABCDEFGHJKLMNPQRSTUVWXYZ'
    $Lower   = 'abcdefghijkmnopqrstuvwxyz'
    $Numbers = '23456789'
    $Special = '!@#$%'

    $Characters = @(
        $Upper[(Get-Random -Maximum $Upper.Length)]
        $Lower[(Get-Random -Maximum $Lower.Length)]
        $Numbers[(Get-Random -Maximum $Numbers.Length)]
        $Special[(Get-Random -Maximum $Special.Length)]
    )

    $All = $Upper + $Lower + $Numbers + $Special

    1..12 | ForEach-Object {
        $Characters += $All[(Get-Random -Maximum $All.Length)]
    }

    $Characters = $Characters | Sort-Object { Get-Random }

    return -join $Characters
}

function Get-UniqueAlias {
    param (
        [string]$FirstName,
        [string]$LastName
    )

    $FirstPart = $FirstName.Substring(0,[Math]::Min(2,$FirstName.Length))
    $BaseAlias = ($FirstPart + $LastName).ToLower() -replace '[^a-z0-9]', ''

    $Alias   = $BaseAlias
    $Counter = 0

    while ($true) {
        $UPN = "$Alias@$TenantDomain"

        $ExistingUser = Get-MgUser `
            -Filter "userPrincipalName eq '$UPN'" `
            -ErrorAction SilentlyContinue

        if (-not $ExistingUser) {
            return $Alias
        }

        $Counter++
        $Alias = "$BaseAlias$Counter"
    }
}

function Get-EntraGroup {
    param (
        [string]$GroupName
    )

    $Groups = @(
        Get-MgGroup `
            -Filter "displayName eq '$GroupName'" `
            -ErrorAction SilentlyContinue
    )

    if ($Groups.Count -eq 1) {
        return $Groups[0]
    }

    return $null
}

function Add-EntraGroupMember {
    param (
        [string]$GroupName,
        [string]$UserId
    )

    $Group = Get-EntraGroup -GroupName $GroupName

    if (-not $Group) {
        throw "Entra group '$GroupName' could not be resolved."
    }

    $Body = @{
        "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$UserId"
    }

    New-MgGroupMemberByRef `
        -GroupId $Group.Id `
        -BodyParameter $Body `
        -ErrorAction Stop
}

# ============================================================
# IMPORT HR INPUT
# ============================================================

$Employees = Import-Csv $InputFile

Write-Host ""
Write-Host "Loaded $($Employees.Count) Joiner records."
Write-Host ""

# ============================================================
# BATCH PRE-FLIGHT
# ============================================================

Write-Host "Running batch pre-flight..."

try {
    $null = Get-MgOrganization -ErrorAction Stop
    Write-Host "[PASS] Microsoft Graph"
}
catch {
    Write-Host "[FAIL] Microsoft Graph cannot be queried."
    Write-Host "BATCH ABORTED - 0 users created."
    return
}

Write-Host ""

# ============================================================
# PROCESS JOINERS
# ============================================================

foreach ($Employee in $Employees) {

    $UPN         = ""
    $CreatedUser = $null
    $PreCheckErrors = @()

    Write-Host "------------------------------------------"
    Write-Host "$($Employee.EmployeeId) - $($Employee.FirstName) $($Employee.LastName)"

    # Duplicate EmployeeId
    try {
        $ExistingEmployee = @(
            Get-MgUser `
                -Filter "employeeId eq '$($Employee.EmployeeId)'" `
                -Property Id,DisplayName,EmployeeId `
                -ErrorAction Stop
        )
    }
    catch {
        $PreCheckErrors += "Unable to check EmployeeId: $($_.Exception.Message)"
        $ExistingEmployee = @()
    }

    if ($ExistingEmployee.Count -gt 0) {
        Write-Host "[SKIP] EmployeeId already exists"

        $Results += [PSCustomObject]@{
            EmployeeId = $Employee.EmployeeId
            Name       = "$($Employee.FirstName) $($Employee.LastName)"
            UPN        = ""
            Status     = "SKIP_EXISTING"
            Error      = ""
        }

        continue
    }

    # Department mapping
    if (-not $DepartmentGroups.ContainsKey($Employee.Department)) {
        $PreCheckErrors += "Department '$($Employee.Department)' is not configured."
    }

    # Manager
    try {
        $Manager = Get-MgUser `
            -UserId $Employee.ManagerUPN `
            -ErrorAction Stop
    }
    catch {
        $Manager = $null
        $PreCheckErrors += "Manager '$($Employee.ManagerUPN)' was not found."
    }

    # Standard access
    $StandardGroups = @($BaselineGroups)

    if ($DepartmentGroups.ContainsKey($Employee.Department)) {
        $StandardGroups += $DepartmentGroups[$Employee.Department]
    }

    foreach ($GroupName in $StandardGroups) {
        if (-not (Get-EntraGroup -GroupName $GroupName)) {
            $PreCheckErrors += "Required group '$GroupName' was not found."
        }
    }

    # Requested access - Entra security groups only
    $RequestedSecurityGroups = @()

    if ($Employee.RequestedAccess) {
        $RequestedSecurityGroups = @(
            $Employee.RequestedAccess.Split(";") |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ }
        )
    }

    foreach ($GroupName in $RequestedSecurityGroups) {
        if (-not (Get-EntraGroup -GroupName $GroupName)) {
            $PreCheckErrors += "Requested security group '$GroupName' was not found."
        }
    }

    # Pre-check result
    if ($PreCheckErrors.Count -gt 0) {
        $ErrorText = $PreCheckErrors -join " | "

        Write-Host "[PRECHECK FAILED] $ErrorText"

        $Results += [PSCustomObject]@{
            EmployeeId = $Employee.EmployeeId
            Name       = "$($Employee.FirstName) $($Employee.LastName)"
            UPN        = ""
            Status     = "PRECHECK_FAILED"
            Error      = $ErrorText
        }

        $RetryRecords += $Employee
        continue
    }

    Write-Host "[PASS] Pre-check"

    # ========================================================
    # GENERATE IDENTITY
    # ========================================================

    $Alias = Get-UniqueAlias `
        -FirstName $Employee.FirstName `
        -LastName $Employee.LastName

    $UPN = "$Alias@$TenantDomain"
    $TemporaryPassword = New-TemporaryPassword

    $PasswordProfile = @{
        Password                      = $TemporaryPassword
        ForceChangePasswordNextSignIn = $true
    }

    # ========================================================
    # PROVISION
    # ========================================================

    try {
        $CreatedUser = New-MgUser `
            -DisplayName "$($Employee.FirstName) $($Employee.LastName)" `
            -GivenName $Employee.FirstName `
            -Surname $Employee.LastName `
            -UserPrincipalName $UPN `
            -MailNickname $Alias `
            -Department $Employee.Department `
            -JobTitle $Employee.JobTitle `
            -EmployeeId $Employee.EmployeeId `
            -UsageLocation $Employee.UsageLocation `
            -AccountEnabled `
            -PasswordProfile $PasswordProfile `
            -ErrorAction Stop

        Write-Host "[CREATED] $UPN"

        # Manager
        $ManagerBody = @{
            "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($Manager.Id)"
        }

        Set-MgUserManagerByRef `
            -UserId $CreatedUser.Id `
            -BodyParameter $ManagerBody `
            -ErrorAction Stop

        # Baseline + department access
        foreach ($GroupName in $StandardGroups) {
            Add-EntraGroupMember `
                -GroupName $GroupName `
                -UserId $CreatedUser.Id
        }

        # Requested application access
        foreach ($GroupName in $RequestedSecurityGroups) {
            Add-EntraGroupMember `
                -GroupName $GroupName `
                -UserId $CreatedUser.Id
        }

        Write-Host "[SUCCESS] Provisioning completed"

        $Results += [PSCustomObject]@{
            EmployeeId = $Employee.EmployeeId
            Name       = "$($Employee.FirstName) $($Employee.LastName)"
            UPN        = $UPN
            Status     = "SUCCESS"
            Error      = ""
        }
    }

    # ========================================================
    # FAILURE / ROLLBACK
    # ========================================================

    catch {
        $ProvisioningError = $_.Exception.Message
        Write-Host "[FAILED] $ProvisioningError"

        if ($CreatedUser) {
            try {
                Remove-MgUser `
                    -UserId $CreatedUser.Id `
                    -ErrorAction Stop

                Write-Host "[ROLLBACK] Account removed"
                $Status = "ROLLED_BACK"
            }
            catch {
                $RollbackError = $_.Exception.Message
                Write-Host "[ROLLBACK FAILED] $RollbackError"

                $Status = "ROLLBACK_FAILED"
                $ProvisioningError = "$ProvisioningError | Rollback error: $RollbackError"
            }
        }
        else {
            $Status = "CREATION_FAILED"
        }

        $Results += [PSCustomObject]@{
            EmployeeId = $Employee.EmployeeId
            Name       = "$($Employee.FirstName) $($Employee.LastName)"
            UPN        = $UPN
            Status     = $Status
            Error      = $ProvisioningError
        }

        $RetryRecords += $Employee
    }
}

# ============================================================
# EXPORT RESULTS
# ============================================================

$Results | Export-Csv `
    -Path $ReportFile `
    -NoTypeInformation `
    -Encoding UTF8

if ($RetryRecords.Count -gt 0) {
    $RetryRecords | Export-Csv `
        -Path $RetryFile `
        -NoTypeInformation `
        -Encoding UTF8
}

# ============================================================
# SUMMARY
# ============================================================

$Successful     = @($Results | Where-Object Status -eq "SUCCESS").Count
$Existing       = @($Results | Where-Object Status -eq "SKIP_EXISTING").Count
$PreCheckFailed = @($Results | Where-Object Status -eq "PRECHECK_FAILED").Count
$CreationFailed = @($Results | Where-Object Status -eq "CREATION_FAILED").Count
$RolledBack     = @($Results | Where-Object Status -eq "ROLLED_BACK").Count
$RollbackFailed = @($Results | Where-Object Status -eq "ROLLBACK_FAILED").Count

Write-Host ""
Write-Host "=========================================="
Write-Host "JML JOINER SUMMARY"
Write-Host "=========================================="
Write-Host "Input records    : $($Employees.Count)"
Write-Host "Successful       : $Successful"
Write-Host "Existing         : $Existing"
Write-Host "Pre-check failed : $PreCheckFailed"
Write-Host "Creation failed  : $CreationFailed"
Write-Host "Rolled back      : $RolledBack"
Write-Host "Rollback failed  : $RollbackFailed"
Write-Host ""
Write-Host "Results : $ReportFile"

if ($RetryRecords.Count -gt 0) {
    Write-Host "Retry   : $RetryFile"
}
