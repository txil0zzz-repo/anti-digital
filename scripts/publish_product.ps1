# ============================================================
# publish_product.ps1 -- Publish a Printify product to Etsy
# ============================================================
# USAGE:
#   .\publish_product.ps1 -ProductId "abc123def456"
# ============================================================

param(
    [Parameter(Mandatory=$true, HelpMessage="Product ID returned by create_product.ps1")]
    [string]$ProductId
)

. "$PSScriptRoot/config.ps1"

Write-Host "Publishing product $ProductId to Etsy..." -ForegroundColor Yellow

$body = @{
    title            = $true
    description      = $true
    images           = $true
    variants         = $true
    tags             = $true
    keyFeatures      = $false
    shipping_template = $false
} | ConvertTo-Json

try {
    Invoke-RestMethod `
        -Uri "$BASE_URL/shops/$SHOP_ID/products/$ProductId/publish.json" `
        -Headers $HEADERS `
        -Method POST `
        -Body $body | Out-Null

    Write-Host "Live on Etsy! Product: $ProductId" -ForegroundColor Green
    Write-Host "   Check: https://www.etsy.com/shop/ByTheFern" -ForegroundColor Cyan

} catch {
    Write-Host "Publish failed: $_" -ForegroundColor Red
    exit 1
}
