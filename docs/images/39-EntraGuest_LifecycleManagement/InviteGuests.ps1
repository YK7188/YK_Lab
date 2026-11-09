# Lab 39: CSV-driven Entra B2B guest provisioning (interactive lab authentication)
# CSV headers: GuestEmail,DisplayName,ManagerUPN
# Only approved requests should be placed in the input CSV.
param(
    [string]$CsvPath = (Join-Path $PSScriptRoot 'Guest_Invitation_Requests.csv'),
    [string]$RedirectUrl = 'https://myapps.microsoft.com'
)

$ErrorActionPreference = 'Stop'
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Identity.SignIns
Import-Module Microsoft.Graph.Users
Connect-MgGraph -Scopes 'User.Invite.All','User.ReadWrite.All','Directory.Read.All' -NoWelcome

if (-not (Test-Path -LiteralPath $CsvPath)) { throw "CSV not found: $CsvPath" }
$requests = @(Import-Csv -LiteralPath $CsvPath)
if ($requests.Count -eq 0) { throw 'The CSV has no requests.' }

$results = foreach ($request in $requests) {
    $email = ([string]$request.GuestEmail).Trim()
    $name = ([string]$request.DisplayName).Trim()
    $managerUpn = ([string]$request.ManagerUPN).Trim()
    $guestId = ''
    $invitationStatus = 'NotStarted'
    $managerStatus = 'NotStarted'
    $details = ''

    try {
        if (-not $email -or -not $name -or -not $managerUpn) {
            throw 'GuestEmail, DisplayName, and ManagerUPN are required.'
        }

        # Validate the Bios-side manager before inviting anyone.
        $manager = Get-MgUser -UserId $managerUpn -Property 'id,userType'
        if ($manager.UserType -ne 'Member') { throw "Manager $managerUpn is not an internal Member account." }

        # Re-runs should not send another invitation to an existing guest.
        $safeEmail = $email.Replace("'", "''")
        $matches = @(Get-MgUser -All -ConsistencyLevel eventual `
            -Filter "mail eq '$safeEmail' or otherMails/any(x:x eq '$safeEmail')" `
            -Property 'id,userType,mail,otherMails')
        if ($matches.Count -gt 1) { throw 'Multiple matching accounts found; investigate manually.' }

        if ($matches.Count -eq 1) {
            if ($matches[0].UserType -ne 'Guest') { throw 'Email belongs to a non-guest account.' }
            $guestId = $matches[0].Id
            $invitationStatus = 'AlreadyExists'
        } else {
            $invite = New-MgInvitation -InvitedUserEmailAddress $email `
                -InvitedUserDisplayName $name -InviteRedirectUrl $RedirectUrl `
                -SendInvitationMessage:$true
            $guestId = $invite.InvitedUser.Id
            if (-not $guestId) { throw 'Invitation returned no user ID; verify Entra audit logs before retrying.' }
            $invitationStatus = 'Invited'
        }

        # A failure here does not undo a successful invitation.
        $managerRef = @{ '@odata.id' = "https://graph.microsoft.com/v1.0/users/$($manager.Id)" }
        Set-MgUserManagerByRef -UserId $guestId -BodyParameter $managerRef
        $managerStatus = 'Assigned'
        $details = "Bios manager: $managerUpn"
    }
    catch {
        if ($invitationStatus -eq 'NotStarted' -and $guestId) { $invitationStatus = 'CheckManually' }
        if ($managerStatus -eq 'NotStarted') { $managerStatus = 'NotAssigned' }
        $details = $_.Exception.Message
        Write-Warning "${email}: $details"
    }

    [pscustomobject]@{
        TimestampUtc     = (Get-Date).ToUniversalTime().ToString('o')
        GuestEmail       = $email
        GuestId          = $guestId
        ManagerUPN       = $managerUpn
        InvitationStatus = $invitationStatus
        ManagerStatus    = $managerStatus
        Details          = $details
    }
}

$logPath = Join-Path $PSScriptRoot ('Lab39_Guest_Results_' + (Get-Date -Format 'yyyyMMdd_HHmmss_fff') + '.csv')
$results | Export-Csv -LiteralPath $logPath -NoTypeInformation -Encoding UTF8
$results | Format-Table GuestEmail,InvitationStatus,ManagerStatus,Details -AutoSize
Write-Host "Results saved to: $logPath"
