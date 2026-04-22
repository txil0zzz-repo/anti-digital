# CLAUDE.md — BY THE FERN (SOPs)

This file provides strict guidance and **Standard Operating Procedures (SOPs)** for all AI Agents operating within the ByTheFern workspace (anti DIGITAL folder).

## 1. Brand Identity & Voice
- **Niche Focus**: Botanical Archivist, Cottagecore lifestyle.
- **Key Motifs**: Ferns, vintage botanical illustrations, parchment textures, cozy atmosphere.
- **Brand Voice**: Sophisticated, timeless, slightly nostalgic (e.g., "curated for the archivist's soul").

## 2. Standard Operating Procedures (Walkthroughs)

### 2.1. Product Ideation & Visual Alchemy (ComfyUI)
Generate botanical and archival visuals using the centralized ComfyUI engine.
- **Boot**: `comfy` (from powershell).
- **Aesthetic**: `botanical illustration, pressed flowers, vintage paper texture, archival ink, soft natural light, muted earth tones, 19th century nature study`.
- **Primary Model**: [Space for Suggestion]
- **Execution**: Provide the user with an SDXL/Flux prompt based on the aesthetic above. The user runs `comfy` and applies the prompt.

### 2.2. Printify & Etsy Publishing Pipeline
1. **Merchant Engine Logic**: All uploads go through Printify API.
2. **SEO Naming Formula**: Use strict Etsy SEO rules for variables: `[Primary Keyword] | [Secondary Concept] | [Aesthetic Type] - [Core Product]`. Example: `Vintage Fern Illustration | Botanical Print | Cottagecore Wall Art - Matte Canvas`.
3. **Fulfillment Validation**: Ensure the Printify script selects EU print providers by default unless overridden by the user.

## 3. Strict Operational Limitations
1. Assets go only to `../_assets/anti DIGITAL`. Never poll or push to Solène or global HQ folders.
2. Maintain standard Printify blueprint IDs in configs. DO NOT guess blueprint IDs.

## 4. AI Memory Protocol (Pinecone)
Whenever a significant script, brand styling, or Etsy SEO pattern is refined for ByTheFern, you MUST AUTOMATICALLY upsert a concise technical summary to the Pinecone MCP index (`ai-agency-brain`) under namespace `bythefern-operations`.
