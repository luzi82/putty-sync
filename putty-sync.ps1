# putty-sync.ps1

param(
    [switch]$List,
    [switch]$Sync,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Rest
)

$RegistryBase = "HKCU:\Software\SimonTatham\PuTTY\Sessions"

function Show-Help {
    Write-Host "Usage:"
    Write-Host "  .\putty-sync.ps1 -List"
    Write-Host "  .\putty-sync.ps1 -Sync [SessionName]"
    Write-Host ""
    Write-Host "  -List : List all putty session names."
    Write-Host "  -Sync : Sync settings to all sessions."
    Write-Host "          Optional session_name defaults to 'Default Settings'."
    Write-Host "          Excludes: Hostname, Port, Protocol, WinTitle."
}

if (-not $List -and -not $Sync) {
    Show-Help
    exit
}

function Encode-SessionName ($name) {
    # PuTTY uses URL encoding for session keys
    [Uri]::EscapeDataString($name)
}

function Decode-SessionName ($keyName) {
    [Uri]::UnescapeDataString($keyName)
}

if ($List) {
    if (Test-Path $RegistryBase) {
        $sessions = Get-ChildItem -Path $RegistryBase
        foreach ($s in $sessions) {
            Write-Host (Decode-SessionName $s.PSChildName)
        }
    } else {
        Write-Host "PuTTY Sessions registry key not found."
    }
    exit
}

if ($Sync) {
    # Determine Source Session
    $sourceName = "Default Settings"
    if ($Rest.Count -gt 0) {
        $sourceName = $Rest[0]
    }
    
    $encodedSource = Encode-SessionName $sourceName
    $sourcePath = Join-Path $RegistryBase -ChildPath $encodedSource
    
    if (-not (Test-Path $sourcePath)) {
        Write-Error "Source session '$sourceName' not found at '$sourcePath'."
        exit 1
    }
    
    Write-Host "Syncing from source: $sourceName"
    
    # Get Source Properties
    $sourceProps = Get-ItemProperty -Path $sourcePath
    
    # Exclusions
    # Hostname / IP -> HostName
    # port -> PortNumber
    # connection type -> Protocol
    # Window > Behaviour > Window title -> WinTitle
    # And unwanted PS properties
    $excludeKeys = @("HostName", "PortNumber", "Protocol", "WinTitle", "PSPath", "PSParentPath", "PSChildName", "PSDrive", "PSProvider")
    
    # Get All Sessions
    $sessions = Get-ChildItem -Path $RegistryBase
    
    foreach ($target in $sessions) {
        $targetName = Decode-SessionName $target.PSChildName
        if ($target.PSChildName -eq $encodedSource) {
            continue # Skip source
        }
        
        Write-Host "  Updating: $targetName"
        $targetPath = $target.PSPath
        
        foreach ($prop in $sourceProps.PSObject.Properties) {
            $name = $prop.Name
            if ($name -notin $excludeKeys) {
                # Sync value
                $val = $prop.Value
                Set-ItemProperty -Path $targetPath -Name $name -Value $val
            }
        }
        Write-Host "    - Done"
    }
    Write-Host "Sync Complete."
}
