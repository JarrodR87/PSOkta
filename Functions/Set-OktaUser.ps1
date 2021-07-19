function Set-OktaUser {
    <#
        .SYNOPSIS
            Sets specified Okta Switch for the User or users specified
        .DESCRIPTION
            C
        .PARAMETER P1
            C
        .EXAMPLE
            Set-OktaUser -OktaAPIToken '00TyoACdphZl8ZhH7zktIZ3PqQhMRHvtwoPFo1ZxUz' -OktaAPIURI 'dev-9672049.okta.com' -OktaUserIDs 'lockiemclockerson@lockersKPD.com','jarrodapi@capacitor.knowles.com' -UnlockUser
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]$OktaAPIToken,
        [Parameter(Mandatory = $true)]$OktaAPIURI,
        [Parameter(Mandatory = $true)]$OktaUserIDs,
        [Parameter(Mandatory = $false)][switch]$ResetFactors,
        [Parameter(Mandatory = $false)][switch]$UnlockUser
    ) 
    BEGIN { 
        $OktaAuthenticationHeader = New-OktaAuthenticationHeader -OktaAPIToken $OktaAPIToken
    } #BEGIN

    PROCESS {
        foreach ($OktaUserID in $OktaUserIDs) {
            if ($ResetFactors.IsPresent -eq $true) {
                $OktaResponse = Invoke-RestMethod ("https://" + $OktaAPIURI + '/api/v1/users/' + $OktaUserID + '/lifecycle/reset_factors') -Method 'POST' -Headers $OktaAuthenticationHeader
            }

            if ($UnlockUser.IsPresent -eq $true) {
                $OktaResponse = Invoke-RestMethod ("https://" + $OktaAPIURI + '/api/v1/users/' + $OktaUserID + '/lifecycle/unlock') -Method 'POST' -Headers $OktaAuthenticationHeader
            }
        }

    } #PROCESS

    END { 
        $OktaResponse
    } #END

} #FUNCTION