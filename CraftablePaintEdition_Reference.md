# Craftable: Paint Edition — Full Reference

This document lists every recipe added by this mod, along with the exact protective equipment recognized by the hazard system.

## Table of Contents

- [Recipes](#recipes)
  - [Slaked Lime](#slaked-lime)
  - [Improvised Garbage Bag Gloves](#improvised-garbage-bag-gloves)
  - [Primary Colors](#primary-colors)
  - [Secondary Colors](#secondary-colors)
  - [Wallpapers and More Paint Options — Extra Colors](#wallpapers-and-more-paint-options--extra-colors)
- [Protective Equipment](#protective-equipment)
  - [Rubber Gloves](#rubber-gloves)
  - [Leather Gloves (Sandbox Option)](#leather-gloves-sandbox-option)
  - [Safety Goggles](#safety-goggles)
  - [Mask](#mask)

---

## Recipes

All crafting times are in the vanilla in-game time unit (as used in `Time =` in the recipe script).

### Slaked Lime

| | |
|---|---|
| **Recipe** | Slake Lime (`CraftSlakedLime`) |
| **Category** | Miscellaneous (vanilla) |
| **Time** | 150 |
| **Tags** | InHandCraft |

**Inputs**
- 1× Bucket *(any type, kept)*
- 0.6L Water in any container item
- 1× Quicklime

**Output**
- 1× Slaked Lime

This is the mandatory first step — every paint recipe below requires Slaked Lime. Crafting this recipe without the right protective equipment is what triggers the [hazards](#protective-equipment) described further down.

---

### Improvised Garbage Bag Gloves

| | |
|---|---|
| **Recipe** | Making gloves from a garbage bag (`CraftGarbageBagGloves`) |
| **Category** | Tailoring |
| **Time** | 200 |
| **Tags** | AnySurfaceCraft |

**Inputs**
- 2× Garbage Bag
- 1× Duct Tape *(1 use)*

**Output**
- 1× Improvised Garbage Bag Gloves

A crude but effective alternative to real rubber gloves — protects your hands from lime burns just as well, since plastic doesn't soak up the caustic solution the way leather or fabric does. Always available, no Sandbox option needed to use it.

---

### Primary Colors

All ten base colors are mixed directly in an empty paint bucket (destroyed on use), plus 1.5L (or 1.3L for Turquoise/Red) of Water in any container item.

| Recipe | Output | Time | Slaked Lime | Extra Ingredients | Tool Required |
|---|---|---|---|---|---|
| Mix White Paint (`MixPaintWhite`) | Paint - White | 150 | 3 | — | — |
| Mix Black Paint (`MixPaintBlack`) | Paint - Black | 170 | 2 | 1× Charcoal / Wood Charcoal | Mortar & pestle |
| Mix Yellow Paint (`MixPaintYellow`) | Paint - Yellow | 150 | 2 | 80× Mustard | — |
| Mix Blue Paint (`MixPaintBlue`) | Paint - Blue | 170 | 2 | 40× Berries *(blue)* | Mortar & pestle |
| Mix Purple Paint (`MixPaintPurple`) | Paint - Purple | 170 | 2 | 20× Berries *(blue)* + 20× Berries *(black)* | Mortar & pestle |
| Mix Green Paint (`MixPaintGreen`) | Paint - Green | 170 | 2 | 40× Spinach | Mortar & pestle |
| Mix Pink Paint (`MixPaintPink`) | Paint - Pink | 170 | 2 | 40× Strawberries | Mortar & pestle |
| Mix Turquoise Paint (`MixPaintTurquoise`) | Paint - Turquoise | 170 | 2 | 2× vinegar (tag) + 2× Copper Scrap | File *(kept, may degrade)* |
| Mix Red Paint (`MixPaintRed`) | Paint - Red | 170 | 2 | 2× vinegar (tag) + 1× Scrap Metal | File *(kept, may degrade)* |
| Mix Brown Paint (`MixPaintBrown`) | Paint - Brown | 150 | 2 | 3× Clay | — |

Turquoise and Red use 1.3L Water instead of 1.5L, to account for the vinegar volume.

---

### Secondary Colors

Secondary colors are mixed directly from existing paints — no Slaked Lime needed at this stage. Each has a normal version (mixed in an empty bucket) and a **Bulk** version (combining two full buckets directly, no empty bucket required, double output).

Unlike the primary colors, the exact item counts below are **recalculated dynamically at game boot** from the currently installed paint bucket's `UseDelta` — so any mod that changes how much surface a bucket of paint covers won't break these ratios. The percentages are the true, stable values; the counts shown assume the vanilla `UseDelta`.

| Recipe | Output | Ratio | Bulk Recipe |
|---|---|---|---|
| Mix Gray Paint (`MixPaintGrey`) | Paint - Gray | 50% White + 50% Black | `MixPaintGreyBulk` |
| Mix Orange Paint (`MixPaintOrange`) | Paint - Orange | 50% Red + 50% Yellow | `MixPaintOrangeBulk` |
| Mix Cyan Paint (`MixPaintCyan`) | Paint - Cyan | 50% Blue + 50% Green | `MixPaintCyanBulk` |
| Mix Light Brown Paint (`MixPaintLightBrown`) | Paint - Light Brown | 30% Brown + 70% White | `MixPaintLightBrownBulk` |
| Mix Light Blue Paint (`MixPaintLightBlue`) | Paint - Light Blue | 30% Blue + 70% White | `MixPaintLightBlueBulk` |

Time: 150 (normal) / 170 (bulk) for all five. Bulk versions produce 2× output.

---

### Wallpapers and More Paint Options — Extra Colors

These recipes only appear in your crafting menu if the [Wallpapers and More Paint Options](https://steamcommunity.com/sharedfiles/filedetails/?id=2999595757) mod is active. Like the secondary colors above, ratios are fixed percentages but final item counts are recalculated dynamically from `UseDelta` at game boot. Each color also has a Bulk variant (2× output, combining two full buckets).

| Recipe | Ratio |
|---|---|
| Mix Magenta Paint (`WallpapersMixPaintMagenta`) | 50% Red + 50% Blue |
| Mix Dust Blue Paint (`WallpapersMixPaintDustBlue`) | 70% Blue + 30% Gray |
| Mix Dust Green Paint (`WallpapersMixPaintDustGreen`) | 70% Green + 30% Gray |
| Mix Dust Lilac Paint (`WallpapersMixPaintDustLilac`) | 70% Purple + 30% Gray |
| Mix Dust Orange Paint (`WallpapersMixPaintDustOrange`) | 70% Orange + 30% Gray |
| Mix Camo Green Paint (`WallpapersMixPaintCamoGreen`) | 60% Green + 40% Brown |
| Mix Mid Green Paint (`WallpapersMixPaintMidGreen`) | 85% Green + 15% White |
| Mix Mid Blue Paint (`WallpapersMixPaintMidBlue`) | 85% Blue + 15% White |
| Mix Light Orange Paint (`WallpapersMixPaintLightOrange`) | 30% Orange + 70% White |
| Mix Light Yellow Paint (`WallpapersMixPaintLightYellow`) | 30% Yellow + 70% White |
| Mix Ivory Paint (`WallpapersMixPaintIvory`) | 90% White + 10% Yellow |
| Mix Wine Paint (`WallpapersMixPaintWine`) | 70% Red + 30% Black |
| Mix Violet Paint (`WallpapersMixPaintViolet`) | 50% Blue + 50% Purple |
| Mix Peach Paint (`WallpapersMixPaintPeach`) | 50% White + 30% Pink + 20% Orange |
| Mix Dark Gray Paint (`WallpapersMixPaintDarkGrey`) | 70% Black + 30% White |
| Mix Lime Paint (`WallpapersMixPaintLime`) | 50% Yellow + 50% Green |
| Mix Beige Paint (`WallpapersMixPaintBeige`) | 80% White + 20% Brown |

Each of these has a corresponding Bulk recipe (e.g. `WallpapersMixPaintMagentaBulk`), Time 170, double output.

---

## Protective Equipment

Crafting Slaked Lime without the right gear triggers a hazard — see the mod's main description for details on hand burns, temporary blindness, and lung irritation. Each protection type is checked independently: the game only requires the item to be **equipped as clothing** (not just carried in your inventory) at the moment you craft.

Any item below counts — you only need one per category.

### Rubber Gloves
Prevents hand burns. Always active, regardless of Sandbox settings.
- Rubber Gloves `(Base.Gloves_Dish)`
- Surgical Gloves `(Base.Gloves_Surgical)`
- Improvised Garbage Bag Gloves `(Base.Gloves_GarbageBag)`

### Leather Gloves (Sandbox Option)
Also prevents hand burns, **only if the "Allow Leather Gloves for Hand Protection" Sandbox option is enabled** (off by default — not chemically realistic, offered purely for gameplay convenience). Fingerless gloves and thin fabric/dress gloves are intentionally excluded, no matter what the option says.
- Ice Hockey Gloves `(Base.Gloves_IceHockeyGloves_Blue)`
- Ice Hockey Gloves `(Base.Gloves_IceHockeyGloves_White)`
- Ice Hockey Gloves `(Base.Gloves_IceHockeyGloves_Black)`
- Ice Hockey Gloves `(Base.Gloves_IceHockeyGloves)`
- Leather Gloves `(Base.Gloves_LeatherGlovesBrown)`
- Leather Gloves `(Base.Gloves_LeatherGlovesBlack)`
- Leather Gloves `(Base.Gloves_LeatherGloves)`

### Safety Goggles
Prevents temporary blindness. The visor/lens keeps particles out of your eyes whether or not a gas mask's filter cartridge is installed.
- Old Welding Goggles `(Base.Glasses_OldWeldingGoggles)`
- Safety Goggles `(Base.Glasses_SafetyGoggles)`
- Ski Goggles `(Base.Glasses_SkiGoggles)`
- Swimming Goggles `(Base.Glasses_SwimmingGoggles)`
- Welder Mask `(Base.WeldingMask)`
- Gas Mask, with filter `(Base.Hat_GasMask)`
- Gas Mask, without filter `(Base.Hat_GasMask_nofilter)`
- Improvised Gas Mask, with filter `(Base.Hat_ImprovisedGasMask)`
- Improvised Gas Mask, without filter `(Base.Hat_ImprovisedGasMask_nofilter)`

### Mask
Prevents lung irritation. Unlike Safety Goggles above, the **filter cartridge must be present** — a mechanical/chemical filter is what actually stops the fine dust from being inhaled, the mask shell alone does nothing.
- Dust Mask `(Base.Hat_DustMask)`
- Surgical Mask `(Base.Hat_SurgicalMask)`
- Gas Mask, with filter only `(Base.Hat_GasMask)`
- Improvised Gas Mask, with filter only `(Base.Hat_ImprovisedGasMask)`
- Half Mask Respirator `(Base.Hat_BuildersRespirator)`