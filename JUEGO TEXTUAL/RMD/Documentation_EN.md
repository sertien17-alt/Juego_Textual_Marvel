---
title: "MARVEL: The Last Hero"
subtitle: "Technical Documentation — Text Adventure Game"
author: "Game Development"
date: "`r format(Sys.Date(), '%B %d, %Y')`"
output:
  html_document:
    theme: darkly
    highlight: zenburn
    toc: true
    toc_float:
      collapsed: false
      smooth_scroll: true
    toc_depth: 3
    number_sections: true
    fig_caption: true
    df_print: kable
  pdf_document:
    toc: true
    toc_depth: 3
    number_sections: true
    highlight: tango
    fig_caption: true
    latex_engine: xelatex
geometry: "a4paper, margin=2.5cm"
fontsize: 11pt
lang: en
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(
  echo      = FALSE,
  warning   = FALSE,
  message   = FALSE,
  fig.align = "center",
  out.width = "100%",
  dpi       = 150
)
library(knitr)
```

---

# Introduction

**MARVEL: The Last Hero** is an interactive text adventure built entirely with **HTML5**, **CSS3**, and **vanilla JavaScript ES6+**, no external libraries required. The player takes the role of **Nick Fury**, director of S.H.I.E.L.D., with a single mission: recover Captain America's Shield and defeat Thanos before he destroys the universe.

The interface recreates a retro-futuristic terminal with monospace typography, Marvel red-and-gold color scheme, and a live sidebar panel showing game state. The entire game runs as a single self-contained HTML file in any modern browser.

```{r fig-start, fig.cap="**Figure 1.** Game start screen: narrative introduction, starting zone (S.H.I.E.L.D. HQ — Security Entrance), S.H.I.E.L.D. ASCII emblem, and sidebar panel with starting inventory."}
include_graphics("img/en_01_start.png")
```

## Technical Summary

| Parameter | Value |
|:----------|:------|
| **Genre** | Interactive text adventure |
| **Technology** | HTML5 / CSS3 / JavaScript ES6+ |
| **Dependencies** | None (Google Fonts optional) |
| **Setting** | Marvel Cinematic Universe |
| **Character** | Nick Fury — S.H.I.E.L.D. Director |
| **Objective** | Find Cap's Shield and defeat Thanos |
| **Version** | 2.0 — 2025 |

---

# World Structure

## The 5 Locations

The world has **5 main locations**, each with exactly **3 explorable zones** featuring unique descriptions, their own items, and cardinal exits.

```{r table-locs}
locs <- data.frame(
  N = 1:5,
  Location = c("Avengers Tower","S.H.I.E.L.D. HQ","Wakanda",
               "Sancta Sanctorum","Final Battlefield"),
  `Zone A` = c("Main Lobby","Security Entrance","Wakandan Plains",
               "Bleecker Street","Gate of Apocalypse"),
  `Zone B` = c("Meeting Room","Control Room","Throne Room",
               "Magic Library","Center (BOSS)"),
  `Zone C` = c("Tony Stark's Lab","Classified Armory","Vibranium Mines",
               "Portal Room","Shelter (KEY ITEM)"),
  check.names = FALSE
)
kable(locs, caption = "**Table 1.** The 5 locations and their 3 zones each.")
```

> The player starts at **S.H.I.E.L.D. HQ**, Security Entrance zone, with T'Challa's Vibranium Claw already in the inventory.

## Connection Map

```
        Avengers Tower
               |  north <-> south
        S.H.I.E.L.D. HQ  <-- east/west -->  Sancta Sanctorum  <-- north/south -->  Final Battlefield
               |  south <-> north                    |
            Wakanda  <-------  east/west  ------------+
```

---

# Exploration and Commands

## The explore command

`explore` searches for hidden items in the current zone and re-displays ASCII art if the zone has it. The following is a real screenshot of an exploration session at S.H.I.E.L.D. HQ:

```{r fig-explore, fig.cap="**Figure 2.** The `explore` command at the Security Entrance. The S.H.I.E.L.D. emblem ASCII art is shown again and available items in the zone are listed."}
include_graphics("img/en_02_explore.png")
```

## The Classified Armory

The Armory is a key zone containing the **S.H.I.E.L.D. Plasma Rifle** and the **Healing Potion**. Reached from the Control Room with `go east`:

```{r fig-armory, fig.cap="**Figure 3.** Classified Armory of S.H.I.E.L.D. HQ. The `explore` command reveals both available items: the Plasma Rifle and Doctor Strange's Healing Potion."}
include_graphics("img/en_03_armory.png")
```

## Command Reference

```{r table-cmds}
cmds <- data.frame(
  Command = c("go [dir.]","look","explore","take [item]",
              "use [item]","examine [item]","attack","inventory","help"),
  Synonyms = c("north/south/east/west directly",
               "l, observe, check",
               "search, scan, investigate",
               "pick, grab, get",
               "drink, equip, activate",
               "inspect, read, study",
               "fight, hit, battle, strike",
               "inv, i, bag",
               "h, ?, commands"),
  Description = c("Move between zones and locations",
                  "Describe current zone with exits and items",
                  "Search zone for hidden items",
                  "Pick up an item from the floor",
                  "Use an item from inventory",
                  "See details of an inventory item",
                  "Attack the enemy in this zone",
                  "Show full inventory contents",
                  "Show available command list"),
  check.names = FALSE
)
kable(cmds, caption = "**Table 2.** All available commands with accepted synonyms.")
```

---

# Inventory System

## Picking up items

`take [name]` picks items off the floor. The game uses partial name matching, so `take rifle` works the same as `take plasma rifle`.

```{r fig-inventory, fig.cap="**Figure 4.** The player picks up the Plasma Rifle and Healing Potion, then runs `inventory`. Each item shows its category icon (sword = weapon, shield = armor, flask = potion, star = key item) and full description."}
include_graphics("img/en_04_inventory.png")
```

## Full Item Catalog

```{r table-items}
items <- data.frame(
  Item = c("Vibranium Claw","S.H.I.E.L.D. Plasma Rifle",
           "Captain America's Shield (KEY)","Iron Man Mark L Armor",
           "Healing Potion","Captain's Tracker",
           "Thanos Intelligence","Vibranium Ingot",
           "Spell Book","Broken Gauntlet"),
  Type = c("Weapon","Weapon","Weapon","Armor","Potion",
           "Key","Key","Key","Key","Key"),
  `DMG/HP` = c(25,35,60,"+40","+50","—","—","—","—","—"),
  Location = c("Wakanda","S.H.I.E.L.D. HQ","Final Battlefield",
               "Avengers Tower","S.H.I.E.L.D. HQ",
               "Avengers Tower","S.H.I.E.L.D. HQ",
               "Wakanda","Sancta Sanctorum","Sancta Sanctorum"),
  Zone = c("Throne Room","Armory","Shelter","Stark's Lab","Armory",
           "Meeting Room","Control Room","Mines","Library","Portal Room"),
  check.names = FALSE
)
kable(items, caption = "**Table 3.** Full catalog of all 10 items with location and effect.")
```

---

# Random Responses

When the player types an unrecognized command, the game randomly picks one of **9 Marvel-themed responses** to maintain immersion:

```{r fig-error, fig.cap="**Figure 5.** Three consecutive random responses to unrecognized commands. Each references a different Marvel character (Tony Stark, Hulk, Wanda)."}
include_graphics("img/en_05_error.png")
```

```{r table-rand}
resp <- data.frame(
  N = 1:9,
  Character = c("FRIDAY","Tony Stark","Charles Xavier","Hulk","Loki",
                "Wanda Maximoff","Nick Fury","Peter Parker","Thor"),
  Response = c(
    "FRIDAY doesn't understand. Maybe call Doctor Strange.",
    "'Great, I built an AI and it doesn't understand English.'",
    "ERROR 616. Xavier was notified — but he already knew.",
    "HULK SMASH KEYBOARD? That command makes no sense.",
    "'Sounds like a great plan to cause chaos.'",
    "Wanda rewrote reality. She doesn't understand either.",
    "S.H.I.E.L.D. file sent to Nick Fury... which is you.",
    "'Great power, great responsibility'... you have 0 of both.",
    "Even ODIN wouldn't understand your mortal words."
  ),
  check.names = FALSE
)
kable(resp, caption = "**Table 4.** The 9 random responses and their associated Marvel character.")
```

---

# Combat System

## Getting Cap's Shield

**Captain America's Shield** is located in the **Shelter** zone of the Final Battlefield. Without it, no attack on Thanos works and each attempt costs **20 HP**.

```{r fig-shield, fig.cap="**Figure 6.** The player picks up Captain America's Shield in the Shelter. A special gold message appears. The sidebar updates the objective 'Find Cap's Shield' to completed."}
include_graphics("img/en_06_shield.png")
```

## The Final Battle

With the Shield in inventory, `attack` in the Battlefield Center triggers the victory sequence. The Spell Book and Rifle unlock extra dialogue:

```{r fig-victory, fig.cap="**Figure 7.** Final combat and victory screen. The Shield shatters the Gauntlet, the Spell Book activates Crimson Bands of Cyttorak, Thanos is defeated, and the TOTAL VICTORY screen appears."}
include_graphics("img/en_07_victory.png")
```

### Combat rules summary

| Situation | Result |
|:----------|:-------|
| `attack` without the Shield | Thanos immune — lose 20 HP — Game Over at 0 HP |
| `attack` with the Shield | Victory. Vibranium destroys the Gauntlet |
| + Spell Book | Immobilizing spell (extra dialogue) |
| + Plasma Rifle | Extra attack while Thanos is immobilized |

---

# Technical Architecture

## Technology Stack

```{r table-tech}
tech <- data.frame(
  Layer = c("Structure","Styles","Logic","Typography","Data","Input"),
  Technology = c("Semantic HTML5","CSS3 + Custom Properties",
                 "Vanilla JavaScript ES6+","Google Fonts (CDN)",
                 "JS literal objects","keydown event listener"),
  Detail = c("Single self-contained .html file",
             "Variables --red, --gold; dark terminal theme",
             "No frameworks or external libraries",
             "Orbitron (titles) + Share Tech Mono (text)",
             "WORLD, ITEMS, ASCII, state as JS constants",
             "Free-text parser with per-command synonyms"),
  check.names = FALSE
)
kable(tech, caption = "**Table 5.** Full technology stack of the game.")
```

## Code Structure

```javascript
// 1. GLOBAL CONSTANTS
const RAND  = [ /* 9 random responses */ ];
const ASCII = { avengers, shield, wakanda, stark, thanos, strange };
const WORLD = { /* 5 locations x 3 zones: exits, items, ascii */ };
const ITEMS = { /* 10 items: name, type, desc */ };

// 2. GAME STATE (mutable)
const G = {
  loc, zone,      // current position
  inv,            // array of owned item IDs
  hp, maxHp,      // hit points
  dead, won,      // game-over flags
  floor           // { "loc_zone": [ids] }
};

// 3. PRESENTATION FUNCTIONS
//    pr(txt, cls)  |  updatePanel()  |  describe()

// 4. COMMAND HANDLERS
//    cmdGo()  cmdTake()  cmdUse()  cmdExplore()
//    cmdAttack()  cmdInventory()  cmdHelp()

// 5. BOOTSTRAP
//    execute(raw)  →  parser: free text → action
//    init()        →  game initialization
```

---

# Optimal Playthrough Guide

```{r table-guide}
guide <- data.frame(
  Step = 1:6,
  Location = c("S.H.I.E.L.D. HQ","S.H.I.E.L.D. HQ",
               "Avengers Tower","Sancta Sanctorum",
               "Final Battlefield","Final Battlefield"),
  Zone = c("Armory","Armory","Stark's Lab","Library","Shelter","Center"),
  Command = c("take rifle","take potion","take armor",
              "take spell book","take shield","attack"),
  Result = c("+Weapon 35 dmg","+50 HP","+40 max HP",
             "Immobilizing spell","KEY ITEM","VICTORY"),
  check.names = FALSE
)
kable(guide, caption = "**Table 6.** Optimal playthrough. Steps 1-4 can be done in any order; step 5 must always precede step 6.")
```

---

# Conclusions

**MARVEL: The Last Hero** proves that a complete, visually compelling, and narratively coherent text adventure can be built using only standard web technologies. The modular JavaScript architecture makes it straightforward to extend with new locations, items, or enemies.

| Requirement | Status |
|:------------|:------:|
| 5 locations with 3 zones each | OK |
| Inventory with weapons, armor and potions | OK |
| 10 items distributed across the world | OK |
| Final boss requiring a specific item | OK |
| ASCII art in at least one zone per location | OK |
| 9 original random responses with Marvel characters | OK |
| Multiple synonyms per command | OK |
| Terminal interface with no external dependencies | OK |
| Live sidebar with real-time inventory and objectives | OK |

---

*Documentation generated with R Markdown · MARVEL: The Last Hero v2.0 · 2025*
