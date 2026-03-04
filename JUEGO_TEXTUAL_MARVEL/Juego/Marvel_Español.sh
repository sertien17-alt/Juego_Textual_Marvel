#!/bin/bash
# MARVEL: El Último Héroe — Aventura Textual para Linux
# Uso: bash marvel_es.sh

R='\033[91m'; G='\033[93m'; B='\033[94m'; GR='\033[92m'; C='\033[96m'
W='\033[96m'; D='\033[95m'; O='\033[38;5;214m'; BO='\033[1m'; RS='\033[0m'
PK='\033[38;5;213m'; LB='\033[38;5;123m'; LG='\033[38;5;118m'; YL='\033[38;5;226m'

# ── Estado ─────────────────────────────────────────────────────────────────────
HP=100; MAX_HP=100; LOC="shield_entrada"; GANADO=0; MUERTO=0; INV="garra"
suelo_shield_entrada=""
suelo_shield_control="intel"
suelo_shield_armeria="rifle pocion"
suelo_torre_lobby=""
suelo_torre_reuniones="rastreador"
suelo_torre_lab="armadura"
suelo_wakanda_llanuras=""
suelo_wakanda_trono="garra_extra"
suelo_wakanda_minas="lingote"
suelo_sancta_calle=""
suelo_sancta_biblioteca="libro"
suelo_sancta_portales="guantelete"
suelo_campo_puerta=""
suelo_campo_centro=""
suelo_campo_refugio="escudo"

# ── UI ─────────────────────────────────────────────────────────────────────────
pr()  { echo -e "  $1"; }
hr()  { echo -e "${PK}$(printf '─%.0s' $(seq 1 65))${RS}"; }
tit() { echo -e "\n${G}${BO}$(printf '═%.0s' $(seq 1 65))${RS}"
        echo -e "${G}${BO}$(printf '%*s' $(( (65 + ${#1}) / 2 )) "$1")${RS}"
        echo -e "${G}${BO}$(printf '═%.0s' $(seq 1 65))${RS}"; }

# ── ASCII ──────────────────────────────────────────────────────────────────────
ascii_avengers() { echo -e "${R}   ▄████████▄\n  ████▀▀▀▀████\n  ████  ${G}A${R}  ████\n  ████     ████\n  ▀████▄▄████▀\n    ▀▀████▀▀\n${G}  AVENGERS TOWER${RS}"; }
ascii_shield()   { echo -e "${B}  ╔═══════════╗\n  ║${W} S.H.I.E.L.D${B} ║\n  ║   ${R}◉─────◉${B}  ║\n  ║   ${R}│  ▲  │${B}  ║\n  ║   ${R}│ ═╪═ │${B}  ║\n  ║   ${R}◉─────◉${B}  ║\n  ╚═══════════╝${RS}"; }
ascii_wakanda()  { echo -e "${D}    /\\  /\\  /\\\n   /WW\\/ K\\/ A\\\n  /  ${G}WAKANDA${D}  \\\n  \\___________/\n   ${C}║ VIBRANIUM ║\n   ╚═══╦════╝\n       ║${RS}"; }
ascii_stark()    { echo -e "${D}   ┌─────────────┐\n   │ ${R}♥${D}  ${G}ARC${D}     │\n   │   ${G}REACTOR${D}   │\n   │    ${C}◎◎◎${D}     │\n   │   ${C}◎ ◎ ◎${D}   │\n   │    ${C}◎◎◎${D}     │\n   └─────────────┘${RS}"; }
ascii_thanos()   { echo -e "${D}    ║▌║▌║║╠╬╬\n   ╔╩╦╩╦╩╦╩╗\n   ${R}║${G}T H A N O S${R}║\n   ${D}╠══${G}◈══◈${D}══╣\n   ║  ${G}∞∞∞∞${D}  ║\n   ╚════════╝\n  ${R}EL TITÁN LOCO${RS}"; }
ascii_strange()  { echo -e "${D}  ╔══════════════╗\n  ║  ${G}SANCTA${D}       ║\n  ║  ${G}SANCTORUM${D}    ║\n  ║   ${C}◎  ⊗  ◎${D}   ║\n  ║  ${G}OJO AGAMOTTO${D} ║\n  ╚══════════════╝${RS}"; }

mostrar_ascii() { case "$1" in
  shield_entrada)   ascii_shield ;;
  torre_lobby)      ascii_avengers ;;
  torre_lab)        ascii_stark ;;
  wakanda_llanuras) ascii_wakanda ;;
  campo_puerta)     ascii_thanos ;;
  sancta_calle)     ascii_strange ;;
esac; }

# ── Respuestas aleatorias ──────────────────────────────────────────────────────
rand_error() {
  local m=("FRIDAY no entiende. Llama al Doctor Strange."
    "Tony Stark: 'Genial, una IA que no entiende el castellano.'"
    "ERROR 616: Orden desconocida. Xavier ya lo sabía."
    "¿Hulk GOLPEAR teclado? Ese comando no tiene sentido."
    "Loki: 'No sé qué dices, pero suena a sembrar el caos.'"
    "Wanda reescribió la realidad. Tampoco lo entiende."
    "S.H.I.E.L.D. registra orden desconocida. Eres tú, Fury."
    "Parker: 'Gran poder, gran responsabilidad'... tú tienes 0."
    "Thor: '¡ODÍN tampoco entendería tus palabras mortales!'")
  pr "${R}${m[$(( RANDOM % ${#m[@]} ))]}${RS}"
}

# ── Datos de zona ──────────────────────────────────────────────────────────────
nombre_zona() { case "$1" in
  shield_entrada)    echo "Sede S.H.I.E.L.D. — Entrada de Seguridad" ;;
  shield_control)    echo "Sede S.H.I.E.L.D. — Sala de Control" ;;
  shield_armeria)    echo "Sede S.H.I.E.L.D. — Armería Clasificada" ;;
  torre_lobby)       echo "Torre Vengadores — Vestíbulo Principal" ;;
  torre_reuniones)   echo "Torre Vengadores — Sala de Reuniones" ;;
  torre_lab)         echo "Torre Vengadores — Laboratorio de Stark" ;;
  wakanda_llanuras)  echo "Wakanda — Llanuras" ;;
  wakanda_trono)     echo "Wakanda — Sala del Trono" ;;
  wakanda_minas)     echo "Wakanda — Minas de Vibranium" ;;
  sancta_calle)      echo "Sancta Sanctorum — Calle Bleecker" ;;
  sancta_biblioteca) echo "Sancta Sanctorum — Biblioteca Mágica" ;;
  sancta_portales)   echo "Sancta Sanctorum — Sala de los Portales" ;;
  campo_puerta)      echo "Campo de Batalla — Puerta del Apocalipsis" ;;
  campo_centro)      echo "Campo de Batalla — Centro" ;;
  campo_refugio)     echo "Campo de Batalla — Refugio" ;;
esac; }

desc_zona() { case "$1" in
  shield_entrada)    echo "Escáneres biométricos por todas partes. Agentes con gafas de sol te miran con sospecha. Incluso a ti, Nick Fury." ;;
  shield_control)    echo "Múltiples pantallas muestran amenazas en tiempo real. Coulson gestiona el caos con una taza de café." ;;
  shield_armeria)    echo "Armas experimentales por todas partes. Ves el Rifle de Plasma y una 'Poción de Curación — Dr. Strange'." ;;
  torre_lobby)       echo "El majestuoso vestíbulo de la Torre. Pantallas holográficas muestran las últimas amenazas mundiales." ;;
  torre_reuniones)   echo "Mesa circular con sillas para cada Vengador. El rastreador del Capitán está sobre la mesa." ;;
  torre_lab)         echo "Docenas de piezas de armadura Iron Man cubren las paredes. FRIDAY te observa. Huele a aceite y cafeína." ;;
  wakanda_llanuras)  echo "Exuberante vegetación rodea la nación oculta. Rinocerontes de vibranium pastan a lo lejos." ;;
  wakanda_trono)     echo "El Rey T'Challa te recibe formalmente. Las paredes celebran las victorias de la Pantera Negra." ;;
  wakanda_minas)     echo "Metal luminoso púrpura invade las paredes. Sientes el zumbido constante del vibranium." ;;
  sancta_calle)      echo "Un edificio victoriano en el Greenwich Village. La ventana circular con el Ojo de Agamotto brilla." ;;
  sancta_biblioteca) echo "Miles de libros de magia flotan en el aire. Wong te ofrece té y desaprobación simultáneamente." ;;
  sancta_portales)   echo "El Doctor Strange medita. Portales a dimensiones desconocidas se abren y cierran al azar." ;;
  campo_puerta)      echo "El cielo es púrpura y rojo. Cráteres gigantes marcan la tierra. Huele a ozono y magia poderosa." ;;
  campo_centro)      echo "THANOS te espera. Con el Guantelete del Infinito en el puño. Indiferencia cósmica total." ;;
  campo_refugio)     echo "Restos de armaduras de héroes caídos. Una nota de Thor: 'Ve a por el escudo, amigo.'" ;;
esac; }

# Salidas: "dir:destino ..."  (destino = zona completa loc_zona)
salidas() { case "$1" in
  shield_entrada)    echo "norte:shield_control este:shield_armeria sur:wakanda_llanuras" ;;
  shield_control)    echo "sur:shield_entrada este:shield_armeria norte:torre_lobby" ;;
  shield_armeria)    echo "oeste:shield_control sur:shield_entrada este:sancta_calle" ;;
  torre_lobby)       echo "norte:torre_reuniones este:torre_lab sur:shield_control" ;;
  torre_reuniones)   echo "sur:torre_lobby este:torre_lab" ;;
  torre_lab)         echo "oeste:torre_reuniones sur:torre_lobby" ;;
  wakanda_llanuras)  echo "norte:shield_entrada este:wakanda_trono" ;;
  wakanda_trono)     echo "sur:wakanda_llanuras este:wakanda_minas oeste:sancta_calle" ;;
  wakanda_minas)     echo "oeste:wakanda_trono norte:wakanda_llanuras" ;;
  sancta_calle)      echo "norte:sancta_biblioteca este:sancta_portales oeste:shield_armeria sur:wakanda_trono" ;;
  sancta_biblioteca) echo "sur:sancta_calle este:sancta_portales" ;;
  sancta_portales)   echo "oeste:sancta_biblioteca sur:sancta_calle norte:campo_puerta" ;;
  campo_puerta)      echo "norte:campo_centro este:campo_refugio sur:sancta_portales" ;;
  campo_centro)      echo "sur:campo_puerta este:campo_refugio" ;;
  campo_refugio)     echo "oeste:campo_centro sur:campo_puerta" ;;
esac; }

# ── Objetos ────────────────────────────────────────────────────────────────────
nombre_item() { case "$1" in
  garra)       echo "Garra de Vibranium (T'Challa)" ;;
  garra_extra) echo "Garra de Vibranium extra" ;;
  armadura)    echo "Armadura Iron Man Mark L" ;;
  intel)       echo "Inteligencia sobre Thanos" ;;
  rifle)       echo "Rifle de Plasma S.H.I.E.L.D." ;;
  pocion)      echo "Poción de Curación (Doctor Strange)" ;;
  rastreador)  echo "Rastreador del Capitán América" ;;
  lingote)     echo "Lingote de Vibranium" ;;
  libro)       echo "Libro de Hechizos de Strange" ;;
  guantelete)  echo "Guantelete Roto del Infinito" ;;
  escudo)      echo "Escudo del Capitán América" ;;
  *)           echo "$1" ;;
esac; }

tipo_item() { case "$1" in
  rifle|garra|garra_extra|escudo) echo "arma" ;;
  armadura) echo "armadura" ;;
  pocion)   echo "pocion" ;;
  *)        echo "clave" ;;
esac; }

desc_item() { case "$1" in
  garra)      echo "Garras de la Pantera Negra. Daño: 25. Vibranium puro." ;;
  armadura)   echo "Nanotecnología Stark. +40 HP máximo al equiparla." ;;
  intel)      echo "Información clasificada sobre las debilidades de Thanos." ;;
  rifle)      echo "Arma de largo alcance. Daño: 35. Muy efectiva." ;;
  pocion)     echo "Restaura 50 HP. Preparada por Wong en Kamar-Taj." ;;
  rastreador) echo "Puede localizar el Escudo del Capitán América." ;;
  lingote)    echo "Metal precioso de Wakanda. El más resistente de la Tierra." ;;
  libro)      echo "Hechizo Crimson Bands of Cyttorak. Inmoviliza enemigos." ;;
  guantelete) echo "Versión dañada del Guantelete. Ya no puede usarse." ;;
  escudo)     echo "El arma LEGENDARIA de vibranium. Daño: 60. NECESARIO para vencer a Thanos." ;;
esac; }

# ── Helpers ────────────────────────────────────────────────────────────────────
get_suelo() { local v="suelo_${1//-/_}"; echo "${!v}"; }
set_suelo()  { local v="suelo_${1//-/_}"; eval "${v}='${2}'"; }

tiene() { for x in $INV; do [[ "$x" == "$1" ]] && return 0; done; return 1; }

buscar_inv() {
  local q="${1,,}"
  for x in $INV; do
    local n; n=$(nombre_item "$x")
    [[ "${n,,}" == *"$q"* || "$x" == *"$q"* ]] && echo "$x" && return
  done
}

buscar_suelo() {
  local q="${1,,}"
  for x in $(get_suelo "$LOC"); do
    local n; n=$(nombre_item "$x")
    [[ "${n,,}" == *"$q"* || "$x" == *"$q"* ]] && echo "$x" && return
  done
}

estado() {
  local f="Activa"
  [[ $GANADO -eq 1 ]] && f="${GR}¡VICTORIA!${RS}"
  [[ $MUERTO -eq 1 ]] && f="${R}GAME OVER${RS}"
  echo -e "\n${PK}${BO}  ❤  HP: ${GR}${BO}${HP}/${MAX_HP}${RS}${PK}${BO}  |  🕵  ${G}${BO}Nick Fury${RS}${PK}${BO}  |  Estado: ${f}${RS}"
}

# ── COMANDOS ───────────────────────────────────────────────────────────────────
cmd_mirar() {
  hr
  pr "${G}${BO}📍 $(nombre_zona $LOC)${RS}"
  hr
  pr "${C}$(desc_zona $LOC)${RS}"
  echo; mostrar_ascii "$LOC"; echo

  local s; s=$(get_suelo "$LOC")
  if [[ -n "$s" ]]; then
    local lista=""; for x in $s; do lista="$lista $(nombre_item $x),"; done
    pr "${G}Ves aquí:${RS} ${G}${lista%,}${RS}"
  fi

  [[ "$LOC" == "campo_centro" && $GANADO -eq 0 ]] && \
    pr "${R}${BO}⚠  THANOS TE BLOQUEA EL PASO. ¡Necesitas el Escudo del Capitán!${RS}"

  local dirs=""
  for par in $(salidas "$LOC"); do dirs="$dirs ${par%%:*}"; done
  pr "${YL}${BO}🧭 Salidas:${RS} ${LB}${BO}$dirs${RS}"
}

cmd_ir() {
  [[ -z "$1" ]] && pr "${R}¿Hacia dónde?${RS}" && return
  local dir="$1"
  for par in $(salidas "$LOC"); do
    local d="${par%%:*}"; local dest="${par##*:}"
    if [[ "$d" == "$dir" ]]; then
      LOC="$dest"
      cmd_mirar; return
    fi
  done
  pr "${R}No puedes ir al ${dir} desde aquí.${RS}"
}

cmd_explorar() {
  pr "${G}Exploras la zona detenidamente...${RS}"
  echo; mostrar_ascii "$LOC"; echo
  local s; s=$(get_suelo "$LOC")
  if [[ -n "$s" ]]; then
    local lista=""; for x in $s; do lista="$lista $(nombre_item $x),"; done
    pr "${GR}Encuentras:${lista%,}${RS}"
  else
    pr "No hay nada más que recoger aquí."
  fi
  [[ "$LOC" == "campo_centro" && $GANADO -eq 0 ]] && \
    pr "${R}Thanos te observa con el Guantelete. Su poder es inconmensurable.${RS}"
}

cmd_coger() {
  [[ -z "$*" ]] && pr "${R}¿Qué quieres coger?${RS}" && return
  local id; id=$(buscar_suelo "$*")
  [[ -z "$id" ]] && pr "${R}No encuentras '${*}' aquí. Prueba a explorar.${RS}" && return

  local nuevo=""
  for x in $(get_suelo "$LOC"); do [[ "$x" != "$id" ]] && nuevo="$nuevo $x"; done
  set_suelo "$LOC" "$(echo $nuevo)"
  INV="$INV $id"

  if [[ $(tipo_item "$id") == "armadura" ]]; then
    MAX_HP=$(( MAX_HP + 40 )); HP=$(( HP + 40 > MAX_HP ? MAX_HP : HP + 40 ))
    pr "${GR}Has cogido: ${G}$(nombre_item $id)${RS}"
    pr "${GR}¡La armadura te protege! +40 HP máx. HP: ${HP}/${MAX_HP}${RS}"
  else
    pr "${GR}Has cogido: ${G}$(nombre_item $id)${RS}"
    pr "${C}$(desc_item $id)${RS}"
  fi
  [[ "$id" == "escudo" ]] && pr "${G}${BO}⚡ ¡EL ESCUDO DEL CAPITÁN AMÉRICA! ¡Ahora puedes enfrentarte a Thanos!${RS}"
}

cmd_usar() {
  [[ -z "$*" ]] && pr "${R}¿Qué objeto quieres usar?${RS}" && return
  local id; id=$(buscar_inv "$*")
  [[ -z "$id" ]] && pr "${R}No tienes '${*}' en el inventario.${RS}" && return
  case $(tipo_item "$id") in
    pocion)
      HP=$(( HP + 50 > MAX_HP ? MAX_HP : HP + 50 ))
      local nuevo=""; for x in $INV; do [[ "$x" != "$id" ]] && nuevo="$nuevo $x"; done; INV="$nuevo"
      pr "${GR}Bebes la ${G}$(nombre_item $id)${GR}. ¡+50 HP! HP: ${HP}/${MAX_HP}${RS}" ;;
    arma)    pr "Blandeas ${G}$(nombre_item $id)${RS} en el aire. No hay enemigo aquí." ;;
    *)       pr "Examinas ${G}$(nombre_item $id)${RS}: $(desc_item $id)" ;;
  esac
}

cmd_examinar() {
  [[ -z "$*" ]] && pr "${R}¿Qué quieres examinar?${RS}" && return
  local id; id=$(buscar_inv "$*")
  [[ -z "$id" ]] && pr "${R}No tienes '${*}' en el inventario.${RS}" && return
  pr "${G}$(nombre_item $id)${RS}: $(desc_item $id)"
}

cmd_inventario() {
  local limpio; limpio=$(echo $INV | xargs)
  [[ -z "$limpio" ]] && pr "El inventario está vacío. Eres Fury, no Ant-Man." && return
  hr; pr "${G}${BO}🎒 INVENTARIO${RS}"; hr
  for x in $INV; do
    [[ -z "$x" ]] && continue
    local ico; case $(tipo_item "$x") in arma) ico="⚔";; armadura) ico="🛡";; pocion) ico="⚗";; *) ico="★";; esac
    pr "$ico ${YL}${BO}$(nombre_item $x)${RS} — ${C}$(desc_item $x)${RS}"
  done
}

cmd_atacar() {
  [[ "$LOC" != "campo_centro" ]] && pr "${R}No hay enemigo aquí. No eres el Punisher.${RS}" && return
  [[ $GANADO -eq 1 ]] && pr "${GR}Thanos ya fue derrotado.${RS}" && return
  [[ $MUERTO -eq 1 ]] && pr "${R}Game Over. Reinicia el script.${RS}" && return

  if ! tiene "escudo"; then
    pr "${R}¡Tus ataques no le hacen nada a Thanos!${RS}"
    pr "${R}Thanos: 'Sin el Escudo del Capitán? Ve a buscarlo primero.'${RS}"
    HP=$(( HP - 20 ))
    pr "${R}¡Thanos te golpea! -20 HP. HP: ${HP}/${MAX_HP}${RS}"
    if [[ $HP -le 0 ]]; then
      HP=0; hr
      pr "${R}${BO}Has sido derrotado por Thanos. El universo queda condenado...${RS}"
      pr "${W}Reinicia el script para intentarlo de nuevo.${RS}"; hr; MUERTO=1
    fi
    return
  fi

  echo; hr
  pr "${G}${BO}⚡ COMBATE FINAL: Nick Fury vs Thanos ⚡${RS}"; hr
  pr "${O}¡Lanzas el ${G}ESCUDO DEL CAPITÁN AMÉRICA${O} con toda tu fuerza!${RS}"
  pr "${O}¡El vibranium destruye el Guantelete del Infinito!${RS}"
  tiene "libro"  && pr "${C}¡Crimson Bands of Cyttorak! ¡Thanos queda inmovilizado!${RS}"
  tiene "rifle"  && pr "${O}¡Disparas el Rifle de Plasma mientras Thanos está inmovilizado!${RS}"
  echo
  pr "${GR}${BO}🎊 ¡THANOS DERROTADO! El Titán Loco cae de rodillas.${RS}"
  pr "${W}${BO}Thanos: 'Respeto... Quizás el universo sí merecía ser salvado...'${RS}"
  pr "${GR}¡El Guantelete se deshace en polvo cósmico. La realidad está a salvo!${RS}"
  tit "         ★  VICTORIA TOTAL  ★         "
  pr "${G}${BO}   ¡Nick Fury ha salvado el universo Marvel!${RS}"
  tit "  MARVEL: El Último Héroe — COMPLETADO  "
  GANADO=1
}

cmd_ayuda() {
  hr; pr "${G}${BO}📋 COMANDOS DISPONIBLES${RS}"; hr
  pr "${G}ir [norte/sur/este/oeste]${RS}  → Moverse entre zonas"
  pr "${G}mirar${RS}                      → Ver descripción de la zona"
  pr "${G}explorar${RS}                   → Buscar objetos en la zona"
  pr "${G}coger [objeto]${RS}             → Recoger un objeto del suelo"
  pr "${G}usar [objeto]${RS}              → Usar un objeto del inventario"
  pr "${G}examinar [objeto]${RS}          → Ver detalles de un objeto"
  pr "${G}atacar${RS}                     → Atacar al enemigo presente"
  pr "${G}inventario${RS}                 → Mostrar el inventario"
  pr "${G}ayuda${RS}                      → Mostrar esta lista"
  pr "${G}salir${RS}                      → Salir del juego"; hr
  pr "${G}MISIÓN:${RS} Consigue el Escudo del Capitán y derrota a Thanos."
}

# ── Parser ─────────────────────────────────────────────────────────────────────
ejecutar() {
  read -ra w <<< "$*"
  local v="${w[0],,}"; local a="${w[*]:1}"
  case "$v" in n|norte) v="norte";; s|sur) v="sur";; e|este) v="este";; o|oeste) v="oeste";; esac
  case "$v" in
    mirar|ver|observar|look|l)                     cmd_mirar ;;
    ir|ve|go|move)                                 cmd_ir "$a" ;;
    norte|sur|este|oeste)                          cmd_ir "$v" ;;
    explorar|buscar|registrar|investigar)          cmd_explorar ;;
    coger|agarrar|recoger|tomar|coge|take|get)     cmd_coger "$a" ;;
    usar|utilizar|beber|usa|use|drink)             cmd_usar "$a" ;;
    examinar|inspeccionar|examina|examine|inspect) cmd_examinar "$a" ;;
    atacar|luchar|combatir|pelear|attack|fight)    cmd_atacar ;;
    inventario|inv|i|mochila|inventory)            cmd_inventario ;;
    ayuda|help|h|\?)                               cmd_ayuda ;;
    salir|exit|quit|q) echo -e "\n${G}  Hasta la próxima, Agente Fury.${RS}\n"; exit 0 ;;
    "") ;;
    *) rand_error ;;
  esac
}

# ── Inicio ─────────────────────────────────────────────────────────────────────
clear 2>/dev/null
tit "⚡  MARVEL: EL ÚLTIMO HÉROE  ⚡"
echo
pr "${G}Año 2025. Thanos ha regresado con un Guantelete del Infinito parcialmente reparado.${RS}"
pr "${G}Eres ${YL}${BO}NICK FURY${RS}${G}, director de S.H.I.E.L.D. El único que puede detenerle.${RS}"
pr "${G}Tu misión: conseguir el ${YL}${BO}Escudo del Capitán América${RS}${G} y derrotar a Thanos${RS}"
pr "${G}en el Campo de Batalla Final.${RS}"
echo
pr "${PK}Escribe ${YL}${BO}ayuda${RS}${PK} para ver todos los comandos.${RS}"
echo; echo -e "${PK}${BO}  ⚡ [Pulsa Enter para comenzar...] ⚡${RS}"; read -r
cmd_mirar

while true; do
  estado
  echo -ne "${R}  FURY> ${RS}"
  read -r INPUT || break
  [[ -z "$INPUT" ]] && continue
  echo; ejecutar "$INPUT"; echo
done
