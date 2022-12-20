#Iniciate the output and input path 
$Input = 'C:\Temp\adusers2check.txt'
$Output = 'C:\Temp\output.csv'

#Clear previous output results

$filePath = 'C:\Temp\output.csv'

# Check if the file exists
if (Test-Path $filePath) {
  # The file exists, so delete it
  Remove-Item $filePath
}

# Get the list of users from the text file
$users = Get-Content $Input

# Initialize an empty array to store the results
$results = @()

# Loop through each user in the list
foreach ($user in $users) {
  # Initialize variables to store the values for the properties
  $displayName = $null
  $samAccountName = $null
  $lockedOut = $null
  $passwordLastSet = $null
  $passwordNeverExpires = $null
  $passwordExpiryTimeComputed = $null#[DateTime]::MinValue

  # Try to get the AD user object for the current user
  try {
    $adUser = Get-ADUser -Identity $user -Properties samAccountName, DisplayName, LockedOut, PasswordLastSet, PasswordNeverExpires, "msDS-UserPasswordExpiryTimeComputed"

    # Set the values for the properties
	$displayName = $adUser.DisplayName
	$samAccountName = $adUser.samAccountName
    $lockedOut = $adUser.LockedOut
    $passwordLastSet = $adUser.PasswordLastSet
    $passwordNeverExpires = $adUser.PasswordNeverExpires

    # Convert the msDS-UserPasswordExpiryTimeComputed property to a DateTime object
    $passwordExpiryTimeComputed = [System.DateTime]::FromFileTime($adUser.'msDS-UserPasswordExpiryTimeComputed')
  }
  catch {
    # An error occurred, so set the values to default values
	$displayName = $user
	$samAccountName = $user
    $lockedOut = $false
    $passwordLastSet = $null#[DateTime]::MinValue
    $passwordNeverExpires = $false
  }
  
# Initialize a variable to store the value for the expired property
$expired = $false

# Check if the passwordExpiryTimeComputed property is not null
if ($passwordExpiryTimeComputed -ne $null) {
  # Check if the passwordExpiryTimeComputed has passed the actual date
  if ($passwordExpiryTimeComputed -lt (Get-Date)) {
    # Set the expired property to true
    $expired = $true
  }
}
  # Create a new object with the properties we want to export
  $obj = New-Object -TypeName PSObject
  $obj | Add-Member -MemberType NoteProperty -Name 'DisplayName' -Value $displayName
  $obj | Add-Member -MemberType NoteProperty -Name 'samAccountName' -Value $samAccountName
  $obj | Add-Member -MemberType NoteProperty -Name 'LockedOut' -Value $lockedOut
  $obj | Add-Member -MemberType NoteProperty -Name 'PasswordLastSet' -Value $passwordLastSet
  $obj | Add-Member -MemberType NoteProperty -Name 'PasswordNeverExpires' -Value $passwordNeverExpires
  $obj | Add-Member -MemberType NoteProperty -Name 'PasswordExpiryTime' -Value $passwordExpiryTimeComputed
  $obj | Add-Member -MemberType NoteProperty -Name 'Expired' -Value $expired
  # Add the object to the results array
  $results += $obj
}

# Export the results to a CSV file
$results | Export-Csv $Output -NoTypeInformation