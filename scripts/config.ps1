# ============================================================
# ByTheFern — Printify Config
# All IDs and pricing for the automation scripts
# ============================================================

$SHOP_ID = "27044983"
$API_KEY  = (Get-Content (Join-Path $PSScriptRoot "../.env") | Select-String "PRINTIFY_API_KEY").ToString().Split("=",2)[1]
$HEADERS  = @{ Authorization = "Bearer $API_KEY"; "Content-Type" = "application/json" }
$BASE_URL = "https://api.printify.com/v1"

# ── Product Blueprints & Providers ──────────────────────────
# T-Shirt: Bella+Canvas 3001 via Printify Choice (auto-picks best EU fulfillment)
$TSHIRT   = @{ Blueprint = 5;   Provider = 99 }
# Mug: Ceramic Mug (EU) via OPT OnDemand — ships from Netherlands 🇳🇱
$MUG_EU   = @{ Blueprint = 441; Provider = 30 }
# Poster: Posters (EU) via OPT OnDemand — ships from Netherlands 🇳🇱
$POSTER_EU = @{ Blueprint = 443; Provider = 30 }

# ── T-Shirt Variant IDs (Cottagecore colors, S–3XL) ─────────
$TSHIRT_VARIANTS = @{
    "White"         = @(17403, 17404, 17405, 17406, 17407, 17408)
    "Natural"       = @(17535, 17536, 17537, 17538, 17539, 17540)
    "HeatherGrey"   = @(17391, 17392, 17393, 17394, 17395, 17396)
    "SoftPink"      = @(17580, 17581, 17582, 17583, 17584, 17585)
    "ForestGreen"   = @(17472, 17473, 17474, 17475, 17476, 17477)
    "LightBlue"     = @(17520, 17521, 17522, 17523, 17524, 17525)
}
# Flat list of all variant IDs combined
$ALL_TSHIRT_IDS = $TSHIRT_VARIANTS.Values | ForEach-Object { $_ } | Sort-Object -Unique

# ── Mug Variant IDs (EU) ─────────────────────────────────────
$MUG_VARIANTS = @{ "11oz" = 62327; "15oz" = 62328 }

# ── Poster Variant IDs (EU, Matte finish) ────────────────────
$POSTER_VARIANTS = @{
    "A4" = 62339  # 11.7" x 16.5"
    "A3" = 62343  # 16.5" x 23.4"
    "A2" = 62345  # 23.4" x 33.1"
}

# ── Retail Prices (USD cents) ────────────────────────────────
# These are the prices YOUR CUSTOMERS pay on Etsy
$PRICES = @{
    TShirt   = 3400  # $34.00 — Added safety for Free plan + Ads
    Mug11oz  = 2100  # $21.00
    Mug15oz  = 2400  # $24.00
    PosterA4 = 2600  # $26.00
    PosterA3 = 3200  # $32.00
    PosterA2 = 4400  # $44.00
}

# ── Default Tags ─────────────────────────────────────────────
$DEFAULT_TAGS = @(
    "cottagecore", "botanical", "nature lover", "wildflower", "cottage decor",
    "botanical print", "floral art", "mushroom", "forest", "nature aesthetic"
)
