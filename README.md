# 🧩 Kubeconfig Merge Tool for Windows

This PowerShell script automates the process of merging a new `kubeconfig` file into your existing Kubernetes config on **Windows**. It safely backs up the original config, performs the merge using `kubectl`, and keeps an archive of time-stamped backups for reference.

## Features

- Creates an archive folder under `.kube` for storing dated backups.
- Automatically timestamps each backup.
- Merges configurations using `kubectl config view --merge --flatten`.
- Cleans up temporary files after merging.

## Prerequisites

- PowerShell 5.1+ or PowerShell Core
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) installed and in your system `PATH`
- Windows OS (tested on Windows 10+)

## Usage

### Clone the repo or download the script

```powershell
git clone https://github.com/itaytalmi/windows-kubeconfig-merger.git
cd kubeconfig-merge-tool
```

### Run the script

```powershell
.\Merge-Kubeconfig.ps1 -NewKubeconfigPath "C:\Path\To\New\kubeconfig"
```

This will:
1. Backup your current config file (e.g., C:\Users\<you>\.kube\config) to ~\ kube\archive\config_backup_YYYYMMDD_HHMMSS.
2. Merge it with the new kubeconfig file.
3. Replace the original config with the merged version.
4. Clean up any temporary files used in the process.

Example output:

```text
Creating archive directory at C:\Users\itay\.kube\archive
Backing up existing kubeconfig to C:\Users\itay\.kube\archive\config_backup_20250424_223600
Copying new kubeconfig from new-kubeconfig to C:\Users\itay\.kube\config2
KUBECONFIG set to: C:\Users\itay\.kube\config;C:\Users\itay\.kube\config2
Merging kubeconfig files...
Replacing original kubeconfig with merged config
Cleaning up temporary config file
Kubeconfig merge complete!
```

## Cleanup

The script will automatically delete temporary files (like config2 and config_tmp) after the merge. Old backups are preserved under:

```text
%USERPROFILE%\.kube\archive
```

You can clean up older backups manually or implement a retention policy in the script.

## Safety Notes

- Always verify the merged kubeconfig by running:

    ```powershell
    kubectl config get-contexts
    ```

- You can restore a backup by manually copying the desired file from the archive directory back to `.kube\config.`