# Files used in the TinyORM GitHub actions

Regenerating hashes is needed after any archive upgrade. Change directory to the repository root and invoke:

```pwsh
.\tools\Get-DownloadsHash.ps1 -Platform Linux,Windows
```

The script knows which files to hash by the file extension, *.7z for Windows and *.bz2 and *.xz for Linux.
