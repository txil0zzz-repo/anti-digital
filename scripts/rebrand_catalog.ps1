# ByTheFern - Catalog Rebranding Script
$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
. (Join-Path $PSScriptRoot "config.ps1")

Write-Host "Starting Catalog Rebranding..." -ForegroundColor Cyan

$productsUrl = "$BASE_URL/shops/$SHOP_ID/products.json"
$response = Invoke-RestMethod -Uri $productsUrl -Headers $HEADERS -Method Get
$products = $response.data

foreach ($p in $products) {
    $id = $p.id
    $oldTitle = $p.title
    $cleanName = $oldTitle -replace " - Premium Archival Matte.*", "" -replace " - Ceramic Mug.*", "" -replace " - Bella\+Canvas 3001.*", "" -replace " Cottage.*", ""
    
    $newTitle = ""
    $newDesc = ""
    
    if ($p.blueprint_id -eq $POSTER_EU.Blueprint) {
        $suffix = $id.Substring($id.Length - 4)
        $newTitle = "Archival $cleanName Print - No. $suffix | Vintage Botanical Art"
        $newDesc = @(
            "# ByTheFern - THE BOTANICAL ARCHIVIST",
            "",
            "Every print is a piece of nature. Preserving the silent whispers of the undergrowth through timeless botanical artistry. This specimen has been carefully restored and reproduced on museum-grade archival paper.",
            "",
            "### SPECIMEN DETAILS",
            "- **Title:** $cleanName",
            "- **Paper:** 230gsm Premium Archival Matte",
            "- **Inks:** Fade-resistant archival pigments",
            "- **Origin:** Hand-curated from historical botanical studies",
            "",
            "### SUSTAINABILITY & FULFILLMENT",
            "- **Produced in the EU:** All posters are printed and shipped from within the European Union for a lower carbon footprint and faster delivery.",
            "- **Plastic-Free Packaging:** Shipped in heavy-duty triangular mailing tubes for maximum protection.",
            "",
            "*Note: Frames are not included.*"
        ) -join "`n"
    }
    elseif ($p.blueprint_id -eq $TSHIRT.Blueprint) {
        $newTitle = "$cleanName Botanical Tee - Premium Organic Cotton"
        $newDesc = @(
            "# ByTheFern - THE BOTANICAL ARCHIVIST",
            "",
            "Wear the silent whispers of the undergrowth. This premium cotton tee features a carefully restored botanical specimen reproduced with high-definition eco-friendly inks.",
            "",
            "### SPECIMEN DETAILS",
            "- **Collection:** Botanical Archivist",
            "- **Garment:** Bella+Canvas 3001 (Premium Unisex Tee)",
            "- **Material:** 100% Airlume combed and ring-spun cotton",
            "- **Weight:** 142 g/m2 (Lightweight & Soft)",
            "",
            "### SUSTAINABILITY & FULFILLMENT",
            "- **Eco-Friendly Inks:** Water-based, non-toxic, and biodegradable.",
            "- **Printed on Demand:** Reduces overproduction and waste."
        ) -join "`n"
    }
    elseif ($p.blueprint_id -eq $MUG_EU.Blueprint) {
        $newTitle = "$cleanName Ceramic Specimen Mug - Botanical Collection"
        $newDesc = @(
            "# ByTheFern - THE BOTANICAL ARCHIVIST",
            "",
            "A morning companion for the nature seeker. This high-grade ceramic mug features a wrap-around botanical specimen, bringing the garden to your tea or coffee ritual.",
            "",
            "### SPECIMEN DETAILS",
            "- **Finish:** High-gloss ceramic",
            "- **Durability:** Dishwasher and microwave safe",
            "- **Size:** Available in 11oz and 15oz"
        ) -join "`n"
    }

    if ($newTitle -ne "") {
        Write-Host "Updating: $id" -ForegroundColor Gray
        $updateBody = @{
            title       = $newTitle
            description = $newDesc
            tags        = $DEFAULT_TAGS
        } | ConvertTo-Json -Depth 10
        try {
            Invoke-RestMethod -Uri "$BASE_URL/shops/$SHOP_ID/products/$id.json" -Headers $HEADERS -Method Put -Body $updateBody
        } catch {
            Write-Host "Failed to update $id" -ForegroundColor Red
        }
    }
}
Write-Host "Rebranding complete!" -ForegroundColor Green
