#!/bin/bash
# MARVEL: The Last Hero — Text Adventure for Linux Terminal
# Usage: bash marvel_en.sh

R='\033[91m'; G='\033[93m'; B='\033[94m'; GR='\033[92m'; C='\033[96m'
W='\033[96m'; D='\033[95m'; O='\033[38;5;214m'; BO='\033[1m'; RS='\033[0m'
PK='\033[38;5;213m'; LB='\033[38;5;123m'; LG='\033[38;5;118m'; YL='\033[38;5;226m'

# ── Game state ─────────────────────────────────────────────────────────────────
HP=100; MAX_HP=100; LOC="shield_entrance"; GANADO=0; MUERTO=0; INV="claw"
suelo_shield_entrance=""
suelo_shield_control="intel"
suelo_shield_armory="rifle potion"
suelo_tower_lobby=""
suelo_tower_meeting="tracker"
suelo_tower_lab="armor"
suelo_wakanda_plains=""
suelo_wakanda_throne="claw_extra"
suelo_wakanda_mines="ingot"
suelo_sancta_street=""
suelo_sancta_library="spellbook"
suelo_sancta_portals="gauntlet"
suelo_field_gate=""
suelo_field_center=""
suelo_field_shelter="shield"

# ── UI ─────────────────────────────────────────────────────────────────────────
pr()  { echo -e "  $1"; }
hr()  { echo -e "${PK}$(printf '─%.0s' $(seq 1 65))${RS}"; }
tit() { echo -e "\n${G}${BO}$(printf '═%.0s' $(seq 1 65))${RS}"
        echo -e "${G}${BO}$(printf '%*s' $(( (65 + ${#1}) / 2 )) "$1")${RS}"
        echo -e "${G}${BO}$(printf '═%.0s' $(seq 1 65))${RS}"; }

# ── ASCII Art ──────────────────────────────────────────────────────────────────
ascii_avengers() { echo -e "${R}   ▄████████▄\n  ████▀▀▀▀████\n  ████  ${G}A${R}  ████\n  ████     ████\n  ▀████▄▄████▀\n    ▀▀████▀▀\n${G}  AVENGERS TOWER${RS}"; }
ascii_shield()   { echo -e "${B}  ╔═══════════╗\n  ║${W} S.H.I.E.L.D${B} ║\n  ║   ${R}◉─────◉${B}  ║\n  ║   ${R}│  ▲  │${B}  ║\n  ║   ${R}│ ═╪═ │${B}  ║\n  ║   ${R}◉─────◉${B}  ║\n  ╚═══════════╝${RS}"; }
ascii_wakanda()  { echo -e "${D}    /\\  /\\  /\\\n   /WW\\/ K\\/ A\\\n  /  ${G}WAKANDA${D}  \\\n  \\___________/\n   ${C}║ VIBRANIUM ║\n   ╚═══╦════╝\n       ║${RS}"; }
ascii_stark()    { echo -e "${D}   ┌─────────────┐\n   │ ${R}♥${D}  ${G}ARC${D}     │\n   │   ${G}REACTOR${D}   │\n   │    ${C}◎◎◎${D}     │\n   │   ${C}◎ ◎ ◎${D}   │\n   │    ${C}◎◎◎${D}     │\n   └─────────────┘${RS}"; }
ascii_thanos()   { echo -e "${D}    ║▌║▌║║╠╬╬\n   ╔╩╦╩╦╩╦╩╗\n   ${R}║${G}T H A N O S${R}║\n   ${D}╠══${G}◈══◈${D}══╣\n   ║  ${G}∞∞∞∞${D}  ║\n   ╚════════╝\n  ${R}THE MAD TITAN${RS}"; }
ascii_strange()  { echo -e "${D}  ╔══════════════╗\n  ║  ${G}SANCTA${D}       ║\n  ║  ${G}SANCTORUM${D}    ║\n  ║   ${C}◎  ⊗  ◎${D}   ║\n  ║  ${G}EYE AGAMOTTO${D} ║\n  ╚══════════════╝${RS}"; }

show_ascii() { case "$1" in
  shield_entrance) ascii_shield ;;
  tower_lobby)     ascii_avengers ;;
  tower_lab)       ascii_stark ;;
  wakanda_plains)  ascii_wakanda ;;
  field_gate)      ascii_thanos ;;
  sancta_street)   ascii_strange ;;
esac; }

# ── Random responses ───────────────────────────────────────────────────────────
rand_error() {
  local m=("FRIDAY does not understand you. Try calling Doctor Strange."
    "Tony Stark: 'Great, I built an AI that does not understand English.'"
    "ERROR 616: Unknown command. Xavier already knew."
    "HULK SMASH KEYBOARD? That command makes no sense."
    "Loki: 'I don't know what you mean, but it sounds like chaos.'"
    "Wanda rewrote reality. She does not understand either."
    "S.H.I.E.L.D. logs unknown command. That is you, Fury."
    "Parker: 'Great power, great responsibility'... you have 0 of both."
    "Thor: 'Even ODIN would not understand your mortal words!'")
  pr "${R}${m[$(( RANDOM % ${#m[@]} ))]}${RS}"
}

# ── Zone data ──────────────────────────────────────────────────────────────────
zone_name() { case "$1" in
  shield_entrance) echo "S.H.I.E.L.D. HQ — Security Entrance" ;;
  shield_control)  echo "S.H.I.E.L.D. HQ — Control Room" ;;
  shield_armory)   echo "S.H.I.E.L.D. HQ — Classified Armory" ;;
  tower_lobby)     echo "Avengers Tower — Main Lobby" ;;
  tower_meeting)   echo "Avengers Tower — Meeting Room" ;;
  tower_lab)       echo "Avengers Tower — Stark Laboratory" ;;
  wakanda_plains)  echo "Wakanda — Plains" ;;
  wakanda_throne)  echo "Wakanda — Throne Room" ;;
  wakanda_mines)   echo "Wakanda — Vibranium Mines" ;;
  sancta_street)   echo "Sancta Sanctorum — Bleecker Street" ;;
  sancta_library)  echo "Sancta Sanctorum — Magic Library" ;;
  sancta_portals)  echo "Sancta Sanctorum — Portal Room" ;;
  field_gate)      echo "Battlefield — Gate of the Apocalypse" ;;
  field_center)    echo "Battlefield — Center" ;;
  field_shelter)   echo "Battlefield — Survivors Shelter" ;;
esac; }

zone_desc() { case "$1" in
  shield_entrance) echo "Biometric scanners everywhere. Agents in sunglasses watch you with suspicion. Even you, Nick Fury." ;;
  shield_control)  echo "Multiple screens display real-time threats. Coulson manages the chaos with a cup of coffee." ;;
  shield_armory)   echo "Experimental weapons everywhere. You see the Plasma Rifle and a 'Healing Potion — Dr. Strange'." ;;
  tower_lobby)     echo "The majestic lobby of Avengers Tower. Holographic screens display the latest global threats." ;;
  tower_meeting)   echo "A circular table with seats for every Avenger. The Captain tracker device sits on the table." ;;
  tower_lab)       echo "Dozens of Iron Man armor pieces line the walls. FRIDAY watches you. Smells of oil and caffeine." ;;
  wakanda_plains)  echo "Lush vegetation surrounds the hidden nation. Vibranium rhinos graze in the distance." ;;
  wakanda_throne)  echo "King T'Challa receives you formally. Walls celebrate the Black Panther historic victories." ;;
  wakanda_mines)   echo "Glowing purple metal fills the walls. You feel the constant hum of vibranium in your chest." ;;
  sancta_street)   echo "A Victorian building in Greenwich Village NYC. A circular window with the Eye of Agamotto glows." ;;
  sancta_library)  echo "Thousands of magic books float in the air. Wong offers you tea and disapproval simultaneously." ;;
  sancta_portals)  echo "Doctor Strange meditates here. Portals to unknown dimensions open and close at random." ;;
  field_gate)      echo "The sky is purple and red. Giant craters mark the earth. It smells of ozone and powerful magic." ;;
  field_center)    echo "THANOS waits here. Infinity Gauntlet on his fist. Complete cosmic indifference." ;;
  field_shelter)   echo "Remains of fallen heroes armor surround this place. A note from Thor: 'Go get the shield, friend.'" ;;
esac; }

# Exits: "direction:destination ..."
exits() { case "$1" in
  shield_entrance) echo "north:shield_control east:shield_armory south:wakanda_plains" ;;
  shield_control)  echo "south:shield_entrance east:shield_armory north:tower_lobby" ;;
  shield_armory)   echo "west:shield_control south:shield_entrance east:sancta_street" ;;
  tower_lobby)     echo "north:tower_meeting east:tower_lab south:shield_control" ;;
  tower_meeting)   echo "south:tower_lobby east:tower_lab" ;;
  tower_lab)       echo "west:tower_meeting south:tower_lobby" ;;
  wakanda_plains)  echo "north:shield_entrance east:wakanda_throne" ;;
  wakanda_throne)  echo "south:wakanda_plains east:wakanda_mines west:sancta_street" ;;
  wakanda_mines)   echo "west:wakanda_throne north:wakanda_plains" ;;
  sancta_street)   echo "north:sancta_library east:sancta_portals west:shield_armory south:wakanda_throne" ;;
  sancta_library)  echo "south:sancta_street east:sancta_portals" ;;
  sancta_portals)  echo "west:sancta_library south:sancta_street north:field_gate" ;;
  field_gate)      echo "north:field_center east:field_shelter south:sancta_portals" ;;
  field_center)    echo "south:field_gate east:field_shelter" ;;
  field_shelter)   echo "west:field_center south:field_gate" ;;
esac; }

# ── Items ──────────────────────────────────────────────────────────────────────
item_name() { case "$1" in
  claw)      echo "Vibranium Claw (T'Challa)" ;;
  claw_extra)echo "Extra Vibranium Claw" ;;
  armor)     echo "Iron Man Mark L Armor" ;;
  intel)     echo "Thanos Intelligence File" ;;
  rifle)     echo "S.H.I.E.L.D. Plasma Rifle" ;;
  potion)    echo "Healing Potion (Doctor Strange)" ;;
  tracker)   echo "Captain America Tracker" ;;
  ingot)     echo "Vibranium Ingot" ;;
  spellbook) echo "Doctor Strange Spell Book" ;;
  gauntlet)  echo "Broken Infinity Gauntlet" ;;
  shield)    echo "Captain America's Shield" ;;
  *)         echo "$1" ;;
esac; }

item_type() { case "$1" in
  rifle|claw|claw_extra|shield) echo "weapon" ;;
  armor)   echo "armor" ;;
  potion)  echo "potion" ;;
  *)       echo "key" ;;
esac; }

item_desc() { case "$1" in
  claw)     echo "Black Panther claws. Damage: 25. Pure Wakandan vibranium." ;;
  armor)    echo "Stark nanotechnology. +40 max HP when equipped." ;;
  intel)    echo "Classified S.H.I.E.L.D. intel on Thanos weaknesses." ;;
  rifle)    echo "Long-range weapon. Damage: 35. Very effective." ;;
  potion)   echo "Restores 50 HP. Prepared by Wong at Kamar-Taj." ;;
  tracker)  echo "Can locate Captain America's Shield." ;;
  ingot)    echo "Precious Wakandan metal. Most resistant material on Earth." ;;
  spellbook)echo "Crimson Bands of Cyttorak spell. Physically immobilizes enemies." ;;
  gauntlet) echo "Damaged version of the Gauntlet. Cannot be used anymore." ;;
  shield)   echo "The LEGENDARY vibranium weapon. Damage: 60. REQUIRED to defeat Thanos." ;;
esac; }

# ── Helpers ────────────────────────────────────────────────────────────────────
get_floor() { local v="suelo_${1//-/_}"; echo "${!v}"; }
set_floor()  { local v="suelo_${1//-/_}"; eval "${v}='${2}'"; }

has_item() { for x in $INV; do [[ "$x" == "$1" ]] && return 0; done; return 1; }

find_inv() {
  local q="${1,,}"
  for x in $INV; do
    local n; n=$(item_name "$x")
    [[ "${n,,}" == *"$q"* || "$x" == *"$q"* ]] && echo "$x" && return
  done
}

find_floor() {
  local q="${1,,}"
  for x in $(get_floor "$LOC"); do
    local n; n=$(item_name "$x")
    [[ "${n,,}" == *"$q"* || "$x" == *"$q"* ]] && echo "$x" && return
  done
}

status() {
  local f="Active"
  [[ $GANADO -eq 1 ]] && f="${GR}VICTORY!${RS}"
  [[ $MUERTO -eq 1 ]] && f="${R}GAME OVER${RS}"
  echo -e "\n${PK}${BO}  ❤  HP: ${GR}${BO}${HP}/${MAX_HP}${RS}${PK}${BO}  |  🕵  ${G}${BO}Nick Fury${RS}${PK}${BO}  |  Status: ${f}${RS}"
}

# ── COMMANDS ───────────────────────────────────────────────────────────────────
cmd_look() {
  hr
  pr "${G}${BO}📍 $(zone_name $LOC)${RS}"
  hr
  pr "${C}$(zone_desc $LOC)${RS}"
  echo; show_ascii "$LOC"; echo

  local s; s=$(get_floor "$LOC")
  if [[ -n "$s" ]]; then
    local list=""; for x in $s; do list="$list $(item_name $x),"; done
    pr "${G}You see here:${RS} ${G}${list%,}${RS}"
  fi

  [[ "$LOC" == "field_center" && $GANADO -eq 0 ]] && \
    pr "${R}${BO}⚠  THANOS BLOCKS YOUR PATH. You need Captain America's Shield!${RS}"

  local dirs=""
  for par in $(exits "$LOC"); do dirs="$dirs ${par%%:*}"; done
  pr "${YL}${BO}🧭 Exits:${RS} ${LB}${BO}$dirs${RS}"
}

cmd_go() {
  [[ -z "$1" ]] && pr "${R}Which direction?${RS}" && return
  local dir="$1"
  for par in $(exits "$LOC"); do
    local d="${par%%:*}"; local dest="${par##*:}"
    if [[ "$d" == "$dir" ]]; then
      LOC="$dest"; cmd_look; return
    fi
  done
  pr "${R}You cannot go ${dir} from here.${RS}"
}

cmd_explore() {
  pr "${G}You explore the area thoroughly...${RS}"
  echo; show_ascii "$LOC"; echo
  local s; s=$(get_floor "$LOC")
  if [[ -n "$s" ]]; then
    local list=""; for x in $s; do list="$list $(item_name $x),"; done
    pr "${GR}You find:${list%,}${RS}"
  else
    pr "There is nothing more to pick up here."
  fi
  [[ "$LOC" == "field_center" && $GANADO -eq 0 ]] && \
    pr "${R}Thanos watches you with the Gauntlet. His power is immeasurable.${RS}"
}

cmd_take() {
  [[ -z "$*" ]] && pr "${R}What do you want to take?${RS}" && return
  local id; id=$(find_floor "$*")
  [[ -z "$id" ]] && pr "${R}You can't find '${*}' here. Try exploring first.${RS}" && return

  local new=""
  for x in $(get_floor "$LOC"); do [[ "$x" != "$id" ]] && new="$new $x"; done
  set_floor "$LOC" "$(echo $new)"
  INV="$INV $id"

  if [[ $(item_type "$id") == "armor" ]]; then
    MAX_HP=$(( MAX_HP + 40 )); HP=$(( HP + 40 > MAX_HP ? MAX_HP : HP + 40 ))
    pr "${GR}You picked up: ${G}$(item_name $id)${RS}"
    pr "${GR}The armor protects you! +40 max HP. HP: ${HP}/${MAX_HP}${RS}"
  else
    pr "${GR}You picked up: ${G}$(item_name $id)${RS}"
    pr "${C}$(item_desc $id)${RS}"
  fi
  [[ "$id" == "shield" ]] && pr "${G}${BO}⚡ CAPTAIN AMERICA'S SHIELD! Now you can face Thanos!${RS}"
}

cmd_use() {
  [[ -z "$*" ]] && pr "${R}What item do you want to use?${RS}" && return
  local id; id=$(find_inv "$*")
  [[ -z "$id" ]] && pr "${R}You don't have '${*}' in your inventory.${RS}" && return
  case $(item_type "$id") in
    potion)
      HP=$(( HP + 50 > MAX_HP ? MAX_HP : HP + 50 ))
      local new=""; for x in $INV; do [[ "$x" != "$id" ]] && new="$new $x"; done; INV="$new"
      pr "${GR}You drink the ${G}$(item_name $id)${GR}. +50 HP! HP: ${HP}/${MAX_HP}${RS}" ;;
    weapon) pr "You brandish ${G}$(item_name $id)${RS} in the air. No enemy here." ;;
    *)      pr "You examine ${G}$(item_name $id)${RS}: $(item_desc $id)" ;;
  esac
}

cmd_examine() {
  [[ -z "$*" ]] && pr "${R}What do you want to examine?${RS}" && return
  local id; id=$(find_inv "$*")
  [[ -z "$id" ]] && pr "${R}You don't have '${*}' in your inventory.${RS}" && return
  pr "${G}$(item_name $id)${RS}: $(item_desc $id)"
}

cmd_inventory() {
  local clean; clean=$(echo $INV | xargs)
  [[ -z "$clean" ]] && pr "Inventory is empty. You are Fury, not Ant-Man." && return
  hr; pr "${G}${BO}🎒 INVENTORY${RS}"; hr
  for x in $INV; do
    [[ -z "$x" ]] && continue
    local ico; case $(item_type "$x") in weapon) ico="⚔";; armor) ico="🛡";; potion) ico="⚗";; *) ico="★";; esac
    pr "$ico ${YL}${BO}$(item_name $x)${RS} — ${C}$(item_desc $x)${RS}"
  done
}

cmd_attack() {
  [[ "$LOC" != "field_center" ]] && pr "${R}No enemy here. You are not the Punisher.${RS}" && return
  [[ $GANADO -eq 1 ]] && pr "${GR}Thanos has already been defeated.${RS}" && return
  [[ $MUERTO -eq 1 ]] && pr "${R}Game Over. Restart the script.${RS}" && return

  if ! has_item "shield"; then
    pr "${R}Your attacks do absolutely nothing to Thanos!${RS}"
    pr "${R}Thanos: 'Without Cap's Shield? Go find it first.'${RS}"
    HP=$(( HP - 20 ))
    pr "${R}Thanos hits you with the Gauntlet! -20 HP. HP: ${HP}/${MAX_HP}${RS}"
    if [[ $HP -le 0 ]]; then
      HP=0; hr
      pr "${R}${BO}You have been defeated by Thanos. The universe is doomed...${RS}"
      pr "${W}Restart the script to try again.${RS}"; hr; MUERTO=1
    fi
    return
  fi

  echo; hr
  pr "${G}${BO}⚡ FINAL COMBAT: Nick Fury vs Thanos ⚡${RS}"; hr
  pr "${O}You throw ${G}CAPTAIN AMERICA'S SHIELD${O} with full force!${RS}"
  pr "${O}The vibranium shatters the Infinity Gauntlet!${RS}"
  has_item "spellbook" && pr "${C}Crimson Bands of Cyttorak! Thanos is completely immobilized!${RS}"
  has_item "rifle"     && pr "${O}You fire the Plasma Rifle while Thanos is immobilized!${RS}"
  echo
  pr "${GR}${BO}🎊 THANOS DEFEATED! The Mad Titan falls to his knees.${RS}"
  pr "${W}${BO}Thanos: 'Respect... Perhaps the universe deserved to be saved...'${RS}"
  pr "${GR}The Gauntlet crumbles to cosmic dust. Reality is safe!${RS}"
  tit "         ★  TOTAL VICTORY  ★         "
  pr "${G}${BO}   Nick Fury has saved the Marvel universe!${RS}"
  tit "   MARVEL: The Last Hero — COMPLETED   "
  GANADO=1
}

cmd_help() {
  hr; pr "${G}${BO}📋 AVAILABLE COMMANDS${RS}"; hr
  pr "${G}go [north/south/east/west]${RS}  → Move between zones"
  pr "${G}look${RS}                        → Describe current zone"
  pr "${G}explore${RS}                     → Search zone for items"
  pr "${G}take [item]${RS}                 → Pick up an item from the floor"
  pr "${G}use [item]${RS}                  → Use an item from inventory"
  pr "${G}examine [item]${RS}              → See item details"
  pr "${G}attack${RS}                      → Attack the enemy here"
  pr "${G}inventory${RS}                   → Show your inventory"
  pr "${G}help${RS}                        → Show this list"
  pr "${G}exit${RS}                        → Quit the game"; hr
  pr "${G}MISSION:${RS} Get Cap's Shield and defeat Thanos."
}

# ── Parser ─────────────────────────────────────────────────────────────────────
run() {
  read -ra w <<< "$*"
  local v="${w[0],,}"; local a="${w[*]:1}"
  case "$v" in n|north) v="north";; s|south) v="south";; e|east) v="east";; w|west) v="west";; esac
  case "$v" in
    look|see|observe|l)                            cmd_look ;;
    go|move|walk)                                  cmd_go "$a" ;;
    north|south|east|west)                         cmd_go "$v" ;;
    explore|search|scan|investigate)               cmd_explore ;;
    take|get|pick|grab)                            cmd_take "$a" ;;
    use|drink|equip)                               cmd_use "$a" ;;
    examine|inspect|read)                          cmd_examine "$a" ;;
    attack|fight|hit|battle|strike)                cmd_attack ;;
    inventory|inv|i|bag)                           cmd_inventory ;;
    help|h|\?)                                     cmd_help ;;
    exit|quit|q) echo -e "\n${G}  Until next time, Agent Fury.${RS}\n"; exit 0 ;;
    "") ;;
    *) rand_error ;;
  esac
}

# ── Intro ──────────────────────────────────────────────────────────────────────
clear 2>/dev/null
tit "⚡  MARVEL: THE LAST HERO  ⚡"
echo
pr "${G}Year 2025. Thanos has returned with a partially repaired Infinity Gauntlet.${RS}"
pr "${G}You are ${YL}${BO}NICK FURY${RS}${G}, director of S.H.I.E.L.D. The only one who can stop him.${RS}"
pr "${G}Your mission: get the ${YL}${BO}Captain America's Shield${RS}${G} and defeat Thanos${RS}"
pr "${G}at the Final Battlefield.${RS}"
echo
pr "${PK}Type ${YL}${BO}help${RS}${PK} to see all available commands.${RS}"
echo; echo -e "${PK}${BO}  ⚡ [Press Enter to begin...] ⚡${RS}"; read -r
cmd_look

while true; do
  status
  echo -ne "${R}  FURY> ${RS}"
  read -r INPUT || break
  [[ -z "$INPUT" ]] && continue
  echo; run "$INPUT"; echo
done
