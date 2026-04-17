# ============================================================
# upload_image.ps1 — Upload a design to Printify image library
# ============================================================
# USAGE:
#   .\upload_image.ps1 -ImagePath "C:\path\to\design.png"
#
# RETURNS: image ID (string) — use this in create_product.ps1
# ============================================================

param(
    [Parameter(Mandatory=$true, HelpMessage="Path to the PNG/JPG design file")]
    [string]$ImagePath
)

. "$PSScriptRoot/config.ps1"

# Validate file exists
if (-not (Test-Path $ImagePath)) {
    Write-Host "X File not found: $ImagePath" -ForegroundColor Red
    exit 1
}

$fileName = Split-Path $ImagePath -Leaf
$ext = [System.IO.Path]::GetExtension($ImagePath).ToLower()

if ($ext -notin @(".png", ".jpg", ".jpeg")) {
    Write-Host "X Unsupported format. Use PNG or JPG." -ForegroundColor Red
    exit 1
}

Write-Host "> Uploading: $fileName ..." -ForegroundColor Yellow

$bytes  = [System.IO.File]::ReadAllBytes($ImagePath)
$base64 = [Convert]::ToBase64String($bytes)

$body = @{
    file_name = $fileName
    contents  = $base64
} | ConvertTo-Json -Depth 2

try {
    $response = Invoke-RestMethod `
        -Uri "$BASE_URL/uploads/images.json" `
        -Headers $HEADERS `
        -Method POST `
        -Body $body

    Write-Host "V Uploaded! Image ID: $($response.id)" -ForegroundColor Green
    return $response.id

} catch {
    Write-Host "X Upload failed: $_" -ForegroundColor Red
    exit 1
}
