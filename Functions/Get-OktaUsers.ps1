function Get-OktaUsers {
    <#
        .SYNOPSIS
            Gtes Okta Users from specified Okta URI
        .DESCRIPTION
            Gets Okta Users, or only Locked Okta Users, from Okta URI. Only pulls the first 200 Users
        .PARAMETER OktaAPIToken
            Token Generated from the Okta Admin Portal for the Okta API
        .PARAMETER LockedOut
            Switch Paramter to only query Locked Okta Users
        .PARAMETER PasswordExpired
            Switch Paramter to only query PasswordExpired Okta Users
        .PARAMETER OktaAPIURI
            URI specific to your Organizations Okta Instance
        .EXAMPLE
            Get-OktaUsers -OktaAPIToken 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' -OktaAPIURI 'YOURORG.okta.com'
        .EXAMPLE
            Get-OktaUsers -OktaAPIToken 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' -OktaAPIURI 'YOURORG.okta.com' -LockedOut
        .EXAMPLE
            Get-OktaUsers -OktaAPIToken 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' -OktaAPIURI 'YOURORG.okta.com' -PasswordExpired
            
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]$OktaAPIToken,
        [Parameter(Mandatory = $true)]$OktaAPIURI,
        [Parameter(Mandatory = $false)][switch]$LockedOut,
        [Parameter(Mandatory = $false)][switch]$PasswordExpired
    ) 
    BEGIN { 
        $OktaAuthenticationHeader = New-OktaAuthenticationHeader -OktaAPIToken $OktaAPIToken
        $OktaUsers = @()
    } #BEGIN

    PROCESS {
        if ($LockedOut.IsPresent -eq $true) {
            $OktaResponse = Invoke-RestMethod ("https://" + $OktaAPIURI + '/api/v1/users?filter=status eq "LOCKED_OUT"') -Method 'GET' -Headers $OktaAuthenticationHeader
        }

        if ($PasswordExpired.IsPresent -eq $true) {
            $OktaResponse = Invoke-RestMethod ("https://" + $OktaAPIURI + '/api/v1/users?filter=status eq "PASSWORD_EXPIRED"') -Method 'GET' -Headers $OktaAuthenticationHeader
        }

        if (($LockedOut.IsPresent -eq $false) -and ($PasswordExpired.IsPresent -eq $false) ) {
            $OktaResponse = Invoke-RestMethod ("https://" + $OktaAPIURI + '/api/v1/users') -Method 'GET' -Headers $OktaAuthenticationHeader
        }
        

        foreach ($OktaUser in $OktaResponse) {
            $Row = New-Object PSObject
            $Row | Add-Member -MemberType noteproperty -Name "Status" -Value $OktaUser.status
            $Row | Add-Member -MemberType noteproperty -Name "firstName" -Value $OktaUser.Profile.firstName
            $Row | Add-Member -MemberType noteproperty -Name "lastName" -Value $OktaUser.Profile.lastName
            $Row | Add-Member -MemberType noteproperty -Name "mobilePhone" -Value $OktaUser.Profile.mobilePhone
            $Row | Add-Member -MemberType noteproperty -Name "secondEmail" -Value $OktaUser.Profile.secondEmail
            $Row | Add-Member -MemberType noteproperty -Name "login" -Value $OktaUser.Profile.login
            $Row | Add-Member -MemberType noteproperty -Name "email" -Value $OktaUser.Profile.email
            $Row | Add-Member -MemberType noteproperty -Name "Created" -Value $OktaUser.Created
            $Row | Add-Member -MemberType noteproperty -Name "activated" -Value $OktaUser.activated
            $Row | Add-Member -MemberType noteproperty -Name "statuschanged" -Value $OktaUser.statuschanged
            $Row | Add-Member -MemberType noteproperty -Name "lastlogin" -Value $OktaUser.lastlogin
            $Row | Add-Member -MemberType noteproperty -Name "lastupdated" -Value $OktaUser.lastupdated
            $Row | Add-Member -MemberType noteproperty -Name "passwordchanged" -Value $OktaUser.passwordchanged
            $Row | Add-Member -MemberType noteproperty -Name "id" -Value $OktaUser.id

            $OktaUsers += $Row
        }
    } #PROCESS

    END { 
        $OktaUsers
    } #END

} #FUNCTION