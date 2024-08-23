# Deprecated 🙌

This project isn't needed anymore after the Qt v5.15 was dropped.

# Files used in the TinyORM GitHub actions

Regenerating hashes is needed after any archive upgrade. Change directory to the repository root and invoke:

```pwsh
.\tools\Get-DownloadsHash.ps1 -Platform Linux,Windows
```

The script knows which files to hash by the file extension, *.7z for Windows and *.bz2 and *.xz for Linux.

To upgrade ccache simply download the .tar.xz archive from https://github.com/ccache/ccache/releases

Upgrading clazy standalone isn't that simple, I'm using clazy standalone from QtCreator so it must by manually bzip-ed to clazy-standalone.tar.bz2 file using the following command:

```bash
tar cjvf ../clazy-standalone.tar.bz2 .
```
