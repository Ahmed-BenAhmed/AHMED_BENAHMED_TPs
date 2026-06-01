#let navy = rgb("#1B3A5B")
#let amber = rgb("#E0A100")
#let ink = rgb("#1F2933")
#let soft = rgb("#FFF7E8")

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
        fill: soft,
        stroke: 0.6pt + amber.darken(5%),
        radius: 5pt,
        inset: 8pt,
        width: 100%,
      )[
        #text(9pt, weight: "bold", fill: navy)[Lecture de la capture]
        #v(0.15cm)
        #text(9.2pt)[#note]
      ]
    ],
  )
  v(0.35cm)
}

#let info-box(body) = block(
  fill: soft,
  stroke: 0.7pt + amber.darken(5%),
  radius: 5pt,
  inset: 9pt,
  width: 100%,
  body,
)

#let dash(name, title, note) = {
  figure(
    image("figures/" + name + ".png", width: 100%),
    caption: [#title],
  )
  block(
    fill: soft,
    stroke: 0.6pt + amber.darken(5%),
    radius: 5pt,
    inset: 9pt,
    width: 100%,
  )[
    #text(9pt, weight: "bold", fill: navy)[Lecture du tableau de bord]
    #v(0.15cm)
    #text(9.5pt)[#note]
  ]
  v(0.4cm)
}

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
          #text(9pt, fill: navy)[Ingenierie des Systemes d'Information et Big Data]
        ]
      ],
      [
        #align(right + horizon)[#image("media/uh1.png", height: 1.25cm)]
      ],
    )

    #v(1cm)
    #rect(width: 100%, height: 0.14cm, fill: navy)[]
    #v(1.3cm)

    #align(center)[
      #text(15pt, weight: "bold", fill: amber.darken(8%))[Compte rendu de TP]
      #v(0.25cm)
      #text(30pt, weight: "bold", fill: navy)[Power BI]
      #v(0.25cm)
      #text(14pt, fill: ink)[Business Intelligence et visualisation de donnees]
    ]

    #v(1.3cm)

    #rect(width: 100%, inset: 0.9cm, radius: 7pt, stroke: 1.1pt + navy, fill: soft)[
      #align(center)[
        #text(19pt, weight: "bold", fill: ink)[Conception d'un tableau de bord interactif]
        #v(0.25cm)
        #text(12pt, style: "italic", fill: gray.darken(25%))[Importation, modelisation, graphiques, filtres et analyse]
      ]
    ]

    #v(1.4cm)

    #grid(
      columns: (1fr, 1fr),
      gutter: 1.2cm,
      [
        #block(width: 100%, inset: 0.65cm, radius: 6pt, stroke: 0.7pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: navy)[REALISE PAR]
          #v(0.25cm)
          #text(13pt, weight: "bold")[AHMED BENAHMED]
        ]
      ],
      [
        #block(width: 100%, inset: 0.65cm, radius: 6pt, stroke: 0.7pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: navy)[ENCADRE PAR]
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
        #block(width: 100%, inset: 0.55cm, radius: 6pt, stroke: 0.7pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: navy)[DATE]
          #v(0.2cm)
          #text(12pt)[31/05/2026]
        ]
      ],
      [
        #block(width: 100%, inset: 0.55cm, radius: 6pt, stroke: 0.7pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: navy)[ANNEE UNIVERSITAIRE]
          #v(0.2cm)
          #text(12pt)[2025/2026]
        ]
      ],
    )

    #v(1fr)
    #rect(width: 100%, height: 0.08cm, fill: amber)[]
  ]
}

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(0.25cm)
  text(18pt, weight: "bold", fill: navy)[#it.body]
  line(length: 100%, stroke: 1pt + navy)
  v(0.25cm)
}

#show heading.where(level: 2): it => {
  v(0.2cm)
  text(14pt, weight: "bold", fill: ink)[#it.body]
}

#set document(title: "Compte rendu TP Power BI - Ahmed Benahmed", author: "Ahmed Benahmed")
#cover()

#set page(paper: "a4", margin: (x: 2cm, y: 2cm), numbering: "1")
#set text(font: "Libertinus Serif", size: 11pt, fill: ink, lang: "fr")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.")

#outline(title: [Table des matieres])

= Introduction

La Business Intelligence transforme des donnees brutes en decisions. Ce rapport retrace, a partir des captures du TP, la construction progressive d'un rapport Power BI Desktop : importer les sources, preparer et modeliser les tables, concevoir les visuels, ajouter des filtres interactifs et, au final, assembler des pages de synthese qui repondent a des questions concretes sur les ventes.

#info-box[
Les captures sont presentees dans l'ordre chronologique du travail et commentees a partir de ce qui est reellement visible a l'ecran. Lorsqu'une image n'appartient pas au TP Power BI, elle est ecartee plutot que forcee dans le recit, afin de garder le rapport coherent.
]

= Preparation et importation des donnees

Avant toute analyse, il faut amener les donnees dans Power BI et leur donner une forme exploitable. Cette premiere partie couvre l'ouverture de l'outil, le chargement des fichiers et les premieres operations de mise en forme dans Power Query.

#shot(1, [Capture 1 - Evolution trimestrielle des ventes de 2012 a 2015.], [Le graphique en colonnes `Sum of Ventes by Year and Quarter` sert de premier reperage temporel : il donne d'emblee la tendance des ventes trimestre par trimestre.])
#shot(2, [Capture 2 - Parametrage des interactions du graphique de ventes.], [Le mode `Edit interactions` est actif : il definit comment ce visuel reagit aux selections faites ailleurs dans la page, point cle d'un rapport interactif.])
#shot(3, [Capture 3 - Ventes par annee et par trimestre.], [Le regroupement par annee, avec les trimestres distingues par couleur, facilite la comparaison des quatre trimestres au sein de chaque exercice.])
#shot(4, [Capture 4 - Repartition des ventes par Etat aux Etats-Unis.], [La carte choroplethe colore chaque Etat selon la somme des ventes, ce qui fait ressortir immediatement les zones les plus contributives.])
#shot(5, [Capture 5 - Vue d'ensemble des ventes americaines.], [Cette premiere page de synthese reunit un KPI de quantite, un filtre de date, une carte, un graphique combine et un anneau par segment.])
#shot(6, [Capture 6 - Chargement de la table de ventes dans Power Query.], [La table `sales` apparait avec ses etapes appliquees : source, promotion de la premiere ligne en en-tetes et typage des colonnes.])
#shot(7, [Capture 7 - Import d'un fichier CSV avec delimiteur virgule.], [L'assistant CSV est en mode Basic, avec un encodage Western European et la virgule comme separateur de colonnes.])
#shot(8, [Capture 8 - Import CSV en mode avance.], [Le chemin du fichier est decompose et l'option ignorant les retours a la ligne entre guillemets est verifiee avant validation.])

= Construction des visualisations

Une fois les donnees prêtes, le travail se deplace vers la conception graphique : choisir le bon type de visuel, placer les axes et mesures, ajouter des filtres et soigner la lisibilite de chaque element.

#shot(10, [Capture 10 - Filtre de mois en selection multiple.], [Le slicer liste les mois disponibles et autorise la selection multiple, pour restreindre l'analyse a une ou plusieurs periodes a la volee.])
#shot(11, [Capture 11 - Repartition du stock par famille d'agregat.], [Le diagramme en anneau compare les familles de stock (Doner Kebab, BOISSONS, Materiel, BOEUF) et donne leur poids relatif.])
#shot(12, [Capture 12 - Tableau de bord des stocks par famille et par mois.], [Les cartes synthetisent stock global, stock viande et stock boisson, pendant que les graphiques en detaillent l'evolution mensuelle.])
#shot(13, [Capture 13 - Table de dimension des acheteurs, regions et dates.], [La feuille `Dim Tables` rassemble les axes d'analyse : Category, Buyer, Suburb, Postcode, Manager, State, Date et FY.])
#shot(14, [Capture 14 - Table de faits des ventes.], [La feuille `Fact Table` contient les ventes ligne par ligne : date, chaine, code postal, categorie, unites, prix de vente et cout.])
#shot(15, [Capture 15 - Extrait brut des ventes d'aout 2017.], [L'onglet `Aug Data` sert de jeu de controle pour verifier les chaines Ready Wear et Bellings avant l'import definitif.])
#shot(16, [Capture 16 - Parametrage du slicer Etat en liste verticale.], [Le panneau `Slicer settings` retient le style `Vertical list` et regle les options de selection du filtre d'Etat.])
#shot(17, [Capture 17 - Filtre d'Etat en tuiles.], [Presente sous forme de boutons horizontaux avec QLD selectionne, ce slicer illustre une variante plus visuelle du meme filtre.])
#shot(18, [Capture 18 - Part des ventes par chaine.], [L'anneau compare Bellings et Ready Wear, legende et etiquettes activees pour une lecture directe des parts.])
#shot(19, [Capture 19 - Ajout des colonnes de chiffre d'affaires, de cout et de marge.], [Dans Power Query, la requete `Sales` recoit les colonnes calculees `Total Sales`, `Total Cost` et `Gross Profit`, base du calcul de rentabilite.])

= Filtres, cartes et page finale

La derniere partie rend le rapport reellement interactif et le mene a son aboutissement : filtres croises, cartes geographiques, analyses par responsable ou client, puis pages de conclusion.

#shot(20, [Capture 20 - Page d'analyse par Etat et par chaine.], [La page reunit les slicers `Chain` et `State`, les KPI GF%, ventes et profit, un graphique par Etat et une courbe temporelle.])
#shot(21, [Capture 21 - Comparaison visuelle des Etats australiens.], [Un visuel personnalise affiche des lignes paralleles et des reperes colores par Etat. Le type exact reste incertain, mais l'intention est une comparaison multi-Etats.])
#shot(22, [Capture 22 - Synthese des ventes par Etat et par chaine.], [La page croise ventes par Etat, chaine dominante et evolution du nombre d'occurrences sur la periode 2016-2017.])
#shot(23, [Capture 23 - Arborescence des tables du modele.], [Le volet Data confirme la presence des tables `Buyers`, `Dates`, `Managers`, `Regions` et `Sales`.])
#shot(24, [Capture 24 - Modele en etoile du dataset.], [La table de faits `Sales` est reliee aux dimensions par des relations un-a-plusieurs, avec les directions de filtre visibles : c'est le schema en etoile.])
#shot(25, [Capture 25 - Relations actives de la table Sales.], [La fenetre `Manage relationships` valide les relations actives de `Sales` vers Buyers, Dates, Managers et Regions.])
#shot(26, [Capture 26 - Localisation des points de vente en Australie.], [La carte a bulles repartit geographiquement les points de vente selon la chaine, Bellings ou Ready Wear.])
#shot(27, [Capture 27 - Champs du visuel carte.], [Le visuel carte utilise `Merged` comme localisation, `Chain` comme legende et une mesure de ventes pour dimensionner les bulles.])
#shot(28, [Capture 28 - Synthese finale des ventes par Etat, manager et acheteur.], [La page combine filtres, indicateurs cles, carte d'Australie et comparaisons par manager et par acheteur.])
#shot(29, [Capture 29 - Page de synthese finale du rapport Power BI.], [Cette vue de conclusion rassemble en un seul ecran les principaux indicateurs et les repartitions geographiques et commerciales.])

= Tableaux de bord finalises (TP 1 a 4)

Au-dela des etapes de construction, cette section presente les quatre tableaux de bord aboutis, correspondant aux fichiers `tp1.pbix` a `tp4.pbix`. Chaque rapport repond a un besoin d'analyse distinct et illustre une facette differente de Power BI : indicateurs cles, repartitions geographiques, axes temporels et croisements multi-dimensions.

== TP 1 : Analyse des ventes, benefices et quantites

#dash("tp1_p1", [TP 1 - Page principale : vue d'ensemble des ventes.], [Trois cartes resument l'activite : 2,30 M de ventes, 286,40 K de benefices et 38 K de quantite. Autour, un graphique des ventes par annee, un combine ventes-benefices par annee et trimestre, une carte par Etat, un anneau par segment et un secteur par categorie, le tout pilote par un slicer `Date de commande`.])

#dash("tp1_p2", [TP 1 - Page d'analyse detaillee par region et categorie.], [Un slicer `Region` et un tableau croise par annee (2012-2015) accompagnent trois visuels : ventes par Etat et categorie, benefices par annee et categorie en aires empilees, et ventes par segment. La page approfondit la lecture commerciale amorcee en page 1.])

== TP 2 : Ventes par categorie de produit

#dash("tp2", [TP 2 - Tableau de bord des ventes par categorie de produit.], [La page totalise 29 M EUR de ventes et compte les produits et commandes. Les ventes se declinent par categorie (barres et secteur), par produit (nombre de commandes), par pays (carte) et dans une treemap, avec une table de synthese. Les familles Beverages, Condiments, Confections et Dairy Products structurent l'analyse.])

== TP 3 : Suivi des stocks

#dash("tp3", [TP 3 - Tableau de bord de suivi des stocks.], [Les cartes affichent le stock total (9,07 M, en repli de 2,87 %), le stock viande (561,29 K) et le stock boisson (1,81 M). La courbe de quantite par mois met en evidence un pic en septembre, tandis qu'un anneau repartit la valeur de stock par famille d'agregat et un histogramme detaille la quantite par designation de famille.])

== TP 4 : Analyse commerciale multi-axes

#dash("tp4_p1", [TP 4 - Page 1 : ventes, marges et rentabilite.], [La page croise les ventes par chaine et par Etat, le cout et le benefice brut par exercice (FY), un nuage de points GP% et benefice brut par categorie et trimestre (vue 2018 Q1), un secteur par chaine et une carte par Etat, avec des slicers de filtrage.])

#dash("tp4_p2", [TP 4 - Page 2 : performance par responsable et par acheteur.], [Les indicateurs (GP%, 57,66 M de ventes, 24,48 M de profit) surplombent des classements des ventes par responsable et par acheteur, une carte des ventes par Etat et chaine, et une courbe d'evolution par annee, trimestre, mois et jour.])

= Conclusion

Ce TP a permis de construire un rapport Power BI complet a partir de donnees commerciales reelles. Le cheminement suit la logique de tout projet decisionnel : preparer et fiabiliser les donnees, choisir les indicateurs pertinents, produire des visualisations adaptees a chaque question et organiser le tout en pages de synthese interactives. Le resultat n'est pas une simple collection de graphiques mais un outil d'analyse : il permet de comparer les ventes par periode, par zone, par chaine et par acteur, et donc d'eclairer la decision.
