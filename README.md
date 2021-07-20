# Meural/Slack Sync

- Requires PS7 for [System.Net.Http.MultipartFormDataContent] construction
- Parameters file has sensitive information redacted (obviously)


#### Basic Overview

Windows task scheduler runs Process.ps1 every 15 minutes ("C:\Program Files\PowerShell\7\pwsh.exe" -File "C:\\\\<path>\\Process.ps1")
Parameters are imported from parameters.json

Program connects to Slack via `slacktoken` and watches the channelid defined by `channel` for new images created after `timestamp`
If new images are found, it downloads them (up to a limit of 100 images) into `tempstorage`
Program then connects to Meural using `username` and `password` and uploads the images
The entire process is serial and will loop based on the number of new images

Failure conditions
- My PC is off
- Internet connection loss
- The temporary storage doesn't have enough disk space to hold the image
- The scheduled task runs for longer than 1 hour
