---
title: "MARVEL: El Último Héroe"
subtitle: "Documentación Técnica — Juego de Aventura Textual"
author: "Desarrollo de Videojuegos"
date: "`r format(Sys.Date(), '%d de %B de %Y')`"
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
lang: es
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

# Introducción

**MARVEL: El Último Héroe** es un juego de aventura textual interactivo desarrollado íntegramente con **HTML5**, **CSS3** y **JavaScript ES6+ vanilla**, sin ninguna librería externa. El jugador encarna a **Nick Fury**, director de S.H.I.E.L.D., con una misión: recuperar el Escudo del Capitán América y derrotar a Thanos antes de que destruya el universo.

La interfaz recrea una terminal retro-futurista con tipografía monoespaciada, colores rojo y dorado Marvel, y un panel lateral con el estado del juego en tiempo real. Todo funciona como un único archivo HTML autocontenido en cualquier navegador moderno.

```{r fig-inicio, fig.cap="**Figura 1.** Pantalla de inicio del juego: introducción narrativa, zona inicial (Sede S.H.I.E.L.D. — Entrada de Seguridad), arte ASCII del emblema y panel lateral con inventario inicial."}
include_graphics("img/es_01_inicio.png")
```

## Ficha técnica

| Parámetro | Valor |
|:----------|:------|
| **Género** | Aventura textual interactiva |
| **Tecnología** | HTML5 / CSS3 / JavaScript ES6+ |
| **Dependencias** | Ninguna (Google Fonts opcional) |
| **Ambientación** | Universo Marvel Cinematográfico |
| **Personaje** | Nick Fury — Director de S.H.I.E.L.D. |
| **Objetivo** | Encontrar el Escudo del Cap. y derrotar a Thanos |
| **Versión** | 2.0 — 2025 |

---

# Estructura del Mundo

## Las 5 Localizaciones

El mundo tiene **5 localizaciones** con exactamente **3 zonas** cada una: descripciones únicas, objetos propios y salidas cardinales entre ellas.

```{r tabla-locs}
locs <- data.frame(
  N = 1:5,
  Localizacion = c("Torre Vengadores","Sede S.H.I.E.L.D.","Wakanda",
                   "Sancta Sanctorum","Campo de Batalla Final"),
  `Zona A` = c("Vestibulo Principal","Entrada de Seguridad",
               "Llanuras de Wakanda","Calle Bleecker","Puerta del Apocalipsis"),
  `Zona B` = c("Sala de Reuniones","Sala de Control",
               "Sala del Trono","Biblioteca Magica","Centro (JEFE)"),
  `Zona C` = c("Lab. de Tony Stark","Armeria Clasificada",
               "Minas de Vibranium","Sala de los Portales","Refugio (CLAVE)"),
  check.names = FALSE
)
kable(locs, caption = "**Tabla 1.** Las 5 localizaciones y sus 3 zonas cada una.")
```

> El jugador empieza en la **Sede de S.H.I.E.L.D.**, zona Entrada de Seguridad, con una Garra de Vibranium ya en el inventario.

## Mapa de conexiones

```
        Torre Vengadores
               |  norte <-> sur
        Sede S.H.I.E.L.D.  <-- este/oeste -->  Sancta Sanctorum  <-- norte/sur -->  Campo de Batalla
               |  sur <-> norte                         |
            Wakanda  <--------  este/oeste  ------------+
```

---

# Exploración y Comandos

## El comando explorar

`explorar` busca objetos ocultos en la zona y vuelve a mostrar el arte ASCII si existe. La siguiente captura muestra una sesión de exploración real en la Sede de S.H.I.E.L.D.:

```{r fig-explorar, fig.cap="**Figura 2.** El comando `explorar` en la Entrada de Seguridad. El arte ASCII del emblema S.H.I.E.L.D. se muestra de nuevo y aparecen los objetos disponibles en la zona."}
include_graphics("img/es_02_explorar.png")
```

## La Armería Clasificada

La Armería es una zona clave con el **Rifle de Plasma** y la **Poción de Curación**. Se accede desde la Sala de Control con `ir este`:

```{r fig-armeria, fig.cap="**Figura 3.** Armería Clasificada de S.H.I.E.L.D. El comando `explorar` revela los dos objetos disponibles: el Rifle de Plasma y la Poción de Curación del Doctor Strange."}
include_graphics("img/es_03_armeria.png")
```

## Tabla de comandos

```{r tabla-cmds}
cmds <- data.frame(
  Comando = c("ir [dir.]","mirar","explorar","coger [obj.]",
              "usar [obj.]","examinar [obj.]","atacar","inventario","ayuda"),
  Sinonimos = c("norte/sur/este/oeste","ver, observar, look, l",
                "buscar, registrar","agarrar, recoger, tomar",
                "utilizar, beber","inspeccionar, leer",
                "luchar, combatir, pelear","inv, i, mochila","help, h, ?"),
  Descripcion = c("Moverse entre zonas y localizaciones",
                  "Describir zona actual con salidas e items",
                  "Buscar objetos ocultos en la zona",
                  "Recoger un objeto del suelo",
                  "Usar objeto del inventario",
                  "Ver detalles de un objeto",
                  "Atacar al enemigo presente",
                  "Mostrar inventario completo",
                  "Mostrar lista de comandos"),
  check.names = FALSE
)
kable(cmds, caption = "**Tabla 2.** Comandos disponibles con todos sus sinonimos aceptados.")
```

---

# Sistema de Inventario

## Recoger objetos

Con `coger [nombre]` se recogen objetos del suelo. El juego hace coincidencia parcial del nombre, por lo que `coger rifle` funciona igual que `coger rifle de plasma shield`.

```{r fig-coger, fig.cap="**Figura 4.** El jugador recoge el Rifle de Plasma y la Pocion de Curacion en la Armeria. El panel lateral actualiza el inventario en tiempo real con iconos segun categoria."}
include_graphics("img/es_04_coger.png")
```

## Catalogo completo de objetos

```{r tabla-items}
items <- data.frame(
  Objeto = c("Garra de Vibranium","Rifle de Plasma S.H.I.E.L.D.",
             "Escudo Capitan America (CLAVE)","Armadura Iron Man Mk.L",
             "Pocion de Curacion","Rastreador del Capitan",
             "Inteligencia sobre Thanos","Lingote de Vibranium",
             "Libro de Hechizos","Guantelete Roto"),
  Tipo = c("Arma","Arma","Arma","Armadura","Pocion",
           "Clave","Clave","Clave","Clave","Clave"),
  `Dano/HP` = c(25,35,60,"+40","+50","—","—","—","—","—"),
  Localizacion = c("Wakanda","S.H.I.E.L.D.","Campo Batalla",
                   "Torre Vengadores","S.H.I.E.L.D.",
                   "Torre Vengadores","S.H.I.E.L.D.",
                   "Wakanda","Sancta Sanctorum","Sancta Sanctorum"),
  Zona = c("Sala del Trono","Armeria","Refugio","Lab. Stark","Armeria",
           "Sala Reuniones","Sala Control","Minas","Biblioteca","Portales"),
  check.names = FALSE
)
kable(items, caption = "**Tabla 3.** Catalogo de los 10 objetos del juego con localizacion y efecto.")
```

## Ver el inventario

```{r fig-inventario, fig.cap="**Figura 5.** El comando `inventario` muestra todos los objetos con su icono segun categoria (espada = arma, escudo = armadura, frasco = pocion, estrella = objeto clave) y descripcion completa de cada uno."}
include_graphics("img/es_06_inventario.png")
```

---

# Respuestas Aleatorias

Cuando el jugador escribe un comando no reconocido, el juego selecciona aleatoriamente una de **9 respuestas** con personajes del universo Marvel:

```{r fig-error, fig.cap="**Figura 6.** Tres respuestas aleatorias consecutivas ante comandos no reconocidos. Cada una hace referencia a un personaje Marvel distinto (Tony Stark, Error 616 / Xavier, Hulk)."}
include_graphics("img/es_05_error.png")
```

```{r tabla-rand}
resp <- data.frame(
  N = 1:9,
  Personaje = c("FRIDAY","Tony Stark","Charles Xavier","Hulk","Loki",
                "Wanda Maximoff","Nick Fury","Peter Parker","Thor"),
  Respuesta = c(
    "FRIDAY no entiende. Llama al Doctor Strange.",
    "'He construido una IA y no entiende ni el castellano.'",
    "ERROR 616. Notificado a Xavier, pero el ya lo sabia.",
    "Hulk GOLPEAR teclado? Ese comando no tiene sentido.",
    "'Es un buen plan para sembrar el caos.'",
    "Wanda reescribio la realidad. Tampoco entiende.",
    "Archivo S.H.I.E.L.D. enviado a ti mismo. Espabila.",
    "'Gran poder, gran responsabilidad'... tu tienes 0.",
    "ODIN tampoco entenderia tus palabras mortales."
  ),
  check.names = FALSE
)
kable(resp, caption = "**Tabla 4.** Las 9 respuestas aleatorias y el personaje Marvel de cada una.")
```

---

# Sistema de Combate

## Conseguir el Escudo

El **Escudo del Capitan America** esta en el **Refugio** del Campo de Batalla Final. Sin el, ningun ataque a Thanos funciona y cada intento cuesta **20 HP**.

```{r fig-escudo, fig.cap="**Figura 7.** El jugador recoge el Escudo del Capitan America en el Refugio. Aparece un mensaje especial en dorado. El panel lateral marca el objetivo 'Consigue el Escudo del Cap.' como completado."}
include_graphics("img/es_07_escudo.png")
```

## El combate final

Con el Escudo en el inventario, `atacar` en el Centro del Campo de Batalla desencadena la secuencia de victoria. El Libro de Hechizos y el Rifle activan dialogos extra:

```{r fig-victoria, fig.cap="**Figura 8.** Combate final y pantalla de victoria. El Escudo destruye el Guantelete, el Libro activa el hechizo Crimson Bands of Cyttorak, Thanos es derrotado y aparece el mensaje de victoria total."}
include_graphics("img/es_08_victoria.png")
```

### Resumen del sistema de combate

| Situacion | Resultado |
|:----------|:----------|
| `atacar` sin el Escudo | Thanos inmune — pierde 20 HP — Game Over a 0 HP |
| `atacar` con el Escudo | Victoria. El vibranium destruye el Guantelete |
| + Libro de Hechizos | Hechizo inmovilizador (dialogo extra) |
| + Rifle de Plasma | Ataque adicional mientras Thanos esta inmovilizado |

---

# Arquitectura Tecnica

## Stack tecnologico

```{r tabla-tech}
tech <- data.frame(
  Capa = c("Estructura","Estilos","Logica","Tipografia","Datos","Input"),
  Tecnologia = c("HTML5 semantico","CSS3 + Custom Properties",
                 "JavaScript ES6+ vanilla","Google Fonts (CDN)",
                 "Objetos JS literales","Event listener keydown"),
  Detalle = c("Un unico archivo .html autocontenido",
              "Variables --red, --gold; tema oscuro terminal",
              "Sin frameworks ni librerias externas",
              "Orbitron (titulos) + Share Tech Mono (texto)",
              "WORLD, ITEMS, ASCII, state como constantes JS",
              "Parser de texto libre con sinonimos por comando"),
  check.names = FALSE
)
kable(tech, caption = "**Tabla 5.** Stack tecnologico completo del juego.")
```

## Estructura del codigo

```javascript
// 1. CONSTANTES GLOBALES
const RAND  = [ /* 9 respuestas aleatorias */ ];
const ASCII = { avengers, shield, wakanda, stark, thanos, strange };
const WORLD = { /* 5 localizaciones x 3 zonas: salidas, items, ascii */ };
const ITEMS = { /* 10 objetos: nombre, tipo, desc */ };

// 2. ESTADO DEL JUEGO (mutable)
const G = {
  loc, zona,        // posicion actual
  inv,              // array de IDs de objetos
  hp, maxHp,        // puntos de vida
  muerto, ganado,   // flags de fin de partida
  suelo             // { "loc_zona": [ids] }
};

// 3. FUNCIONES DE PRESENTACION
//    pr(txt, cls)  |  actualizarPanel()  |  describir()

// 4. MANEJADORES DE COMANDOS
//    cmdIr()  cmdCoger()  cmdUsar()  cmdExplorar()
//    cmdAtacar()  cmdInventario()  cmdAyuda()

// 5. BOOTSTRAP
//    ejecutar(raw)  →  parser: texto libre → accion
//    init()         →  inicializacion del juego
```

---

# Guia de Partida Optima

```{r tabla-guia}
guia <- data.frame(
  Paso = 1:6,
  Localizacion = c("Sede S.H.I.E.L.D.","Sede S.H.I.E.L.D.",
                   "Torre Vengadores","Sancta Sanctorum",
                   "Campo de Batalla","Campo de Batalla"),
  Zona = c("Armeria","Armeria","Lab. Stark","Biblioteca","Refugio","Centro"),
  Comando = c("coger rifle","coger pocion","coger armadura",
              "coger libro","coger escudo","atacar"),
  Resultado = c("+Arma 35 dano","+50 HP","+40 HP max",
                "Hechizo inmovilizador","ITEM CLAVE","VICTORIA"),
  check.names = FALSE
)
kable(guia, caption = "**Tabla 6.** Recorrido optimo. Los pasos 1-4 pueden hacerse en cualquier orden; el 5 siempre antes del 6.")
```

---

# Conclusiones

**MARVEL: El Ultimo Heroe** demuestra que se puede construir una aventura textual completa y visualmente atractiva usando unicamente tecnologias web estandar. La arquitectura modular facilita extender el juego con nuevas localizaciones, objetos o enemigos.

| Requisito | Estado |
|:----------|:------:|
| 5 localizaciones con 3 zonas cada una | OK |
| Inventario con armas, armaduras y pociones | OK |
| 10 objetos distribuidos por el mundo | OK |
| Enemigo final con objeto especifico necesario | OK |
| Arte ASCII en al menos una zona por localizacion | OK |
| 9 respuestas aleatorias con personajes Marvel | OK |
| Multiples sinonimos por comando | OK |
| Interfaz terminal sin dependencias externas | OK |
| Panel lateral con estado en tiempo real | OK |

---

*Documentacion generada con R Markdown · MARVEL: El Ultimo Heroe v2.0 · 2025*
