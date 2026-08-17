# Craftable: Paint Edition — Full Reference

This document lists every recipe added by this mod, along with the exact protective equipment recognized by the hazard system.

## Table of Contents

- [Recipes](#recipes)
  - [Slaked Lime](#slaked-lime)
  - [Primary Colors](#primary-colors)
  - [Secondary Colors](#secondary-colors)
  - [Wallpapers and More Paint Options — Extra Colors](#wallpapers-and-more-paint-options--extra-colors)
- [Protective Equipment](#protective-equipment)
  - [Rubber Gloves](#rubber-gloves)
  - [Safety Goggles](#safety-goggles)
  - [Mask](#mask)

---

## Recipes

All crafting times are in the vanilla in-game time unit (as used in `Time =` in the recipe script). All recipes use the `MixingBucket` timed action and the `InHandCraft` tag.

### Slaked Lime

| | |
|---|---|
| **Recipe ID** | `CraftSlakedLime` |
| **Category** | Miscellaneous (vanilla) |
| **Time** | 150 |

**Inputs**
- 1× `Base.Bucket` / `Base.BucketForged` / `Base.BucketEmpty` / `Base.BucketCarved` *(kept)*
- 0.6L Water in any container item
- 1× `Base.Quicklime`

**Output**
- 1× `Base.SlakedLime`

This is the mandatory first step — every paint recipe below requires Slaked Lime. Crafting this recipe without the right protective equipment is what triggers the [hazards](#protective-equipment) described further down.

---

### Primary Colors

All ten base colors are mixed directly in an empty paint bucket (`Base.PaintbucketEmpty`, destroyed on use), plus 1.5L (or 1.3L for Turquoise/Red) of Water in any container item.

| Recipe ID | Output | Time | Slaked Lime | Extra Ingredients | Tool Required |
|---|---|---|---|---|---|
| `MixPaintWhite` | `Base.PaintWhite` | 150 | 3 | — | — |
| `MixPaintBlack` | `Base.PaintBlack` | 170 | 2 | 1× `Base.Charcoal` / `Base.CharcoalCrafted` | Mortar & pestle |
| `MixPaintYellow` | `Base.PaintYellow` | 150 | 2 | 80× `Base.Mustard` | — |
| `MixPaintBlue` | `Base.PaintBlue` | 170 | 2 | 40× `Base.BerryBlue` | Mortar & pestle |
| `MixPaintPurple` | `Base.PaintPurple` | 170 | 2 | 20× `Base.BerryBlue` + 20× `Base.BerryBlack` | Mortar & pestle |
| `MixPaintGreen` | `Base.PaintGreen` | 170 | 2 | 40× `Base.Spinach` | Mortar & pestle |
| `MixPaintPink` | `Base.PaintPink` | 170 | 2 | 40× `Base.Strewberrie` | Mortar & pestle |
| `MixPaintTurquoise` | `Base.PaintTurquoise` | 170 | 2 | 2× vinegar (tag) + 2× `Base.CopperScrap` | File *(kept, may degrade)* |
| `MixPaintRed` | `Base.PaintRed` | 170 | 2 | 2× vinegar (tag) + 1× `Base.ScrapMetal` | File *(kept, may degrade)* |
| `MixPaintBrown` | `Base.PaintBrown` | 150 | 2 | 3× `Base.Clay` | — |

Turquoise and Red use 1.3L Water instead of 1.5L, to account for the vinegar volume.

---

### Secondary Colors

Secondary colors are mixed directly from existing paints — no Slaked Lime needed at this stage. Each has a normal version (mixed in an empty bucket) and a **Bulk** version (combining two full buckets directly, no empty bucket required, double output).

Unlike the primary colors, the exact item counts below are **recalculated dynamically at game boot** from the currently installed paint bucket's `UseDelta` — so any mod that changes how much surface a bucket of paint covers won't break these ratios. The percentages are the true, stable values; the counts shown assume the vanilla `UseDelta`.

| Recipe ID | Output | Ratio | Bulk Recipe ID | Bulk Output |
|---|---|---|---|---|
| `MixPaintGrey` | `Base.PaintGrey` | 50% White + 50% Black | `MixPaintGreyBulk` | 2× |
| `MixPaintOrange` | `Base.PaintOrange` | 50% Red + 50% Yellow | `MixPaintOrangeBulk` | 2× |
| `MixPaintCyan` | `Base.PaintCyan` | 50% Blue + 50% Green | `MixPaintCyanBulk` | 2× |
| `MixPaintLightBrown` | `Base.PaintLightBrown` | 30% Brown + 70% White | `MixPaintLightBrownBulk` | 2× |
| `MixPaintLightBlue` | `Base.PaintLightBlue` | 30% Blue + 70% White | `MixPaintLightBlueBulk` | 2× |

Time: 150 (normal) / 170 (bulk) for all five.

---

### Wallpapers and More Paint Options — Extra Colors

These recipes only appear in your crafting menu if the [Wallpapers and More Paint Options](https://steamcommunity.com/sharedfiles/filedetails/?id=2999595757) mod is active. Like the secondary colors above, ratios are fixed and percentages but final item counts are recalculated dynamically from `UseDelta` at game boot. Each color also has a Bulk variant (2× output, combining two full buckets).

| Recipe ID | Output | Ratio |
|---|---|---|
| `WallpapersMixPaintMagenta` | `Base.PaintMagenta` | 50% Red + 50% Blue |
| `WallpapersMixPaintDustBlue` | `Base.PaintDustBlue` | 70% Blue + 30% Grey |
| `WallpapersMixPaintDustGreen` | `Base.PaintDustGreen` | 70% Green + 30% Grey |
| `WallpapersMixPaintDustLilac` | `Base.PaintDustLilac` | 70% Purple + 30% Grey |
| `WallpapersMixPaintDustOrange` | `Base.PaintDustOrange` | 70% Orange + 30% Grey |
| `WallpapersMixPaintCamoGreen` | `Base.PaintCamoGreen` | 60% Green + 40% Brown |
| `WallpapersMixPaintMidGreen` | `Base.PaintMidGreen` | 85% Green + 15% White |
| `WallpapersMixPaintMidBlue` | `Base.PaintMidBlue` | 85% Blue + 15% White |
| `WallpapersMixPaintLightOrange` | `Base.PaintLightOrange` | 30% Orange + 70% White |
| `WallpapersMixPaintLightYellow` | `Base.PaintLightYellow` | 30% Yellow + 70% White |
| `WallpapersMixPaintIvory` | `Base.PaintIvory` | 90% White + 10% Yellow |
| `WallpapersMixPaintWine` | `Base.PaintWine` | 70% Red + 30% Black |
| `WallpapersMixPaintViolet` | `Base.PaintViolet` | 50% Blue + 50% Purple |
| `WallpapersMixPaintPeach` | `Base.PaintPeach` | 50% White + 30% Pink + 20% Orange |
| `WallpapersMixPaintDarkGrey` | `Base.PaintDarkGrey` | 70% Black + 30% White |
| `WallpapersMixPaintLime` | `Base.PaintLime` | 50% Yellow + 50% Green |
| `WallpapersMixPaintBeige` | `Base.PaintBeige` | 80% White + 20% Brown |

Each of these has a corresponding `...Bulk` recipe ID (e.g. `WallpapersMixPaintMagentaBulk`), Time 170, double output.

---

## Protective Equipment

Crafting Slaked Lime without the right gear triggers a hazard — see the mod's main description for details on hand burns, temporary blindness, and lung irritation. Each protection type is checked independently: the game only requires the item to be **equipped as clothing** (not just carried in your inventory) at the moment you craft.

Any item below counts — you only need one per category.

### Rubber Gloves
Prevents hand burns.
- Rubber Gloves `(Base.Gloves_Dish)`
- Surgical Gloves `(Base.Gloves_Surgical)`

### Safety Goggles
Prevents temporary blindness.
- Old Welding Goggles `(Base.Glasses_OldWeldingGoggles)`
- Safety Goggles `(Base.Glasses_SafetyGoggles)`
- Ski Goggles `(Base.Glasses_SkiGoggles)`
- Swimming Goggles `(Base.Glasses_SwimmingGoggles)`
- Welding Mask `(Base.WeldingMask)`
- Gas Mask (with or without filter) `(Base.Hat_GasMask`)`
- Improvised Gas Mask (with or without filter) `(Base.Hat_ImprovisedGasMak`)`
- Half Mask Separator (with or without filter) `(Base.Hat_BuilderRespirator)`

### Mask
Prevents lung irritation.
- Dust Mask `(Base.Mask_Dust)`
- Surgical Mask `(Base.Mask_Surgical)`
- Gas Mask (with filter but works with worn filters) `(Base.Hat_GasMask`)`
- Improvised Gas Mask (with filter but works with worn filters) `(Base.Hat_ImprovisedGasMak`)`
- Half Mask Separator (with filter but works with worn filters) `(Base.Hat_BuilderRespirator)`
