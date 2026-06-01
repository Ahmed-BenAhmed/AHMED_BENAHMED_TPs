#let gitgreen = rgb("#1A7F37")
#let gitblue = rgb("#0969DA")
#let ink = rgb("#1F2328")
#let leaf = rgb("#EAF3EC")

#let shot(num, title) = {
  let name = if num < 10 { "capture_0" + str(num) } else { "capture_" + str(num) }
  figure(
    image("figures/" + name + ".png", width: 100%),
    caption: [#title],
  )
}

#let note-box(body) = block(
  fill: leaf,
  stroke: 0.8pt + gitgreen.lighten(20%),
  radius: 5pt,
  inset: 10pt,
  width: 100%,
  body,
)

#let command-box(body) = block(
  fill: rgb("#F6F8FA"),
  stroke: 0.7pt + gitblue.lighten(45%),
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
        #align(left + horizon)[
          #image("media/logo_ensab.png", width: 3.2cm)
        ]
      ],
      [
        #align(center)[
          #text(13pt, weight: "bold", fill: ink)[UNIVERSITE HASSAN 1er - SETTAT]
          #linebreak()
          #text(10pt, fill: ink)[Ecole Nationale des Sciences Appliquees de Berrechid]
          #linebreak()
          #text(9pt, fill: gitgreen)[Ingenierie des Systemes d'Information et Big Data]
        ]
      ],
      [
        #align(right + horizon)[
          #image("media/uh1.png", height: 1.25cm)
        ]
      ],
    )

    #v(0.9cm)
    #rect(width: 100%, height: 0.16cm, fill: gitgreen)[]
    #v(1.1cm)

    #align(center)[
      #text(15pt, fill: gitblue, weight: "bold")[Compte rendu de TP]
      #v(0.25cm)
      #text(29pt, weight: "bold", fill: gitgreen)[Git et GitHub]
      #v(0.25cm)
      #text(14pt, fill: ink)[Gestion de versions et collaboration de code]
    ]

    #v(1.2cm)

    #align(center)[
      #rect(
        width: 92%,
        inset: 0.9cm,
        radius: 8pt,
        fill: leaf,
        stroke: 1.2pt + gitgreen,
      )[
        #align(center)[
          #text(19pt, weight: "bold", fill: ink)[Du depot local au travail collaboratif]
          #v(0.25cm)
          #text(12pt, style: "italic", fill: gray.darken(25%))[Initialisation, index, commits, branches, historique et fusion]
        ]
      ]
    ]

    #v(1.5cm)

    #grid(
      columns: (1fr, 1fr),
      gutter: 1.2cm,
      [
        #rect(width: 100%, inset: 0.65cm, radius: 7pt, stroke: 0.7pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: gitgreen)[REALISE PAR]
          #v(0.25cm)
          #text(13pt, weight: "bold")[AHMED BENAHMED]
        ]
      ],
      [
        #rect(width: 100%, inset: 0.65cm, radius: 7pt, stroke: 0.7pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: gitgreen)[ENCADRE PAR]
          #v(0.25cm)
          #text(13pt, weight: "bold")[Pr. Hrimech]
        ]
      ],
    )

    #v(0.7cm)

    #grid(
      columns: (1fr, 1fr),
      gutter: 1.2cm,
      [
        #rect(width: 100%, inset: 0.55cm, radius: 7pt, stroke: 0.7pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: gitgreen)[DATE]
          #v(0.2cm)
          #text(12pt)[31/05/2026]
        ]
      ],
      [
        #rect(width: 100%, inset: 0.55cm, radius: 7pt, stroke: 0.7pt + gray.lighten(35%))[
          #text(10pt, weight: "bold", fill: gitgreen)[ANNEE UNIVERSITAIRE]
          #v(0.2cm)
          #text(12pt)[2025/2026]
        ]
      ],
    )

    #v(1fr)
    #align(right)[#text(10pt, fill: gray.darken(25%))[Rapport illustre par les captures du TP.]]
    #rect(width: 100%, height: 0.09cm, fill: gitblue)[]
  ]
}

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(0.25cm)
  text(18pt, weight: "bold", fill: gitgreen)[#it.body]
  line(length: 100%, stroke: 1pt + gitgreen)
  v(0.25cm)
}

#show heading.where(level: 2): it => {
  v(0.25cm)
  text(14pt, weight: "bold", fill: ink)[#it.body]
}

#set document(
  title: "Compte rendu TP Git et GitHub - Ahmed Benahmed",
  author: "Ahmed Benahmed",
)

#cover()

#set page(paper: "a4", margin: (x: 2cm, y: 2cm), numbering: "1")
#set text(font: "Libertinus Serif", size: 11pt, fill: ink, lang: "fr")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.")

#outline(title: [Table des matieres])

= Introduction

Git est aujourd'hui l'outil de reference pour suivre l'evolution d'un projet logiciel. Ce rapport retrace, etape par etape, les manipulations realisees pendant le TP Git et GitHub. L'idee directrice est simple : chaque commande laisse une trace dans le depot, et les captures fournies servent de preuve concrete de ce qui a ete execute. On y suit le parcours classique d'un developpeur, depuis l'initialisation d'un depot vide jusqu'a la resolution d'un conflit de fusion.

#note-box[
Les captures sont presentees dans leur ordre chronologique afin de respecter la logique d'apprentissage. Plutot que de recopier integralement chaque sortie de terminal, le rapport en degage l'intention : ce que la commande cherche a faire et ce qu'elle change reellement dans le depot.
]

= Demarrage du depot

== Objectif

Tout projet Git commence par un acte fondateur : transformer un simple dossier en depot versionne. Cette premiere partie illustre cette mise en place, depuis la creation de la structure du projet jusqu'au tout premier commit qui fige une version de reference.

#command-box[
```bash
git init
git status
git add .
git commit -m "initial commit"
```
]

#shot(1, [Capture 1 - Preparation du projet Git.])
#shot(2, [Capture 2 - Verification de l'etat du depot.])
#shot(3, [Capture 3 - Ajout des fichiers et premier suivi Git.])
#shot(4, [Capture 4 - Premiere validation des changements.])

= Suivi des changements

== Objectif

Le coeur de Git repose sur trois espaces distincts : le repertoire de travail ou l'on edite, l'index qui prepare la prochaine validation, et l'historique qui conserve les versions confirmees. Cette section met ces notions en evidence en suivant le cycle ajout, validation et consultation.

#command-box[
```bash
git status
git add <fichier>
git commit -m "message"
git log
```
]

#shot(5, [Capture 5 - Etat du projet apres ajout des fichiers.])
#shot(6, [Capture 6 - Controle de l'index Git.])
#shot(7, [Capture 7 - Validation d'un changement.])
#shot(8, [Capture 8 - Verification apres commit.])

= Branches et navigation

== Objectif

Les branches permettent de developper une fonctionnalite a l'ecart de la version principale, sans risque pour le code stable. Les captures suivantes montrent comment creer une branche, passer de l'une a l'autre et mesurer les ecarts entre deux versions avant toute integration.

#command-box[
```bash
git branch
git branch <nom-branche>
git checkout <nom-branche>
git diff <branche-a> <branche-b>
```
]

#shot(9, [Capture 9 - Liste ou creation de branches.])
#shot(10, [Capture 10 - Changement de branche.])
#shot(11, [Capture 11 - Comparaison entre branches.])
#shot(12, [Capture 12 - Controle de l'etat apres navigation.])
#shot(13, [Capture 13 - Observation des differences.])
#shot(14, [Capture 14 - Suivi de l'historique de branche.])

= Modifications avancees

== Objectif

Au-dela des commandes de base, Git offre des outils pour reprendre la main sur le contenu du depot : retirer un fichier du suivi, restaurer une version anterieure ou relire l'historique sous une forme condensee. Cette section documente ces operations de controle.

#command-box[
```bash
git rm <fichier>
git restore <fichier>
git reset <revision>
git log --oneline --graph
```
]

#shot(15, [Capture 15 - Manipulation avancee dans le depot.])
#shot(16, [Capture 16 - Verification de l'espace de travail.])
#shot(17, [Capture 17 - Consultation de l'historique.])
#shot(18, [Capture 18 - Etat apres modifications.])
#shot(19, [Capture 19 - Controle des fichiers suivis.])
#shot(20, [Capture 20 - Inspection des commits.])
#shot(21, [Capture 21 - Verification finale de cette etape.])

= Fusion et finalisation

== Objectif

Fusionner, c'est reunir le travail mene sur plusieurs branches en une seule ligne d'historique. Cette partie regroupe les operations de cloture du TP : integration des branches, derniers controles de l'etat du depot et lecture de l'historique global.

#command-box[
```bash
git merge <branche>
git status
git log --oneline --graph --all
git push
```
]

#shot(22, [Capture 22 - Debut de la phase de finalisation.])
#shot(23, [Capture 23 - Verification avant fusion ou publication.])
#shot(24, [Capture 24 - Operation de fusion ou de controle.])
#shot(25, [Capture 25 - Etat du depot apres operation.])
#shot(26, [Capture 26 - Controle final de l'historique.])
#shot(27, [Capture 27 - Verification de la branche courante.])
#shot(28, [Capture 28 - Derniere capture du TP.])

= Scenario complementaire : depot e-commerce

== Objectif

Pour ancrer ces notions dans un cas realiste, un second scenario reproduit l'organisation d'un projet applicatif. Un depot `ecommerce` est cree, puis le travail se structure autour d'une branche `develop` pour l'integration et d'une branche `feature/paiement` dediee a une fonctionnalite. Ce decoupage prepare la fusion finale, qui revelera un conflit a resoudre.

#command-box[
```bash
mkdir ecommerce
cd ecommerce
git init
git checkout -b develop
git checkout -b feature/paiement
```
]

#shot(29, [Capture 29 - Initialisation du depot e-commerce et creation des branches.])
#shot(30, [Capture 30 - Travail dans la branche feature/paiement.])

== Publication et retour sur develop

La publication vers un depot distant suppose qu'un `origin` ait ete declare au prealable ; sans cela, `git push` echoue, ce qui rappelle la difference entre depot local et depot distant. De meme, revenir sur `develop` n'est possible que si la branche existe localement, d'ou sa creation explicite.

#command-box[
```bash
git push origin feature/paiement
git checkout develop
git checkout -b develop
```
]

#shot(31, [Capture 31 - Erreur de depot distant et creation de la branche develop.])

== Fusion et verification des fichiers

La branche de fonctionnalite est ensuite integree dans `develop`. Une fois la fusion realisee, on verifie que les fichiers produits pendant le scenario sont bien presents et que leur contenu correspond a ce qui etait attendu.

#command-box[
```bash
git merge feature/paiement
ls
cat paiement-frontend.txt
cat paiement-backend.txt
```
]

#shot(32, [Capture 32 - Fusion et verification des fichiers de paiement.])
#shot(33, [Capture 33 - Consultation du contenu des fichiers.])

== Conflit et resolution

Lorsque deux branches modifient la meme zone d'un fichier, Git ne peut pas trancher seul : il signale un conflit sur `paiement-frontend.txt` et suspend la validation. La resolution est manuelle : on edite le fichier pour choisir la version correcte, puis on confirme avec `git add` et `git commit`, ce qui debloque l'historique.

#command-box[
```bash
git merge <branche>
nano paiement-frontend.txt
git add .
git commit -m "resolve merge conflicts"
```
]

#shot(34, [Capture 34 - Detection du conflit pendant la fusion.])
#shot(35, [Capture 35 - Resolution et commit final du conflit.])

= Conclusion

Ce TP a permis de parcourir le cycle de vie complet d'un projet sous Git : initialiser un depot, suivre les fichiers, enregistrer des commits, travailler en parallele grace aux branches, comparer les versions, fusionner et resoudre un conflit. Chaque etape s'appuie sur une trace verifiable, ce qui rend le travail reproductible.

Maitriser ces commandes constitue la base du travail collaboratif sur GitHub : tout changement devient identifiable, discutable et integrable proprement, ce qui donne a une equipe un historique clair et une plus grande confiance dans le code partage.
