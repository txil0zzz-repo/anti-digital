# ============================================================
# create_product.ps1 — Create a product on Printify
# ============================================================
# USAGE:
#   .\create_product.ps1 -ImageId "abc123" -Title "My Design" -Description "..." -Type tshirt
#   .\create_product.ps1 -ImageId "abc123" -Title "My Mug" -Description "..." -Type mug
#   .\create_product.ps1 -ImageId "abc123" -Title "My Poster" -Description "..." -Type poster
#
# RETURNS: product ID (string) — use this in publish_product.ps1
# ============================================================

param(
    [Parameter(Mandatory=$true)]  [string]$ImageId,
    [Parameter(Mandatory=$true)]  [string]$Title,
    [Parameter(Mandatory=$true)]  [string]$Description,
    [Parameter(Mandatory=$true)]  [ValidateSet("tshirt","mug","poster")] [string]$Type,
    [string[]]$Tags = @()
)

. "$PSScriptRoot/config.ps1"

# Merge custom tags with defaults (Etsy max = 13 tags)
$allTags = ($Tags + $DEFAULT_TAGS) | Select-Object -Unique | Select-Object -First 13

Write-Host "`n> Creating $Type - '$Title'" -ForegroundColor Yellow

switch ($Type) {

    "tshirt" {
        $blueprint = $TSHIRT.Blueprint
        $provider  = $TSHIRT.Provider

        $variants = $ALL_TSHIRT_IDS | ForEach-Object {
            @{ id = [int]$_; price = $PRICES.TShirt; is_enabled = $true }
        }

        $printAreas = @(
            @{
                variant_ids  = @($ALL_TSHIRT_IDS | ForEach-Object { [int]$_ })
                placeholders = @(
                    @{
                        position = "front"
                        images   = @(
                            @{ id = $ImageId; x = 0.5; y = 0.5; scale = 1.0; angle = 0 }
                        )
                    }
                )
            }
        )
    }

    "mug" {
        $blueprint = $MUG_EU.Blueprint
        $provider  = $MUG_EU.Provider

        $variants = @(
            @{ id = $MUG_VARIANTS["11oz"]; price = $PRICES.Mug11oz; is_enabled = $true }
            @{ id = $MUG_VARIANTS["15oz"]; price = $PRICES.Mug15oz; is_enabled = $true }
        )

        $printAreas = @(
            @{
                variant_ids  = @($MUG_VARIANTS["11oz"], $MUG_VARIANTS["15oz"])
                placeholders = @(
                    @{
                        position = "front"
                        images   = @(
                            @{ id = $ImageId; x = 0.5; y = 0.5; scale = 1.0; angle = 0 }
                        )
                    }
                )
            }
        )
    }

    "poster" {
        $blueprint = $POSTER_EU.Blueprint
        $provider  = $POSTER_EU.Provider

        $variants = @(
            @{ id = $POSTER_VARIANTS["A4"]; price = $PRICES.PosterA4; is_enabled = $true }
            @{ id = $POSTER_VARIANTS["A3"]; price = $PRICES.PosterA3; is_enabled = $true }
            @{ id = $POSTER_VARIANTS["A2"]; price = $PRICES.PosterA2; is_enabled = $true }
        )

        $printAreas = @(
            @{
                variant_ids  = @($POSTER_VARIANTS["A4"], $POSTER_VARIANTS["A3"], $POSTER_VARIANTS["A2"])
                placeholders = @(
                    @{
                        position = "front"
                        images   = @(
                            @{ id = $ImageId; x = 0.5; y = 0.5; scale = 1.0; angle = 0 }
                        )
                    }
                )
            }
        )
    }
}

$body = @{
    title             = $Title
    description       = $Description
    blueprint_id      = $blueprint
    print_provider_id = $provider
    variants          = $variants
    print_areas       = $printAreas
    tags              = $allTags
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod `
        -Uri "$BASE_URL/shops/$SHOP_ID/products.json" `
        -Headers $HEADERS `
        -Method POST `
        -Body $body

    Write-Host "V Product created! ID: $($response.id)" -ForegroundColor Green
    return $response.id

} catch {
    Write-Host "X Failed to create product: $_" -ForegroundColor Red
    Write-Host $body
    exit 1
}
