#let blueprint = rgb("#14467B")
#let steel = rgb("#22303C")
#let sky = rgb("#EAF1F8")

#let diagram(name, caption, note) = {
  figure(
    image("figures/" + name + ".png", width: 100%),
    caption: caption,
  )
  block(
    fill: sky,
    stroke: 0.6pt + blueprint.lighten(18%),
    radius: 4pt,
    inset: 8pt,
    width: 100%,
  )[
    #text(9pt, weight: "bold", fill: blueprint)[Lecture du diagramme]
    #v(0.12cm)
    #text(9.5pt, fill: gray.darken(35%))[#note]
  ]
  v(0.35cm)
}

#let synthesis(body) = block(
  fill: sky,
  stroke: 0.7pt + blueprint.lighten(12%),
  radius: 4pt,
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
          #text(13pt, weight: "bold", fill: steel)[UNIVERSITE HASSAN 1er - SETTAT]
          #linebreak()
          #text(10pt)[Ecole Nationale des Sciences Appliquees de Berrechid]
          #linebreak()
          #text(9pt, fill: blueprint)[Filiere : Ingenierie des Systemes d'Information et Big Data]
        ]
      ],
      [
        #align(right + horizon)[#image("media/uh1.png", height: 1.25cm)]
      ],
    )

    #v(1cm)
    #rect(width: 100%, inset: 0.65cm, fill: sky, stroke: 1pt + blueprint, radius: 4pt)[
      #align(center)[
        #text(16pt, weight: "bold", fill: blueprint)[Travaux Pratiques]
        #v(0.25cm)
        #text(31pt, weight: "bold", fill: steel)[Modelisation UML]
        #v(0.25cm)
        #text(13pt)[Ingenierie Logicielle]
      ]
    ]

    #v(1.2cm)

    #align(center)[
      #text(19pt, weight: "bold")[Etudes de cas et diagrammes]
      #v(0.3cm)
      #line(length: 70%, stroke: 1.4pt + blueprint)
      #v(0.35cm)
      #text(12pt, style: "italic", fill: gray.darken(25%))[Cas d'utilisation, classes, sequences et activites]
    ]

    #v(1.35cm)

    #grid(
      columns: (1fr, 1fr),
      gutter: 1.1cm,
      [
        #block(width: 100%, inset: 0.65cm, radius: 4pt, stroke: 0.8pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: blueprint)[REALISE PAR]
          #v(0.25cm)
          #text(13pt, weight: "bold")[AHMED BENAHMED]
        ]
      ],
      [
        #block(width: 100%, inset: 0.65cm, radius: 4pt, stroke: 0.8pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: blueprint)[ENCADRE PAR]
          #v(0.25cm)
          #text(13pt, weight: "bold")[Pr. Hrimech]
        ]
      ],
    )

    #v(0.65cm)

    #grid(
      columns: (1fr, 1fr),
      gutter: 1.1cm,
      [
        #block(width: 100%, inset: 0.55cm, radius: 4pt, stroke: 0.8pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: blueprint)[DATE]
          #v(0.2cm)
          #text(12pt)[31/05/2026]
        ]
      ],
      [
        #block(width: 100%, inset: 0.55cm, radius: 4pt, stroke: 0.8pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: blueprint)[ANNEE UNIVERSITAIRE]
          #v(0.2cm)
          #text(12pt)[2025/2026]
        ]
      ],
    )

    #v(1fr)
    #line(length: 100%, stroke: 1.4pt + blueprint)
  ]
}

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(0.25cm)
  text(18pt, weight: "bold", fill: blueprint)[#it.body]
  line(length: 100%, stroke: 1pt + blueprint)
  v(0.25cm)
}

#show heading.where(level: 2): it => {
  v(0.2cm)
  text(14pt, weight: "bold", fill: steel)[#it.body]
}

#set document(title: "TP UML - Ahmed Benahmed", author: "Ahmed Benahmed")
#cover()

#set page(paper: "a4", margin: (x: 2cm, y: 2cm), numbering: "1")
#set text(font: "Libertinus Serif", size: 11pt, fill: steel, lang: "fr")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.")
#set enum(numbering: "1.")

#outline(title: [Table des matieres])

= Introduction

Avant d'ecrire la moindre ligne de code, il faut comprendre le probleme : c'est le role de la modelisation UML. Ce rapport applique cette demarche a trois etudes de cas et montre comment des besoins exprimes en langage naturel se traduisent en diagrammes precis. Chaque type de diagramme apporte un eclairage particulier : les cas d'utilisation delimitent le perimetre fonctionnel et ses acteurs, les classes fixent la structure du domaine, les sequences detaillent les echanges dans le temps, et les activites clarifient les decisions du flux principal.

#synthesis[
Tous les diagrammes sont d'abord ecrits en Mermaid, puis exportes en images. Les fichiers sources sont conserves dans le dossier `diagrams/`, ce qui rend le rapport facile a modifier : il suffit d'editer le code du diagramme et de recompiler pour mettre l'image a jour.
]

= Etude de cas 1 : Plateforme e-commerce

== Objectifs

La plateforme e-commerce accompagne le parcours d'achat du client : parcourir le catalogue, constituer un panier, regler une commande et en suivre l'avancement. En parallele, l'administrateur garde la main sur l'offre en maintenant le catalogue produit a jour.

== Diagramme de cas d'utilisation

#diagram("ecommerce_usecase", [Cas d'utilisation de la plateforme e-commerce.], [Le client concentre les actions commerciales (consultation, panier, paiement, suivi), tandis que l'administrateur intervient en amont sur la gestion du catalogue.])

== Diagramme de classes

#diagram("ecommerce_classes", [Modele de classes de la plateforme e-commerce.], [Le modele s'articule autour des entites `Client`, `Produit`, `Panier`, `Commande` et `Paiement`, reliees par les associations qui rendent possible le passage d'une commande.])

== Diagramme de sequence

#diagram("ecommerce_sequence", [Sequence de paiement d'une commande.], [La sequence deroule le scenario nominal, de la consultation du catalogue jusqu'a la confirmation finale, une fois le paiement verifie par le systeme.])

== Diagramme d'activite

#diagram("ecommerce_activity", [Activite principale d'achat.], [Le flux fait apparaitre les points de decision : poursuivre les achats ou passer au paiement, et que faire lorsqu'un paiement est refuse.])

= Etude de cas 2 : Gestion universitaire

== Objectifs

L'application universitaire gere les etudiants, les enseignants, les cours et les inscriptions. L'enjeu de la modelisation est ici d'eviter la redondance des informations communes a plusieurs profils et de garder une structure capable d'evoluer sans tout reecrire.

== Diagramme de classes

#diagram("university_classes", [Classes principales de l'application universitaire.], [La classe `Personne` factorise les attributs partages par les etudiants et les enseignants. L'inscription joue le role de lien entre un etudiant et un cours, avec son propre statut.])

== Diagramme de sequence

#diagram("university_sequence", [Sequence d'inscription d'un etudiant.], [Avant d'enregistrer l'inscription, le systeme verifie l'existence de l'etudiant et controle qu'il reste de la place dans le cours vise.])

= Etude de cas 3 : Reservation d'hotel

== Objectifs

Le systeme de reservation hoteliere couvre l'ensemble du cycle : consulter les chambres disponibles, reserver, payer, puis annuler si besoin. En coulisses, les acteurs internes tiennent a jour les disponibilites et l'etat des chambres.

== Diagramme de cas d'utilisation

#diagram("hotel_usecase", [Cas d'utilisation du systeme hotelier.], [Le client utilise les fonctions de reservation et d'annulation, alors que le receptionniste et l'administrateur assurent la gestion des disponibilites cote etablissement.])

== Diagramme de classes

#diagram("hotel_classes", [Modele de classes du systeme de reservation.], [La reservation est l'entite centrale : elle relie un client, une chambre, une periode de sejour et, le cas echeant, un paiement.])

== Diagramme de sequence

#diagram("hotel_sequence", [Sequence de reservation avec paiement.], [Le systeme verifie d'abord la disponibilite de la chambre, puis declenche le paiement avant de confirmer definitivement la reservation.])

= Conclusion

Ces trois etudes de cas illustrent l'apport d'UML : structurer l'analyse avant l'implementation et reduire les ambiguites avec le commanditaire. Les diagrammes ne se concurrencent pas, ils se completent. Les cas d'utilisation cadrent le besoin, les classes stabilisent le modele metier, les sequences donnent le tempo des interactions et les activites explicitent les decisions cles. Mises bout a bout, ces vues forment une base solide sur laquelle le developpement peut s'appuyer en confiance.
