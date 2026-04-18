# ============================================================
# fix_prices.ps1 — Correção de Preçário em Massa
# ============================================================

$configPath = "c:\Users\txds\OneDrive\Ambiente de Trabalho\TEZ\anti DIGITAL\scripts\config.ps1"
. $configPath

Write-Host "`n--- [ FIXING PRICES: anti DIGITAL ] ---" -ForegroundColor Cyan

try {
    $url = "$BASE_URL/shops/$SHOP_ID/products.json"
    $response = Invoke-RestMethod -Uri $url -Headers $HEADERS -Method GET
    $products = $response.data

    foreach ($p in $products) {
        $title = $p.title
        $productId = $p.id
        
        # Só processar Posters/Prints/Art por agora
        if ($title -notin @("*Mug*", "*Shirt*", "*Tee*") -and ($title -like "*Poster*" -or $title -like "*Print*" -or $title -like "*Art*")) {
            
            Write-Host "Updating Price for: $title ..." -NoNewline
            
            $updatedVariants = @()
            foreach ($v in $p.variants) {
                $newPrice = 0
                
                # Detetar tamanho no título da variante
                if ($v.title -like "*A4*" -or $v.title -like "*21x30*") { $newPrice = $PRICES.PosterA4 }
                elseif ($v.title -like "*A3*" -or $v.title -like "*30x40*") { $newPrice = $PRICES.PosterA3 }
                elseif ($v.title -like "*A2*" -or $v.title -like "*40x60*" -or $v.title -like "*50x70*") { $newPrice = $PRICES.PosterA2 }
                else { $newPrice = $PRICES.PosterA4 } # Fallback para o mais pequeno/standard

                if ($v.price -lt $newPrice) {
                    $updatedVariants += @{
                        id = $v.id
                        price = $newPrice
                    }
                }
            }

            if ($updatedVariants.Count -gt 0) {
                $body = @{ variants = $updatedVariants } | ConvertTo-Json -Depth 5
                try {
                    Invoke-RestMethod -Uri "$BASE_URL/shops/$SHOP_ID/products/$productId.json" `
                                     -Headers $HEADERS `
                                     -Method PUT `
                                     -Body $body
                    Write-Host " [FIXED]" -ForegroundColor Green
                } catch {
                    Write-Host " [FAILED: $($_.Exception.Message)]" -ForegroundColor Red
                }
            } else {
                Write-Host " [NO CHANGE NEEDED]" -ForegroundColor Gray
            }
        }
    }
    Write-Host "`nConcluído!" -ForegroundColor Cyan

} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}
