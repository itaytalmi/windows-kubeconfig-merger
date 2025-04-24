param (
    [Parameter(Mandatory = $true)]
    [string]$NewKubeconfigPath
)

# Define paths
$kubeDir = "$env:USERPROFILE\.kube"
$archiveDir = Join-Path $kubeDir "archive"
$dateStr = Get-Date -Format "yyyyMMdd_HHmmss"
$backupConfig = Join-Path $archiveDir "config_backup_$dateStr"
$originalConfig = Join-Path $kubeDir "config"
$tempConfig = Join-Path $kubeDir "config_tmp"
$secondaryConfig = Join-Path $kubeDir "config2"

# Ensure archive directory exists
if (-not (Test-Path -Path $archiveDir)) {
    Write-Output "Creating archive directory at $archiveDir"
    New-Item -ItemType Directory -Path $archiveDir | Out-Null
}

# Step 1: Backup the existing kubeconfig
Write-Output "Backing up existing kubeconfig to $backupConfig"
Copy-Item -Path $originalConfig -Destination $backupConfig -Force

# Step 2: Copy the new kubeconfig to a temporary location
Write-Output "Copying new kubeconfig from $NewKubeconfigPath to $secondaryConfig"
Copy-Item -Path $NewKubeconfigPath -Destination $secondaryConfig -Force

# Step 3: Set the KUBECONFIG environment variable to include both files
$env:KUBECONFIG = "$originalConfig;$secondaryConfig"
Write-Output "KUBECONFIG set to: $env:KUBECONFIG"

# Step 4: Merge and flatten the configurations
Write-Output "Merging kubeconfig files..."
kubectl config view --merge --flatten | Out-File -FilePath $tempConfig -Encoding ascii

# Step 5: Replace the original kubeconfig with the merged config
Write-Output "Replacing original kubeconfig with merged config"
Move-Item -Path $tempConfig -Destination $originalConfig -Force

# Step 6: Cleanup
Write-Output "Cleaning up temporary config file"
Remove-Item -Path $secondaryConfig -Force

Write-Output "Kubeconfig merge complete!"