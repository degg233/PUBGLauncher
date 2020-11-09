#SingleInstance, Force
#Persistent

SetBatchLines, -1

;Announce "installation"
msgBox, 49, PUBGLauncher, You are about to install PUBGLauncher.`n`nAre you sure you want to continue?
IfMsgBox, Cancel
{
    msgBox, 64, PUBGLauncher, You have chosen to not continue.`n`nInstaller will now exit.
    ExitApp
} 

;Set file properties
iconTarget := A_MyDocuments . "\PUBGLauncher\pubg.ico"
FileTarget := A_MyDocuments . "\PUBGLauncher\PUBGLauncher.ps1"
FileShortcutTarget := "powershell.exe -ExecutionPolicy Bypass -File """ . FileTarget . """"

;Create folder
FileCreateDir, %A_MyDocuments%\PUBGLauncher

;Download files
UrlDownloadToFile, https://raw.githubusercontent.com/OhMyGetFxcked/PUBGLauncher/master/src/PUBGLauncher.ps1, %FileTarget%
UrlDownloadToFile, https://raw.githubusercontent.com/OhMyGetFxcked/PUBGLauncher/master/src/pubg.ico, %iconTarget%

;Set details
target := "powershell.exe"
linkFile := A_Desktop . "\Launch PUBG.lnk"
startIn := A_MyDocuments . "\PUBGLauncher\"
args := "-ExecutionPolicy Bypass -File """ . FileTarget . """"
desc := "Deletes intro files and resets daily news"

;Create shortcut to Desktop
FileCreateShortcut, %target%, %linkFile%, %startIn%, %args%, %desc%, %iconTarget% 

;Notify user all is done
msgBox, 64, PUBGLauncher, Installation finished.`n`nShortcut is located on your desktop.

;Exit App
ExitApp