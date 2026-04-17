# ============================================================
# batch_upload.ps1 — Upload an entire folder of designs
# ============================================================
# USAGE:
#   .\batch_upload.ps1 -FolderPath "..\designs\tshirts" -Type tshirt
#   .\batch_upload.ps1 -FolderPath "..\designs\mugs" -Type mug -AutoPublish
#   .\batch_upload.ps1 -FolderPath "..\designs\posters" -Type poster -AutoPublish
#
# The -AutoPublish flag uploads AND publishes directly to Etsy.
# Without it, products are created as drafts (safe to review first).
#
# FILE NAMING: Name your design files as the product title.
#   Example: "ancient_library_vibes.png" → title "Ancient Library Vibes"
# ============================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$FolderPath,

    [Parameter(Mandatory=$true)]
    [ValidateSet("tshirt","mug","poster")]
    [string]$Type,

    [switch]$AutoPublish,

    [string]$DescriptionTemplate = ""
)

. "$PSScriptRoot/config.ps1"

# Resolve path
$resolvedPath = Resolve-Path $FolderPath -ErrorAction SilentlyContinue
if (-not $resolvedPath) {
    Write-Host "X Folder not found: $FolderPath" -ForegroundColor Red
    exit 1
}

$images = Get-ChildItem -Path $resolvedPath -File | Where-Object { $_.Extension -match "\.png$|\.jpg$|\.jpeg$" }

if ($images.Count -eq 0) {
    Write-Host "! No PNG/JPG images found in $FolderPath" -ForegroundColor Yellow
    exit 0
}

Write-Host "---------------------------------------------" -ForegroundColor DarkCyan
Write-Host "  ByTheFern Batch Upload" -ForegroundColor Cyan
Write-Host "  Found: $($images.Count) design(s) | Type: $Type" -ForegroundColor Cyan
if ($AutoPublish) {
    Write-Host "  > Auto-publish: ON (will go live on Etsy)" -ForegroundColor Green
} else {
    Write-Host "  > Auto-publish: OFF (creates drafts for review)" -ForegroundColor Yellow
}
Write-Host "---------------------------------------------" -ForegroundColor DarkCyan

$results = @()
$i = 0

foreach ($img in $images) {
    $i++
    $name = [System.IO.Path]::GetFileNameWithoutExtension($img.Name)

    # Convert filename to title (underscores/dashes → spaces → Title Case)
    $title = $name -replace "[_\-]", " "
    $title = (Get-Culture).TextInfo.ToTitleCase($title.ToLower())

    # Build description
    $typeLabel = switch ($Type) {
        "tshirt" { "t-shirt" }
        "mug"    { "mug" }
        "poster" { "art print / poster" }
    }

    $description = if ($DescriptionTemplate) {
        $DescriptionTemplate -replace "{title}", $title -replace "{type}", $typeLabel
    } else {
        "* $title`n`nA unique $typeLabel design celebrating nature, wildflowers and cottage living. Part of the ByTheFern collection - handcrafted aesthetics for the nature-loving soul.`n`n* Premium quality print`n* Ships from EU (Netherlands)`n* Perfect for cottagecore and botanical lovers`n`n- ByTheFern | Cottagecore & Botanical"
    }

    Write-Host "`n[$i/$($images.Count)] - $($img.Name)" -ForegroundColor Magenta

    # 1. Upload image
    $imageId = & "$PSScriptRoot/upload_image.ps1" -ImagePath $img.FullName
    if (-not $imageId) { Write-Host "  > Skipping (upload failed)" -ForegroundColor Red; continue }

    # 2. Create product
    $productId = & "$PSScriptRoot/create_product.ps1" `
        -ImageId $imageId `
        -Title $title `
        -Description $description `
        -Type $Type

    if (-not $productId) { Write-Host "  > Skipping (create failed)" -ForegroundColor Red; continue }

    # 3. Optionally publish
    if ($AutoPublish) {
        & "$PSScriptRoot/publish_product.ps1" -ProductId $productId
    }

    $results += [PSCustomObject]@{
        File      = $img.Name
        Title     = $title
        ProductId = $productId
        Published = $AutoPublish
    }

    Start-Sleep -Seconds 1  # Respect API rate limits
}

# Summary
Write-Host "`n---------------------------------------------" -ForegroundColor DarkCyan
Write-Host "  Done! $($results.Count)/$($images.Count) uploaded successfully" -ForegroundColor Green
$results | Format-Table -AutoSize
