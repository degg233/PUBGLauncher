# yeah this could probably be done a whole lot nicer
# but hey it works and it's good enough
# author: https://github.com/OhMyGetFxcked

# get steam install location
$steam = (Get-ItemProperty "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam" -Name "InstallPath")."InstallPath"

# declare function
Function Get-PUBG {
	Param ($p, $targetName)

	return Get-ChildItem $p -recurse | Where-Object {$_.PSIsContainer -eq $true -and $_.Name -match 'PUBG'} | % {
		return $_.FullName
	}
}

# check if location file exists
if (Test-Path "location.txt") {
	# get content
	$content = Get-Content "location.txt"
	
	# if location in file is invalid, set to false
	$location = if (Test-Path $location) { $location } Else { $false }
}

# if there's no saved location
if (-not $location) {
	# first check if pubg is just in the default directory
	$location = Get-PUBG "$steam\steamapps\common\"

	#if it's not, we go through library folders to find it
	if(-not $location) {
		# parse the library folders with regex
		$results = Get-Content "$steam\steamapps\libraryfolders.vdf" | Select-String -Pattern '(.:\\.*?)[^"]*' | Select Matches
		
		# go through all libraries
		foreach ($target in $results.Matches) {
			# test library path
			$location = Get-PUBG "$($target.value)\steamapps\common\"
			# break if found
			if($location) { break }
		}
	}

	$location | Out-File "location.txt"
}

# delete the intro files
Get-ChildItem -Path "$location\TslGame\Content\Movies" -Include *.* -File -Recurse | foreach { $_.Delete()}

# reset store date
$ini = "$env:USERPROFILE\AppData\Local\TslGame\Saved\Config\WindowsNoEditor\GameUserSettings.ini"
(Get-Content $ini) -replace "(?si)(^.*NEWS.*"").*("")", ('$1' + (Get-Date -format r) + '$2') | Set-Content $ini

# launch game
Start-Process (Get-Process -Name steam).path "-applaunch 578080"