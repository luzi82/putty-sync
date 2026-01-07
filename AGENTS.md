# Agent Prompt / Context

## Project Overview
This project contains a PowerShell script `putty-sync.ps1` designed to manage and synchronize PuTTY session settings in the Windows Registry.

## Core File
*   `putty-sync.ps1`: The main script logic.

## Logic Details
The script interacts with `HKCU:\Software\SimonTatham\PuTTY\Sessions`. 
PuTTY stores sessions as URL-encoded subkeys here.

### Argument Parsing
*   `-List`: Enumerates valid session names by decoding registry keys.
*   `-Sync`: Copies values from a source key to all other keys.

### Exclusions
When syncing, the following registry values MUST be preserved in the target sessions:
*   `HostName`
*   `PortNumber`
*   `Protocol`
*   `WinTitle`

### Future Improvements
*   Backup functionality before syncing.
*   Support for "Color Schemes" import/export.
