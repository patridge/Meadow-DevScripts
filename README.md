# Meadow-DevScripts

Scripts for developing for and on Wilderness Labs' Meadow platform.

Currently, just a script for checking out everything and keeping it updated with the latest dev work going forward.

## Prerequisites

* [Install PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.2) for your system ([Windows](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2), [macOS](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.2), [Linux](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2), or [ARM variants of these](https://docs.microsoft.com/en-us/powershell/scripting/install/powershell-on-arm?view=powershell-7.2))

## Installation on a new environment

If you haven't cloned any Meadow repos, create a folder to contain them all and switch to that folder.

From a PowerShell terminal, run the following commands. (These commands use a default folder name of `WildernessLabs`; adjust accordingly.)

1. `mkdir WildernessLabs`
1. `cd WildernessLabs`
1. `git clone https://github.com/patridge/Meadow-DevScripts.git`

## Installation with existing repos

If you already have some Meadow repos cloned, clone this scripts repo adjacent to them.

1. `git clone https://github.com/patridge/Meadow-DevScripts.git`

## DevRepos-CloneOrUpdate.ps1

Get the latest code and changes from the various Meadow repos and their typical development branches.

From within the **Meadow-DevScripts** repo, run the following command in a PowerShell terminal.

`DevRepos-CloneOrUpdate.ps1`

* ✅ If you haven't checked out any of the Meadow repositories, or only some of them, this script will clone the rest of them.
* ✅ If you already have any of the Meadow repositories, this script will try to update them with the latest changes from their upstream development branches.
  * ✅ If you are working on a branch other than the development branch, this script will try to update your development branch for merging or later checkout.
  * ⛔ But, if your local development branch is ahead of the upstream development branch (or otherwise out of sync), this script will not update your repo. You'll have to pull and/or merge those changes yourself.

The default upstream remote is `origin`. You can change this either for all repos or just some repos. To change this value for all repos, edit the `$upstreamRemoteDefault` variable at the top of the script to your desired upstream remote name. To change this value for specific repos, configure a customization object to use a different upstream remote name. (See instructions below.)

The default upstream development branch is `develop`. You can change this either for all repos or just some repos. To change this value for all repos, edit the `$upstreamDevelopBranchDefault` variable at the top of the script to your desired upstream development branch name. To change this value for specific repos, configure a customization object to use a different upstream development branch name. (See instructions below.)

### Repo clone/update customizations

To override defaults for select repositories, create or edit a customization object in the `$repoCustomDetails` array. For each custom details object, the repo defaults for any matching repo (based on `RepoName`) will be changed based on these override values.

For example, if the **Meadow.Foundation** repo is using a version specific development branch, you would add a custom object to override that, adding an override value for `UpstreamDevelopBranch` to match.

```powershell
$repoCustomDetails = @( `
  // ...Any other override objects...
  @{ `
    RepoName = "Meadow.Foundation"; `
    UpstreamDevelopBranch = "vNext"; `
  }, `
);
```

Available override fields:

* `RepoUrl` - Customize to use a different Git repo URL entirely. (Default value looks for the repo name in the Wilderness Labs GitHub team.)
* `UpstreamRemoteName` - Customize to change the name of the upstream remote (e.g., `upstream`). (Default value is `origin`, set in `$upstreamRemoteDefault`.)
* `UpstreamDevelopBranch` - Customize to change the name of the upstream development branch where updates are retrieved. (Default value is `develop`, set in `$upstreamDevelopBranchDefault`.)
