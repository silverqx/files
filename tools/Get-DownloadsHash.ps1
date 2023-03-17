#!/usr/bin/env pwsh

[CmdletBinding()]
Param(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelinebyPropertyName,
        HelpMessage = 'Specifies which OS platform to generate the hash for.')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('Linux', 'Windows')]
    [string[]] $Platform = @('Linux', 'Windows')
)

begin {
    Set-StrictMode -Version 3.0
}

process {
    foreach ($platform_ in $Platform) {
        [string[]] $filesPath = $null
        [string] $outputFilepath = $null

        # Prepare files glob and output file
        switch -Exact ($platform_) {
            'Linux' {
                $filesPath = $('*.bz2', '*.xz')
                $outputFilepath = './hashes/Linux.txt'
            }
            'Windows' {
                $filesPath = $('*.7z')
                $outputFilepath = './hashes/Windows.txt'
            }
            Default {
                throw "Unsupported platform value '$platform_'."
            }
        }

        # Calculate an individual SHA-256 hash for each matched file and concatenate them
        # to a single string
        $hashes = Get-FileHash -Path $filesPath -Algorithm SHA256 |
                  Select-Object -ExpandProperty Hash |
                  Out-String -NoNewline

        # Calculate a final SHA-256 hash for the set of files
        $hashesBytes = [System.Text.Encoding]::UTF8.GetBytes($hashes)

        $hashInfo = Get-FileHash -InputStream ([System.IO.MemoryStream]::new($hashesBytes))

        # Write the hash to the file in the format for actions/cache
        $hash = $hashInfo.Hash.Substring(0, 8).ToLower()

        # Output
        Write-Output $hash
        $hash | Out-File -Path $outputFilepath -NoNewline
    }
}

<#
 .Synopsis
  Calculates a SHA-256 hash for the set of files by the given Platform.

 .Description
  The `Get-DownloadsHash` calculates a SHA-256 hash for the set of files by the given
  Platform. It matches all `*.7z` files for `Windows` platform and `*.bz2` and `*.xz` for `Linux`
  in the current folder. Computed hashes are sent to the stdout and
  to the `hashes/{Windows,Linux}.txt` files.

  Hashes are in the short form eg. `f628632a` and are intended for direct use in the GitHub's
  `action/cache` in the `key` parameter, eg. `key: drivers-qmysql-dlls-f628632a`.

  No files will be downloaded if the cache hits and all files will be downloaded on the cache miss.

 .Parameter Path
  Specifies which OS platform to generate the hash for, is Windows by default.

 .INPUTS
  System.String[]
    You can pipe a string that contains a Platform to the `Get-DownloadsHash`.

 .OUTPUTS
  System.String[]
    `Get-DownloadsHash` outputs calculated hashes.

 .Example
   # Calculate hashes for Linux and Windows platforms
   Get-DownloadsHash -Platform Linux, Windows

   # Or using pipes

   @('Linux', 'Windows') | Get-DownloadsHash
#>
