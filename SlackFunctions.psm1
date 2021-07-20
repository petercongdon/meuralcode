function Slack-GetHeaders {
    $headers = @{
        "Authorization" = "<>"
    }
    return $headers
}


function Slack-WatchChannel {
	param (
		[parameter(Mandatory = $true)][string] $tsfrom	
	)

    $headers = Slack-GetHeaders

    $result = Invoke-RestMethod -Uri "https://slack.com/api/files.list?channel=<>&count=100&ts_from=$tsfrom&types=images" -Method "GET" -Headers $headers
    $filets = $result.files.timestamp
    $filedl = $result.files.url_private_download
	return $result
}

function Slack-ParseImageData {
	param (
		[parameter(Mandatory = $true)][pscustomobject] $data	
	)
    $image = @{}
    $image.ts = $data.created
    $image.name = $data.name
    $image.h = $data.original_h
    $image.w = $data.original_w
    if ($image.h -gt $image.w) {
        $image.portrait = $true
    }
    $image.dl = $data.url_private
    return $image
}


function Slack-DownloadFile {
	param (
		[parameter(Mandatory = $true)][string] $filedl,
        [parameter(Mandatory = $true)][string] $tempstorage
	)
    $headers = Slack-GetHeaders
    
    $filebytes = Invoke-RestMethod -Uri "$filedl" -Method "GET" -Headers $headers -OutFile $tempstorage
    return $filebytes
}
