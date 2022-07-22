# Meadow-DevScripts

Scripts for developing for and on Wilderness Labs' Meadow platform.

Currently, just a script for checking out everything and keeping it updated with the latest dev work going forward.

## Prerequisites

* Clone this scripts repo to a folder where you would like all the Meadow repos to also be cloned, such as a `WildernessLabs` folder. If you keep all possible repos together, and there are name conflicts between Meadow repos and other adjacent repos, it will likely cause Git commands to fail in weird ways.
* [Install PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.2) for your system ([Windows](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2), [macOS](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.2)), [Linux](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2), or [ARM variants of these](https://docs.microsoft.com/en-us/powershell/scripting/install/powershell-on-arm?view=powershell-7.2))

## DevRepos-CloneOrUpdate.ps1

Get the latest code and changes from the various Meadow repos and their typical development branches.

* ✅ If you haven't checked out any of the Meadow repositories, or only some of them, this script will clone the rest of them.
* ✅ If you already have any of the Meadow repositories, this script will try to update them with the latest changes from their upstream development branches.
  * ✅ If you are working on a branch other than the development branch, this script will try to update your development branch for merging or later checkout.
  * ⛔ But, if your local development branch is ahead of the upstream development branch (or otherwise out of sync), this script will not update your repo. You'll have to pull and/or merge those changes yourself.
