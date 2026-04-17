# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in this repository.

## Project Overview

**anti DIGITAL** covers all TEZ. revenue-generating products:
- **ByTheFern** — Print on Demand Etsy store (Cottagecore + Botanical)
- **Digital downloads** — Etsy planners, ADHD notebooks, budgeting sheets

## ByTheFern — POD

- **Etsy store**: ByTheFern
- **Printify Shop ID**: `27044983`
- **Printify API base**: `https://api.printify.com/v1`
- **Docs**: https://developers.printify.com

### Authentication

`.env` must contain:
```
PRINTIFY_API_KEY=<token>
```

### POD Workflow

```powershell
# Upload image → create product → publish
.\scripts\upload_image.ps1 -ImagePath "designs\cottagecore\posters\my_design.png"
.\scripts\create_product.ps1 -ImageId "<id>" -Title "My Design" -Description "..." -Type poster
.\scripts\publish_product.ps1 -ProductId "<id>"

# Batch upload full folder
.\scripts\batch_upload.ps1 -FolderPath "designs\cottagecore\posters" -Type poster -AutoPublish
```

### Product Config

All IDs and pricing in `scripts/config.ps1`.

| Product | Blueprint | Provider | Notes |
|---|---|---|---|
| T-Shirt (Bella+Canvas 3001) | 5 | 99 (Printify Choice) | 6 colors x S-3XL |
| Mug (EU Ceramic) | 441 | 30 (OPT OnDemand NL) | 11oz, 15oz |
| Poster (EU Matte) | 443 | 30 (OPT OnDemand NL) | A4, A3, A2 |

Always prefer EU fulfillment providers.

### ComfyUI — Design Generation

```bash
cd "C:/Users/txds/OneDrive/Ambiente de Trabalho/TEZ/anti TEZ/ComfyUI"
py main.py --lowvram
```
Open: `http://127.0.0.1:8188` — Model: DreamShaper v8, 768x1024, steps 30

## Digital Downloads

- **Tool**: Canva → export PDF
- **Save to**: `designs/planners/`, `designs/budgeting/`, `designs/adhd/`
- **Upload**: manually to Etsy as digital download
- **Price range**: 3-15 EUR
- **No Printify needed** — Etsy handles delivery automatically

## Folder Structure

```
anti DIGITAL/
├── designs/
│   ├── cottagecore/    — POD designs (posters, mugs, tshirts)
│   ├── planners/       — digital planner PDFs
│   ├── budgeting/      — budget tracker PDFs
│   └── adhd/           — ADHD planner PDFs
├── scripts/            — Printify automation (PowerShell)
├── listings/           — Etsy titles, descriptions, tags
└── templates/          — exported PDFs ready for upload
```
