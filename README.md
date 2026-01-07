# PuTTY Session Sync

A PowerShell script to synchronize settings across all your PuTTY sessions. This is useful when you want to update font settings, colors, or window behavior for all your saved sessions without overwriting connection-specific details like Hostname or Port.

## Features

- **List Sessions**: Quickly list all saved PuTTY sessions.
- **Sync Settings**: Apply settings from a "Default Settings" session (or any specific session) to all other saved sessions.
- **Smart Exclusions**: Automatically preserves connection-specific settings:
  - Hostname / IP Address
  - Port
  - Connection Type (SSH, Telnet, etc.)
  - Window Title

## Usage

### List all sessions
```powershell
.\putty-sync.ps1 -List
```

### Sync from Default Settings
Applies settings from the "Default Settings" session to all other sessions.
```powershell
.\putty-sync.ps1 -Sync
```

### Sync from a specific session
Applies settings from the session named "MyTemplate" to all other sessions.
```powershell
.\putty-sync.ps1 -Sync "MyTemplate"
```
