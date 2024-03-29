# TODO: Get this script to update this script's repo and restart.

# Get the latest dev commits for each repo.
# Multi-line commands are marked with the continuation character for ease of use in a CLI, but are not needed for a full script file.
$upstreamRemoteDefault = "origin";
$upstreamDevelopBranchDefault = "develop";
# Start with a list of all the repos we want to check.
$repoNames = @(
  "DefCon-Badge-2022",
  "Meadow.CLI",
  "Meadow.Contracts",
  "Meadow.Core",
  "Meadow.Core.Samples",
  "Meadow.Foundation",
  "Meadow.Foundation.Grove",
  "Meadow.Foundation.Featherwings",
  "Meadow.Foundation.MikroBus",
  "Meadow.Linux",
  "Meadow.Logging",
  "Meadow.ModBus",
  "Meadow.Project.Samples",
  "Meadow.ProjectLab",
  "Meadow.ProjectLab.Samples",
  "Meadow.Sdk",
  "Meadow.TestSuite",
  "Meadow.Tests",
  "Meadow.Units",
  "Meadow_Samples",
  "VSCode_Meadow_Extension",
  "VS_Win_Meadow_Extension",
  "Meadow_Performance_Benchmarks",
  "Documentation",
  "Juego",
  "Meadow_Assemblies",
  "MQTTnet",
  "Maple"
);
# Create a list of all repo default overrides to the defaults.
# NOTE: Not using [PSCustomObject] because `Add-Member -NotePropertyMembers` doesn't work with those objects.
$repoCustomDetails = @(
  @{
    RepoName = "DefCon-Badge-2022";
    UpstreamDevelopBranch = "main";
  },
  # @{
  #   RepoName = "Meadow.Logging";
  #   UpstreamDevelopBranch = "main";
  # },
  # @{
  #   RepoName = "Meadow.Foundation";
  #   UpstreamDevelopBranch = "develop";
  # },
  # @{
  #   RepoName = "Meadow.TestSuite";
  #   UpstreamDevelopBranch = "feature/validation";
  # },
  @{
    RepoName = "Meadow.Tests";
    UpstreamDevelopBranch = "main";
  },
  @{
    RepoName = "MQTTnet";
    UpstreamDevelopBranch = "meadow";
  },
  # @{
  #   RepoName = "Meadow.Linux";
  #   UpstreamDevelopBranch = "develop";
  # }
  @{
    RepoName = "Juego";
    UpstreamDevelopBranch = "v2";
  }
);
# Build up a list of repo details using the defaults.
$repoDetailList = $repoNames
  | ForEach-Object {
    [PSCustomObject]@{
      RepoName = $_;
      RepoUrl = "https://github.com/WildernessLabs/$_.git";
      UpstreamRemoteName = $upstreamRemoteDefault;
      UpstreamDevelopBranch = $upstreamDevelopBranchDefault;
      LocalDirectory = $_;
    }
  };
# Merge any custom repo overrides with the bulk-generated defaults.
$repoCustomDetails
  | ForEach-Object {
    $repoName = $_.RepoName;
    $repoDefaults = $repoDetailList | Where-Object { $_.RepoName -eq $repoName };
    if ($repoDefaults -ne $null) {
      $repoDefaults | Add-Member -NotePropertyMembers $_ -PassThru -Force;
    }
  } | Out-Null; # Disregard normal console output from this command.
$repoDetailList
  | ForEach-Object {
    # Try to get the latest changes from all upstream repos.
    Write-Host "Repo: $($_.RepoName)";
    if (Test-Path -Path $_.LocalDirectory) {
      Set-Location $_.LocalDirectory;
      $currentBranch = (git branch --show-current);
      if ($currentBranch -eq $_.UpstreamDevelopBranch) {
        # Found expected dev branch currently checked out; proceeding...
        $expectedRemoteName = $_.UpstreamRemoteName;
        $availableRemoteNames = git remote;
        if ($LASTEXITCODE -eq 1) {
          # External `git` call failed (git remote).
          Write-Warning "`tError getting repo remotes: $($_.RepoName).";
          $availableRemoteNames = @();
        }
        $hasExpectedRemote = ($availableRemoteNames | Where-Object { $_ -eq $expectedRemoteName }).Count -eq 1;
        Write-Host $hasExpectedRemote;
        if (!$hasExpectedRemote) {
          # Didn't find expected Git remote.
          Write-Warning "`tRemote not available: $($_.UpstreamRemoteName).";
          Write-Warning "`tSkipped update: $($_.RepoName).";
        } else {
          Write-Host "`tPulling latest from $($_.UpstreamRemoteName)/$($_.UpstreamDevelopBranch).";
          git pull $($_.UpstreamRemoteName) $($_.UpstreamDevelopBranch);
          if ($LASTEXITCODE -eq 1) {
            # External `git` call failed (git pull).
            Write-Warning "`tError pulling latest upstream changes: $($_.RepoName) $($_.UpstreamRemoteName)/$($_.UpstreamDevelopBranch).";
          } else {
            # External `git` call succeeded (git pull).
            Write-Host "`tUpdated with latest upstream changes: $($_.RepoName) $($_.UpstreamRemoteName)/$($_.UpstreamDevelopBranch).";
          }
        }
      } else {
        # Not on the desired dev branch. Requesting an update to the dev branch without impacting current branch.
        Write-Warning "`tRepo $($_.RepoName) not on expected dev branch ($($currentBranch) vs. $($_.UpstreamDevelopBranch)).`n`tAttempting to update adjacent dev branch.";
        git fetch $($_.UpstreamRemoteName) $($_.UpstreamDevelopBranch):$($_.UpstreamDevelopBranch);
        if ($LASTEXITCODE -eq 1) {
          # External `git` call failed (git fetch).
          Write-Warning "`tError updating adjacent dev branch: $($_.RepoName) $($_.UpstreamRemoteName)/$($_.UpstreamDevelopBranch).`n`t`tMake sure your dev branch isn't ahead of the upstream dev branch.";
        } else {
          Write-Host "`tUpdated adjacent dev branch: $($_.RepoName) $($_.UpstreamDevelopBranch).`n`t`tYour current branch was unaffected ($($currentBranch)).";
        }
      }
      Set-Location ..
    } else {
      # Repo not found; cloning new...
      Write-Host "`tRepo folder not found: cloning new copy...";
      git clone --branch $($_.UpstreamDevelopBranch) --origin $($_.UpstreamRemoteName) $($_.RepoUrl) $($_.LocalDirectory);
      if ($LASTEXITCODE -eq 1) {
        # External `git` call failed (git clone).
        Write-Warning "`tError cloning repo: $($_.RepoName)";
      } else {
        # External `git` call succeeded (git clone).
        Write-Host "`tCloned new repo: $($_.RepoName)";
      }
    }
  };
