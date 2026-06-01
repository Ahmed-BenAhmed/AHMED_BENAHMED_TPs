#let space = rgb("#1F2A44")
#let cyan = rgb("#00A6C0")
#let ink = rgb("#202124")
#let mist = rgb("#EAF6F9")

#let shot(num, title, note) = {
  let name = if num < 10 { "capture_0" + str(num) } else { "capture_" + str(num) }
  grid(
    columns: (2.1fr, 1fr),
    gutter: 0.55cm,
    [
      #figure(
        image("figures/" + name + ".png", width: 100%),
        caption: [#title],
      )
    ],
    [
      #block(
        fill: mist,
        stroke: 0.6pt + cyan.darken(8%),
        radius: 5pt,
        inset: 8pt,
        width: 100%,
      )[
        #text(9pt, weight: "bold", fill: space)[Lecture de la capture]
        #v(0.15cm)
        #text(9.2pt)[#note]
      ]
    ],
  )
  v(0.35cm)
}

#let note(body) = block(
  fill: mist,
  stroke: 0.7pt + cyan.darken(8%),
  radius: 5pt,
  inset: 9pt,
  width: 100%,
  body,
)

#let cover() = {
  set page(paper: "a4", margin: 2cm, numbering: none)
  page[
    #grid(
      columns: (1fr, 2fr, 1fr),
      gutter: 1cm,
      [
        #align(left + horizon)[#image("media/logo_ensab.png", width: 3.2cm)]
      ],
      [
        #align(center)[
          #text(13pt, weight: "bold", fill: ink)[UNIVERSITE HASSAN 1er - SETTAT]
          #linebreak()
          #text(10pt)[Ecole Nationale des Sciences Appliquees de Berrechid]
          #linebreak()
          #text(9pt, fill: space)[Ingenierie des Systemes d'Information et Big Data]
        ]
      ],
      [
        #align(right + horizon)[#image("media/uh1.png", height: 1.25cm)]
      ],
    )

    #v(0.9cm)
    #rect(width: 100%, height: 0.12cm, fill: space)[]
    #v(1.2cm)

    #align(center)[
      #text(15pt, weight: "bold", fill: cyan.darken(8%))[Compte rendu de TP]
      #v(0.25cm)
      #text(30pt, weight: "bold", fill: space)[Unity 3D]
      #v(0.25cm)
      #text(14pt, fill: ink)[Scene interactive et systeme solaire]
    ]

    #v(1.25cm)

    #rect(width: 100%, inset: 0.9cm, radius: 7pt, stroke: 1.2pt + space, fill: mist)[
      #align(center)[
        #text(19pt, weight: "bold", fill: ink)[Creation d'une scene Unity]
        #v(0.25cm)
        #text(12pt, style: "italic", fill: gray.darken(25%))[Objets 3D, materiaux, camera, execution et controle]
      ]
    ]

    #v(1.4cm)

    #grid(
      columns: (1fr, 1fr),
      gutter: 1.2cm,
      [
        #block(width: 100%, inset: 0.65cm, radius: 6pt, stroke: 0.8pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: space)[REALISE PAR]
          #v(0.25cm)
          #text(13pt, weight: "bold")[AHMED BENAHMED]
        ]
      ],
      [
        #block(width: 100%, inset: 0.65cm, radius: 6pt, stroke: 0.8pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: space)[ENCADRE PAR]
          #v(0.25cm)
          #text(13pt, weight: "bold")[Pr. Hrimech]
        ]
      ],
    )

    #v(0.65cm)

    #grid(
      columns: (1fr, 1fr),
      gutter: 1.2cm,
      [
        #block(width: 100%, inset: 0.55cm, radius: 6pt, stroke: 0.8pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: space)[DATE]
          #v(0.2cm)
          #text(12pt)[31/05/2026]
        ]
      ],
      [
        #block(width: 100%, inset: 0.55cm, radius: 6pt, stroke: 0.8pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: space)[ANNEE UNIVERSITAIRE]
          #v(0.2cm)
          #text(12pt)[2025/2026]
        ]
      ],
    )

    #v(1fr)
    #rect(width: 100%, height: 0.08cm, fill: cyan)[]
  ]
}

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(0.25cm)
  text(18pt, weight: "bold", fill: space)[#it.body]
  line(length: 100%, stroke: 1pt + space)
  v(0.25cm)
}

#show heading.where(level: 2): it => {
  v(0.2cm)
  text(14pt, weight: "bold", fill: ink)[#it.body]
}

#set document(title: "Compte rendu TP Unity - Ahmed Benahmed", author: "Ahmed Benahmed")
#cover()

#set page(paper: "a4", margin: (x: 2cm, y: 2cm), numbering: "1")
#set text(font: "Libertinus Serif", size: 11pt, fill: ink, lang: "fr")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.")

#outline(title: [Table des matieres])

= Introduction

Unity est un moteur de jeu qui permet de construire et d'animer des univers 3D en temps reel. Ce rapport presente un TP centre sur la realisation d'une scene de type systeme solaire. Les captures suivent la construction de la scene : organisation des assets, creation et placement des objets, application des textures, mise en place de la camera, puis test du rendu en mode jeu, jusqu'a une phase de debogage revelatrice des subtilites de l'Input System.

#note[
Les captures sont conservees dans leur ordre de progression et accompagnees d'un commentaire concis. L'objectif est de rendre lisible la fabrication de la scene Unity, sans transformer chaque image en transcription exhaustive de l'interface.
]

= Preparation de la scene

Toute scene Unity part d'un espace de travail organise : une `SampleScene` ouverte, des dossiers d'assets ranges et les premiers objets places dans le monde.

#shot(1, [Capture 1 - Terre texturee dans la scene SampleScene.], [La planete Terre est positionnee au centre de la scene ; les materiaux et textures du systeme solaire sont visibles dans le panneau Project, prets a etre appliques.])
#shot(2, [Capture 2 - Menu Create ouvert dans le dossier Scripts.], [Le dossier `Scripts` est selectionne dans Project et le menu contextuel est ouvert, premiere etape pour creer le code qui animera la scene.])

= Construction du systeme solaire

Cette partie donne vie a la scene : ajout de scripts de comportement, organisation de la hierarchie des planetes et premier test en mode Play, qui revele un probleme de configuration.

#shot(3, [Capture 3 - Creation d'un MonoBehaviour Script.], [Le sous-menu `Create` propose `MonoBehaviour Script` : c'est le type de script de base attache a un objet pour definir son comportement.])
#shot(4, [Capture 4 - Menu contextuel de Venus dans la hierarchie.], [La planete `Venus` est selectionnee et le menu offre `Create Empty`, `Create Empty Parent` et `3D Object`, options servant a structurer et regrouper les objets de la scene.])
#shot(5, [Capture 5 - Scripts de controle ajoutes au projet.], [Les scripts `MouseAimCamera` et `PlanetMotion` figurent dans le dossier `Scripts` ; `Main Camera` est selectionnee dans l'Inspector pour recevoir le controle de camera.])
#shot(6, [Capture 6 - Test en mode Play avec erreur Input System.], [La vue Game affiche le systeme solaire, mais la console remonte des `InvalidOperationException` liees a `Input.GetAxis` : l'ancienne API d'entree entre en conflit avec le nouvel Input System.])

= Verification finale

La derniere etape vise a resoudre le probleme observe en verifiant les modules installes via le Package Manager.

#shot(7, [Capture 7 - Acces au Package Manager depuis Window.], [Le menu `Window > Package Management > Package Manager` est ouvert pour controler ou installer les modules requis, notamment ceux lies a la gestion des entrees.])

= Conclusion

Ce TP a permis de manipuler les fondamentaux de Unity pour batir une scene 3D : creer des objets, appliquer des textures, gerer l'eclairage, placer une camera et tester le rendu en mode Game. La situation de debogage rencontree autour de l'Input System apporte un enseignement aussi utile que le reste : dans un moteur de jeu, le bon fonctionnement depend autant du code que de la coherence des reglages du projet, qu'il faut savoir verifier et ajuster pendant l'execution.
