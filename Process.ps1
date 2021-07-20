Import-Module "C:\Users\peter\Desktop\MeuralCode\SlackFunctions.psm1" -Force
Import-Module "C:\Users\peter\Desktop\MeuralCode\MeuralFunctions.psm1" -Force
$Logfile = "C:\Users\peter\Desktop\MeuralCode\log.log"
$parameters = Get-Content "C:\Users\peter\Desktop\MeuralCode\parameters.json" | ConvertFrom-Json

##Slack API: https://api.slack.com/methods/files.list
##Meural API: https://documenter.getpostman.com/view/1657302/RVnWjKUL


$newimages = Slack-WatchChannel -tsfrom $parameters.timestamp
if (!($newimages.files)) {
	$logstring = "Now new images this run"
	Add-Content $Logfile -Value $logstring
	break
}

foreach ($newimage in $newimages.files) {

	$image = Slack-ParseImageData -data $newimage
	Slack-DownloadFile -filedl $image.dl -tempstorage $parameters.tempstorage

	$token = Meural-GetToken -username $parameters.username -password $parameters.password
	$response = Meural-UploadImage -token $token -filepath $parameters.tempstorage -filename $image.name

	$imageinfo = $response.data | ConvertTo-Json | ConvertFrom-Json
	$imageid = $imageinfo.id

	Meural-AddToGallery -token $token -itemid $imageid -galleryid 251641

	$newtimestamp = $image.ts + 1
	$oldtimestamp = $parameters.timestamp
	$parameters.timestamp = $image.ts
	$imagename = $image.name

	$logstring = "File found between $oldtimestamp and $newtimestamp - $imagename uploaded"

	Set-Content -Path "C:\Users\peter\Desktop\MeuralCode\parameters.json" -Value ($parameters | ConvertTo-Json) -Force
}

Remove-Item $parameters.tempstorage
