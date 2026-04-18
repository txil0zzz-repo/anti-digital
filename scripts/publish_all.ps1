# ============================================================
# ByTheFern — Global Sync to Etsy
# Triggers a publish event for all products to push changes to Etsy
# ============================================================

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
. (Join-Path $PSScriptRoot "config.ps1")

Write-Host "🚀 Syncing all products to Etsy..." -ForegroundColor Cyan

# 1. Fetch all products
$productsUrl = "$BASE_URL/shops/$SHOP_ID/products.json"
$response = Invoke-RestMethod -Uri $productsUrl -Headers $HEADERS -Method Get
$products = $response.data

foreach ($p in $products) {
    $id = $p.id
    Write-Host "Syncing: $($p.title)" -ForegroundColor Gray
    
    # Trigger publish for Title, Description, and Tags
    $publishBody = @{
        title       = $true
        description = $true
        images      = $false # No need to re-upload images
        variants    = $true  # Extra safety for pricing
        tags        = $true
    } | ConvertTo-Json

    try {
        Invoke-RestMethod -Uri "$BASE_URL/shops/$SHOP_ID/products/$id/publish.json" -Headers $HEADERS -Method Post -Body $publishBody
    } catch {
        Write-Host "Failed to sync $id" -ForegroundColor Red
    }
}

Write-Host "✅ Global Sync triggered! Check your Etsy Shop Manager in a few minutes." -ForegroundColor Green
