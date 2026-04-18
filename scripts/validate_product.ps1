# ============================================================
# validate_product.ps1 — Auditor de Regras de Negócio
# ============================================================
# Garante que um produto cumpre os padrões da anti DIGITAL
# antes de entrar no workflow de produção.
# ============================================================

param(
    [Parameter(Mandatory=$true)] [string]$ImagePath,
    [Parameter(Mandatory=$true)] [ValidateSet("TShirt", "Mug", "Poster")] [string]$ProductType,
    [Parameter(Mandatory=$false)] [int]$TargetPriceCents
)

# 1. Carregar Configurações e Regras
$configPath = Join-Path $PSScriptRoot "config.ps1"
if (-not (Test-Path $configPath)) {
    Write-Host "[!] Erro: Ficheiro de configuração não encontrado em $configPath" -ForegroundColor Red
    exit 1
}
. $configPath

Write-Host "`n--- [ RULE CHECKER: anti DIGITAL ] ---" -ForegroundColor Cyan

$allPassed = $true

# 2. Regra de Ficheiro (Existência e Formato)
Write-Host "Checking Design File..." -NoNewline
if (Test-Path $ImagePath) {
    $file = Get-Item $ImagePath
    if ($file.Extension -match "png|jpg|jpeg") {
        Write-Host " [OK] ($($file.Name))" -ForegroundColor Green
    } else {
        Write-Host " [FAIL] (Formato inválido: $($file.Extension))" -ForegroundColor Red
        $allPassed = $false
    }
} else {
    Write-Host " [FAIL] (Ficheiro não encontrado)" -ForegroundColor Red
    $allPassed = $false
}

# 3. Regra de Blueprint (Configuração)
Write-Host "Checking Blueprint Config..." -NoNewline
$blueprint = $null
switch ($ProductType) {
    "TShirt" { $blueprint = $TSHIRT }
    "Mug"    { $blueprint = $MUG_EU }
    "Poster" { $blueprint = $POSTER_EU }
}

if ($blueprint -and $blueprint.Blueprint -gt 0) {
    Write-Host " [OK] (BP: $($blueprint.Blueprint) | Provider: $($blueprint.Provider))" -ForegroundColor Green
} else {
    Write-Host " [FAIL] (Blueprint não configurado em config.ps1)" -ForegroundColor Red
    $allPassed = $false
}

# 4. Regra de Logística (EU Sourcing)
Write-Host "Checking EU Sourcing Rule..." -NoNewline
# Providers 30 (OPT OnDemand) e 99 (Printify Choice EU) são os nossos padrões
if ($blueprint.Provider -in @(30, 99)) {
    Write-Host " [OK] (Fulfillment Europeu confirmado)" -ForegroundColor Green
} else {
    Write-Host " [WARN] (Fornecedor fora do padrão EU sugerido)" -ForegroundColor Yellow
}

# 5. Regra de Preço (Margem de Lucro)
if ($PSBoundParameters.ContainsKey('TargetPriceCents')) {
    Write-Host "Checking Pricing Policy..." -NoNewline
    $expectedPrice = 0
    switch ($ProductType) {
        "TShirt" { $expectedPrice = $PRICES.TShirt }
        "Mug"    { $expectedPrice = $PRICES.Mug11oz } # Base reference
        "Poster" { $expectedPrice = $PRICES.PosterA4 } # Base reference
    }

    if ($TargetPriceCents -lt ($expectedPrice * 0.9)) {
        Write-Host " [FAIL] ($($TargetPriceCents)c é demasiado baixo! Mínimo sugerido: $($expectedPrice)c)" -ForegroundColor Red
        $allPassed = $false
    } else {
        Write-Host " [OK] (Preço competitivo)" -ForegroundColor Green
    }
}

# --- Conclusão ---
if ($allPassed) {
    Write-Host "`n[V] EXCELENTE: O produto cumpre todas as regras da Agência.`" -ForegroundColor Green -BackgroundColor Black
    exit 0
} else {
    Write-Host "`n[X] REJEITADO: O produto não cumpre os requisitos mínimos.`" -ForegroundColor Red -BackgroundColor Black
    exit 1
}
