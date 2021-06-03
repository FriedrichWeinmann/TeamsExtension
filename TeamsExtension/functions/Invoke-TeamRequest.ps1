function Invoke-TeamRequest {
    <#
    .SYNOPSIS
        Execute a Teams graph API Request.
    
    .DESCRIPTION
        Execute a Teams graph API Request.
        This uses (and requires) the integrated authentication provided by the MicrosoftTeams module.
    
    .PARAMETER Uri
        The relative URI to execute, including all parameters.

    .PARAMETER Method
        Which REST method to execute.
        Defaults to "GET"

    .PARAMETER Body
        A body to include with the actual request.
        Usually needed with POST or PATCH requests.
    
    .PARAMETER Endpoint
        Whether to execute against the beta or 1.0 api.
        Defaults to "beta"
    
    .EXAMPLE
        PS C:\> Invoke-TeamRequest -Uri "teams/$TeamID/channels/$ChannelID/messages"

        Retrieve all messages from the specified channel in the specified team.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Uri,

        [ValidateSet('GET','POST','DELETE','PATCH')]
        [string]
        $Method = "GET",

        $Body,

        [ValidateSet('beta', '1.0')]
        [string]
        $Endpoint = 'beta'
    )

    $command = [Microsoft.TeamsCmdlets.PowerShell.Custom.GetTeam]::new()
    $arguments = @(
        # cmdletName
        "Get-TeamChannel"
        # endPoint
        [Microsoft.TeamsCmdlets.Powershell.Connect.Common.Endpoint]::MsGraphEndpointResourceId
        #IEnumerable<string> requiredScopes = null
        $null
    )
    $null = [PSFramework.Utility.UtilityHost]::InvokePrivateMethod("PerformAuthorization", $command, $arguments)
    $authorization = [PSFramework.Utility.UtilityHost]::GetPrivateProperty("Authorization", $command)
    
    $resource = [Microsoft.TeamsCmdlets.Powershell.Connect.TeamsPowerShellSession]::GetResource(
        [Microsoft.TeamsCmdlets.Powershell.Connect.Common.Endpoint]::MsGraphEndpointResourceId
    )
    $params = @{
        Method = $Method
        ErrorAction = 'Stop'
    }
    if ($Body) { $params.Body = $Body }

    $nextUri = "$resource/$Endpoint/$($Uri.TrimStart("/"))"
    while ($nextUri) {
        Invoke-PSFProtectedCommand -ActionString 'Invoke-TeamRequest.Request' -ActionStringValues $Method, $nextUri -ScriptBlock {
            $results = Invoke-RestMethod @params -Uri $nextUri -Headers @{ Authorization = $authorization }
        } -Target $nextUri -EnableException $true -PSCmdlet $PSCmdlet
        $results.Value
        $nextUri = $results.'@odata.nextLink'
    }
}