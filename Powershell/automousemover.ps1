########## Nuno Barros 15-04-2023 00:43:00 ver.1.0 ##########
<#
invoke this script using the following statement
.\automousemover.ps1 -Duration <Value in seconds for the duration of the script>

#>



param($Duration)

Function Move-MouseRandom {

    Param (
        [int]$DurationInSeconds
    )

    $EndTime = (Get-Date).AddSeconds($DurationInSeconds)

    do {
        Add-Type -AssemblyName System.Windows.Forms
        $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
        $X = Get-Random -Minimum 0 -Maximum 1920
        $Y = Get-Random -Minimum 0 -Maximum 1080
        [Windows.Forms.Cursor]::Position = "$($X),$($Y)"
        Start-Sleep -Seconds 10
    } while ((Get-Date) -lt $EndTime)

}

# Call the function aboove with the duration in seconds which was passed as parameter
Move-MouseRandom -DurationInSeconds $duration