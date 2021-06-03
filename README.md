# Teams Extension

## Synopsis

This is an extension module to the official MicrosoftTeams PowerShell module.
It allows you to fill some of the gaps left by the original module, intentionally or not, while using the original module's authentication mechanism.

Specifically, it allows you to execute custom requests against the Microsoft Graph Api using the same token and application as used by the Teams module.

## Install

To install the module, run the following line:

```powershell
Install-Module TeamsExtension -Scope CurrentUser
```

It will install all dependencies as well.

## Use

The most simple form of using this module is using `Invoke-TeamRequest`:

```powershell
Invoke-TeamRequest -Uri "teams/$TeamID/channels/$ChannelID/messages"
```

With that command you would download all messages in the specified channel of the specified team.

> Note: Messages are the top level, thread starting messages.
> Getting the replies requires further read requests per message.
> For convenience, use the also included `Get-TeamChannelMessage` command.

## Exporting all Team messages

The command `Export-TeamMessage` provides the ability to obtain all messages from a team and write it to file.
For example, this one-liner could be used to export all messages from all teams the current user has access to:

```powershell
Get-Team | Export-TeamMessage -Path C:\export\Teams
```

## PSFramework

This module implements [PSFramework](https://psframework.org)-based logging.
See the [feature documentation](https://psframework.org/documentation/documents/psframework/logging.html) to learn how to set up logging.
