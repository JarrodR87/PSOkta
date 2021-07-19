function Set-OktaUser {
    <#
        .SYNOPSIS
            Sets specified Okta Switch for the User or users specified
        .DESCRIPTION
            Modifies Specified Users based on the options specified as a Switch
        .PARAMETER OktaAPIURI
            URI specific to your Organizations Okta Instance
        .PARAMETER OktaAPIToken
            Token Generated from the Okta Admin Portal for the Okta API
        .PARAMETER OktaUserIDs
            Users to Modify
        .PARAMETER ResetFactors
            Resets MFA for specified Users
        .PARAMETER UnlockUser
            Unlocks Specified Users
        .EXAMPLE
            Set-OktaUser -OktaAPIToken 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' -OktaAPIURI 'YOURORG.okta.com' -OktaUserIDs 'LockedUser01@lock.com','LockedUser02@locks.com' -UnlockUser
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