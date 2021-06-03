function Export-TeamMessage {
    <#
    .SYNOPSIS
        Exports all messages in all channels within a team.
    
    .DESCRIPTION
        Exports all messages in all channels within a team.

        This command takes any number of team IDs, iterates over all messages in each of them and then exports them.
        This is of course subject to the current user's access rights.

        It will create one sub-folder per team.
        In this subfolder it will then generate one json file per channel, including all the messages.
    
    .PARAMETER Team
        The team to export.
    
    .PARAMETER Path
        The path in which to generate the json-file-backed export.
        Specify a folder, it will create one subfolder per team exported.
        Defaults to the current path.
	
	.PARAMETER EnableException
		This parameters disables user-friendly warnings and enables the throwing of exceptions.
		This is less user friendly, but allows catching exceptions in calling scripts.
	
	.PARAMETER Confirm
		If this switch is enabled, you will be prompted for confirmation before executing any operations that change state.
	
	.PARAMETER WhatIf
		If this switch is enabled, no actions are performed but informational messages will be displayed that explain what would happen if the command were to run.
    
    .EXAMPLE
        PS C:\> Get-Team | Export-TeamMessage

        Export all messages in all teams you have access to to the current folder.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupID')]
        [string[]]
        $Team,

        [string]
        $Path = '.',

        [switch]
        $EnableException
    )

    process {
        foreach ($teamID in $Team) {
            Write-PSFMessage -String 'Export-TeamMessage.Processing' -StringValues $teamID -Target $teamID
            Invoke-PSFProtectedCommand -ActionString 'Export-TeamMessage.Create.ExportFolder' -ActionStringValues $path, $teamID -ScriptBlock {
                $teamFolder = New-Item -Path $Path -Name $teamID -ItemType Directory -Force -ErrorAction Stop
            } -Target $teamID -EnableException $EnableException -PSCmdlet $PSCmdlet -Continue
            $channelIndex = @{ }

            Write-PSFMessage -String 'Export-TeamMessage.Read.Channels' -StringValue $teeamID -Target $teamID
            try { $channels = Get-TeamChannel -GroupId $teamID -ErrorAction Stop }
            catch { Stop-PSFFunction -String 'Export-TeamMessage.Read.Channels.Failed' -StringValue $teeamID -Target $teamID -ErrorRecord $_ -EnableException $EnableException -Continue }
            foreach ($channel in $channels) {
                $fileName = "$($channel.DisplayName -replace "[^\d\w]",'_').json"
                $channelIndex[$channel.Id] = $channel | Add-Member -MemberType NoteProperty -Name ExportFile -Value $fileName -Force -PassThru
    
                Invoke-PSFProtectedCommand -ActionString 'Export-TeamMessage.Read.Channel.Message' -ActionStringValues $teamID, $channel.DisplayName, $channel.Id -ScriptBlock {
                    $messages = Get-TeamChannelMessage -TeamID $teamID -ChannelID $channel.Id -ErrorAction Stop
                    Write-PSFMessage -Level Debug -String 'Export-TeamMessage.Read.Channel.Message.Count' -StringValues $channel.Id, @($messages).Count -FunctionName Export-TeamMessage -ModuleName TeamsExtension
                    $messages | ConvertTo-Json -Depth 99 | Set-Content -Path "$($teamFolder.FullName)/$fileName" -Encoding UTF8 -ErrorAction Stop
                } -Target $teamID -EnableException $EnableException -PSCmdlet $PSCmdlet -Continue
            }

            Invoke-PSFProtectedCommand -ActionString 'Export-TeamMessage.Read.Channel.Index' -ActionStringValues $teamID -ScriptBlock {
                $channelIndex | ConvertTo-Json -Depth 99 | Set-Content -Path "$($teamFolder.FullName)/channelIndex.json" -Encoding UTF8 -ErrorAction Stop
            } -Target $teamID -EnableException $EnableException -PSCmdlet $PSCmdlet -Continue
        }
    }
}