function New-OktaAuthenticationHeader {
    <#
        .SYNOPSIS
            Creates the Authentication Header needed to use the Okta API
        .DESCRIPTION
            Requires a pre-configured API Token from the Okta Admin Portal, and uses it to create the Header needed for API Queries
        .PARAMETER OktaAPIToken
            Token Generated from the Okta Admin Portal for the Okta API
        .EXAMPLE
            New-OktaAuthenticationHeader -OktaAPIToken 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
        .EXAMPLE
            $OktaHeader = New-OktaAuthenticationHeader -OktaAPIToken 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]$OktaAPIToken
    ) 
    BEGIN { 
        $OktaAuthenticationHeader = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    } #BEGIN

    PROCESS {
        $OktaAuthenticationHeader.Add("Accept", "application/json")
        $OktaAuthenticationHeader.Add("Content-Type", "application/json")
        $OktaAuthenticationHeader.Add("Authorization", "SSWS $OktaAPIToken")
    } #PROCESS

    END { 
        $OktaAuthenticationHeader
    } #END

} #FUNCTION