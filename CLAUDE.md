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

**MANDATORY:** Always run validation before any production task.
## 🌿 Branding Strategy: The Botanical Archivist
- **Core Aesthetic:** Premium Vintage Herbarium (Cottagecore Premium).
- **Colors:** Forest Green (#1B3022), Cream (#F5F5DC), Sage (#8A9A5B).
- **Pricing:** Protected margins ($26–$44 for posters) to absorb Etsy/Ads fees.
- **Copy:** Scholarly, archival, and scientific tone.

## 📦 POD Workflow (Printify-to-Etsy)
1. **Design:** Generate/Collect high-res botanical art.
2. **Validate:** Run `scripts/validate_product.ps1` before upload.
3. **Upload:** Use `scripts/batch_upload.ps1` (with automatic "Archivist" formatting).
4. **Rebrand:** Run `scripts/rebrand_catalog.ps1` if store-wide copy updates are needed.

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
