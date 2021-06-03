# This is where the strings go, that are written by
# Write-PSFMessage, Stop-PSFFunction or the PSFramework validation scriptblocks
@{
    'Export-TeamMessage.Create.ExportFolder'        = 'Creating export folder for {1} in {0}' # $path, $teamID
    'Export-TeamMessage.Processing'                 = 'Processing message data from team {0}' # $teamID
    'Export-TeamMessage.Read.Channel.Index'         = 'Creating index of channels processed for team {0}' # $teamID
    'Export-TeamMessage.Read.Channel.Message'       = 'Retrieving all messages for channel {1} ({2}) in team {0}' # $teamID, $channel.DisplayName, $channel.Id
    'Export-TeamMessage.Read.Channel.Message.Count' = 'Finished retrieving {1} messages from channel {0}' # $channel.Id, @($messages).Count
    'Export-TeamMessage.Read.Channels'              = 'Retrieving list of channels from team {0}' # $teeamID
    'Export-TeamMessage.Read.Channels.Failed'       = 'Failed to retrieve list of channels from team {0}' # $teeamID

    'Get-TeamChannelMessage.Message'                = 'Retrieving messages from channel {1} for team {0}' # $TeamID, $ChannelID
    'Get-TeamChannelMessage.Message.Replies'        = 'Retrieving replies to the message {2} from channel {1} for team {0}' # $TeamID, $ChannelID, $message.ID

    'Invoke-TeamRequest.Request'                    = 'Executing {0} request against {1}' # $Method, $nextUri
}