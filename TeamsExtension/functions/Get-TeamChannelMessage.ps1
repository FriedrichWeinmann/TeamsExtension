function Get-TeamChannelMessage {
    <#
    .SYNOPSIS
        Returns all messages in a specified channel's messages.
    
    .DESCRIPTION
        Returns all messages in a specified channel's messages.
        Note that the replies to a message are part of the "Replies" property.
        So expect one output object per conversation.
    
    .PARAMETER TeamID
        The ID of the team to process.
    
    .PARAMETER ChannelID
        The ID of the channel within the team to process.
    
    .EXAMPLE
        PS C:\> Get-TeamChannelMessage -TeamID $team.GroupID -ChannelID $channel.ID

        Retrieve all the messages in the specified channel of the specified team.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $TeamID,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $ChannelID
    )

    process {
        Write-PSFMessage -String 'Get-TeamChannelMessage.Message' -StringValues $TeamID, $ChannelID
        $messages = Invoke-TeamRequest -Uri "teams/$TeamID/channels/$ChannelID/messages"
        foreach ($message in $messages) {
            Write-PSFMessage -String 'Get-TeamChannelMessage.Message.Replies' -StringValues $TeamID, $ChannelID, $message.ID
            $replies = Invoke-TeamRequest -Uri "teams/$TeamID/channels/$ChannelID/messages/$($message.ID)/replies"
            Add-Member -InputObject $message -MemberType NoteProperty -Name Replies -Value $replies -PassThru
        }
    }
}