function Meural-GetToken {
	param (
		[parameter(Mandatory = $true)][string] $username,
		[parameter(Mandatory = $true)][string] $password		
	)
	$token = Invoke-RestMethod "https://api.meural.com/v0/authenticate" -Method 'POST' -Body "username=$username&password=$password"
	
	return $token.token
}


function Meural-UploadImage {
	param (
		[parameter(Mandatory = $true)][string] $token,
		[parameter(Mandatory = $true)][string] $filepath,
		[parameter(Mandatory = $true)][string] $filename
	)
	$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$headers.Add("Authorization", "Token $token")

	$multipartContent = [System.Net.Http.MultipartFormDataContent]::new()
	$FileStream = [System.IO.FileStream]::new($filepath, [System.IO.FileMode]::Open)
	$fileHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new("form-data")
	$fileHeader.Name = "image"
	$fileHeader.FileName = $filename
	$fileContent = [System.Net.Http.StreamContent]::new($FileStream)
	$fileContent.Headers.ContentDisposition = $fileHeader
	$multipartContent.Add($fileContent)
	$body = $multipartContent
	$response = Invoke-RestMethod "https://api.meural.com/v0/items" -Method 'POST' -Headers $headers -Body $body
	return $response
}


function Meural-AddToGallery {
	param (
		[parameter(Mandatory = $true)][string] $token,
		[parameter(Mandatory = $true)][string] $itemid,
		[parameter(Mandatory = $true)][string] $galleryid = "251641"
	)
	
	$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$headers.Add("Authorization", "Token $token")
	

	$response = Invoke-RestMethod "https://api.meural.com/v0/galleries/$galleryid/items/$itemid" -Method 'POST' -Headers $headers

}
