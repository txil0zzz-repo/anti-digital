# anti TEZ — Print on Demand Agent

## Negócio

| Campo | Valor |
|---|---|
| Modelo | Print on Demand (POD) |
| Nicho | Cottagecore + Botanical |
| Loja | Etsy — **ByTheFern** |
| Fulfilment | Printify (fornecedores europeus) |
| Idioma das listagens | Inglês (mercado internacional) |

## Printify

| Campo | Valor |
|---|---|
| Shop ID | `27044983` |
| Ligação | ✅ conectado → Etsy (ByTheFern) |
| Documentação | https://developers.printify.com |

## Autenticação

Os tokens estão guardados em `.env`:

```
PRINTIFY_API_KEY=<token>
VERCEL_TOKEN=<token>
```

## Chamadas REST comuns

### Listar shops
```
GET /v1/shops.json
```

### Listar produtos
```
GET /v1/shops/{shop_id}/products.json
```

### Criar produto
```
POST /v1/shops/{shop_id}/products.json
```

### Publicar produto no Etsy
```
POST /v1/shops/{shop_id}/products/{product_id}/publish.json
```

### Listar variantes de um blueprint
```
GET /v1/catalog/blueprints/{blueprint_id}/print_providers/{provider_id}/variants.json
```

## Fornecedores europeus preferidos

Usar sempre fornecedores com localização na Europa para minimizar tempos de entrega e custos de envio para o mercado europeu.

## Estrutura do repositório

```
anti DIGITAL/
├── .env                          # tokens (não commitado)
├── .gitignore
├── AGENTS.md                     # este ficheiro
├── CLAUDE.md                     # guia para Claude Code
├── blueprints_full.json          # catálogo de blueprints Printify
├── designs/
│   ├── cottagecore/
│   │   ├── posters/              # designs para posters
│   │   ├── mugs/                 # designs para mugs
│   │   └── tshirts/              # designs para t-shirts
│   ├── planners/                 # planners digitais PDF
│   ├── budgeting/                # budget trackers PDF
│   └── adhd/                     # planners ADHD PDF
├── scripts/                      # automações PowerShell
│   ├── config.ps1                # IDs, preços, tags — editar aqui
│   ├── validate_product.ps1      # Audita regras antes de publicar
│   ├── upload_image.ps1
│   ├── create_product.ps1
│   ├── publish_product.ps1
│   └── batch_upload.ps1
├── listings/                     # títulos, descrições e tags Etsy
└── templates/                    # PDFs exportados prontos para upload
```

> ComfyUI (geração de designs) está instalado localmente em `anti TEZ/ComfyUI/`.  
> Gera os designs e guarda-os em `anti DIGITAL/designs/cottagecore/`.

## Objectivo

Automatizar via API REST Printify:
1. Validação de design e preço contra as regras de negócio
2. Upload de imagens de design para a biblioteca Printify
3. Criação de produtos com as variantes correctas (fornecedores EU)
4. Publicação directa no Etsy (ByTheFern)
