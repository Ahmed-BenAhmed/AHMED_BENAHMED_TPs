#let teal = rgb("#0F4C5C")
#let rust = rgb("#9A3324")
#let slate = rgb("#263238")
#let pale = rgb("#EEF5F6")
#let linegray = gray.lighten(45%)

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
        fill: pale,
        stroke: 0.6pt + teal.lighten(18%),
        radius: 5pt,
        inset: 8pt,
        width: 100%,
      )[
        #text(9pt, weight: "bold", fill: teal)[Lecture de la capture]
        #v(0.15cm)
        #text(9.2pt)[#note]
      ]
    ],
  )
  v(0.35cm)
}

#let step-box(body) = block(
  fill: pale,
  stroke: 0.7pt + teal.lighten(15%),
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
          #text(13pt, weight: "bold", fill: slate)[UNIVERSITE HASSAN 1er - SETTAT]
          #linebreak()
          #text(10pt)[Ecole Nationale des Sciences Appliquees de Berrechid]
          #linebreak()
          #text(9pt, fill: teal)[Ingenierie des Systemes d'Information et Big Data]
        ]
      ],
      [
        #align(right + horizon)[#image("media/uh1.png", height: 1.25cm)]
      ],
    )

    #v(0.9cm)
    #line(length: 100%, stroke: 1.6pt + teal)
    #v(1.1cm)

    #align(center)[
      #text(15pt, weight: "bold", fill: rust)[Compte rendu de TP]
      #v(0.2cm)
      #text(29pt, weight: "bold", fill: teal)[SQL Server Integration Services]
      #v(0.25cm)
      #text(14pt)[Atelier ETL, connexions et chargement de donnees]
    ]

    #v(1.25cm)

    #rect(width: 100%, inset: 0.85cm, radius: 5pt, stroke: 1.2pt + teal, fill: pale)[
      #align(center)[
        #text(18pt, weight: "bold", fill: slate)[Debuter avec l'ETL SSIS]
        #v(0.25cm)
        #text(12pt, style: "italic", fill: gray.darken(25%))[Package SSIS, sources, destinations, mappings et execution]
      ]
    ]

    #v(1.45cm)

    #grid(
      columns: (1fr, 1fr),
      gutter: 1.2cm,
      [
        #block(width: 100%, inset: 0.65cm, radius: 5pt, stroke: 0.8pt + linegray)[
          #text(10pt, weight: "bold", fill: teal)[REALISE PAR]
          #v(0.25cm)
          #text(13pt, weight: "bold")[AHMED BENAHMED]
        ]
      ],
      [
        #block(width: 100%, inset: 0.65cm, radius: 5pt, stroke: 0.8pt + linegray)[
          #text(10pt, weight: "bold", fill: teal)[ENCADRE PAR]
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
        #block(width: 100%, inset: 0.55cm, radius: 5pt, stroke: 0.8pt + linegray)[
          #text(10pt, weight: "bold", fill: teal)[DATE]
          #v(0.2cm)
          #text(12pt)[31/05/2026]
        ]
      ],
      [
        #block(width: 100%, inset: 0.55cm, radius: 5pt, stroke: 0.8pt + linegray)[
          #text(10pt, weight: "bold", fill: teal)[ANNEE UNIVERSITAIRE]
          #v(0.2cm)
          #text(12pt)[2025/2026]
        ]
      ],
    )

    #v(1fr)
    #line(length: 100%, stroke: 1.6pt + teal)
  ]
}

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(0.25cm)
  text(18pt, weight: "bold", fill: teal)[#it.body]
  line(length: 100%, stroke: 1pt + teal)
  v(0.25cm)
}

#show heading.where(level: 2): it => {
  v(0.2cm)
  text(14pt, weight: "bold", fill: slate)[#it.body]
}

#set document(title: "Compte rendu TP SQL Server SSIS - Ahmed Benahmed", author: "Ahmed Benahmed")
#cover()

#set page(paper: "a4", margin: (x: 2cm, y: 2cm), numbering: "1")
#set text(font: "Libertinus Serif", size: 11pt, fill: slate, lang: "fr")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.")

#outline(title: [Table des matieres])

= Introduction

Alimenter un entrepot de donnees suppose d'extraire l'information de sources variees, de la transformer puis de la charger vers sa destination : c'est le principe de l'ETL, mis en oeuvre ici avec SQL Server Integration Services. Ce rapport documente les manipulations visibles dans les captures du TP, qui couvrent plusieurs sequences : alimentation du Data Warehouse BikeStores, chargement de fichiers plats, connexions Excel, traitement par boucle Foreach, diagnostics de connexion et scripts SQL de controle.

#step-box[
Chaque capture est commentee a partir de son contenu reel. Le rapport ne cherche pas a fondre toutes les images dans une seule histoire continue : chaque sequence est decrite avec l'objectif precis qu'elle remplit, ce qui reflete fidelement le deroulement du TP.
]

= Creation du projet et environnement

Cette premiere serie etablit les fondations : les flux d'alimentation des dimensions et des faits du Data Warehouse, puis les premiers controles de resultat dans SQL Server Management Studio.

#shot(1, [Capture 1 - Destination OLE DB pour alimenter la table Marque.], [L'editeur SSIS mappe `brand_name` vers la colonne cible `marque` : c'est le chargement de la dimension Marque dans `BikeStoresDW`.])
#shot(2, [Capture 2 - Destination OLE DB pour charger la table Produit.], [Le flux `alimentation produit` relie `product_name`, `IDMarque` et `IDcategorie` aux colonnes de la table Produit, en respectant les cles etrangeres.])
#shot(3, [Capture 3 - Source OLE DB pour l'extraction des lignes de vente.], [La requete SQL prepare `product_id`, `IDStore`, `montant` et `quantite` a partir des commandes et des magasins ; un message de validation reste affiche en bas.])
#shot(4, [Capture 4 - Execution reussie du workflow SSIS d'alimentation.], [Toutes les taches (`initialisation ventes`, `init produit`, `init store`) et leurs flux apparaissent en vert : le package s'est execute sans erreur.])
#shot(5, [Capture 5 - Verification du contenu de la table Ventes dans SSMS.], [Un `SELECT TOP (1000)` confirme la presence des colonnes `Quantite`, `Montant`, `IDStore` et `IDProduit` apres insertion.])
#shot(6, [Capture 6 - Flux CSV vers etape de traitement.], [`Extract Data From Csv File` lit le fichier source, puis transmet les lignes a `Process data` : c'est le squelette d'un data flow.])
#shot(7, [Capture 7 - Controle de la table FIRST_TABLE_ETL.], [SSMS affiche les donnees chargees dans `gestion_livres.dbo.FIRST_TABLE_ETL`, avec `DepartmentID`, `Name`, `GroupName` et `ModifiedDate`.])
#shot(8, [Capture 8 - Enchainement entre Execute SQL Task et Extract FromText File.], [Une contrainte de succes ordonne les taches : la tache SQL s'execute d'abord, l'extraction du fichier texte ne demarre qu'ensuite.])
#shot(9, [Capture 9 - Suivi d'execution du package en mode debogage.], [La zone d'execution affiche les messages de validation et la fin du package, qui contient `Script Task`, `Execute SQL Task` et `Extract FromText File`.])

= Sources, destinations et flux de donnees

Cette partie introduit les briques reutilisables d'un projet SSIS : variables, gestionnaires de connexion et composants source ou destination, avec leurs reglages d'authentification.

#shot(10, [Capture 10 - Message declenche par le Script Task.], [La boite de dialogue `Mon premier prog ETL SSIS` s'affiche pendant l'execution : elle confirme que le script de test est bien appele.])
#shot(11, [Capture 11 - Creation de la variable strFileName pour la boucle Foreach.], [L'editeur Foreach ouvre la creation de variable : `strFileName` portera le nom du fichier courant a chaque iteration.])
#shot(12, [Capture 12 - Script d'initialisation des tables Produit, Marque et Categorie.], [La tache `init produit` vide les tables et remet les identites a zero avant de recharger proprement les dimensions produit.])
#shot(13, [Capture 13 - Installation de l'extension SQL Server Integration Services Projects.], [La fenetre d'installation met en place l'outillage Visual Studio indispensable au developpement des projets SSIS.])
#shot(14, [Capture 14 - Connexion OLE DB vers gestion_livres.], [Le gestionnaire de connexion s'appuie sur SQL Server Native Client 11.0, avec authentification SQL Server, vers la base `gestion_livres`.])
#shot(15, [Capture 15 - Verification de la table AUTEURS dans gestion_livres.], [La requete SSMS prepare le controle des colonnes `NUMERO_A`, `NOM` et `PRENOM` de la table source avant chargement.])
#shot(16, [Capture 16 - Connexion OLE DB sur localhost,1443.], [La connexion vise la base `gestion_livres` via l'utilisateur `sa`, sur le port indique.])
#shot(17, [Capture 17 - Echec du test de connexion OLE DB.], [Le message d'erreur signale un serveur inaccessible ou des parametres incorrects : etape de diagnostic typique d'un projet ETL.])
#shot(18, [Capture 18 - Destination OLE DB pour charger la table AUTEURS.], [La table `[dbo].[AUTEURS]` est ciblee en mode `Table or view - fast load`, avec verrou de table et controle des contraintes.])
#shot(19, [Capture 19 - Source Excel avant selection de la feuille.], [Le connecteur Excel est ouvert mais aucune feuille n'est encore proposee : le classeur n'est pas encore correctement reconnu.])

= Mappings et chargement

Ici se joue le coeur du transfert : declarer precisement les fichiers sources, faire correspondre chaque colonne a sa cible et rendre le flux dynamique grace a la variable de boucle.

#shot(20, [Capture 20 - Connexion Excel vers test.xls.], [Le gestionnaire pointe vers `D:\\BUSINESS INTELLEGENCE FILES\\test.xls`, au format Excel 97-2003, premiere ligne servant d'en-tetes.])
#shot(21, [Capture 21 - Connexion Excel vers test.xlsx.], [Le classeur Excel 2007-2010 est declare comme source, avec les en-tetes en premiere ligne.])
#shot(22, [Capture 22 - Package avant ajout des composants du flux.], [Le canevas SSIS est encore vide : seules les connexions sont declarees, en bas de l'environnement.])
#shot(23, [Capture 23 - Flux fichier plat vers destination OLE DB avec erreur de validation.], [`Flat File Source` est relie a `OLE DB Destination`, mais la croix rouge indique qu'un composant reste mal configure.])
#shot(24, [Capture 24 - Configuration de la source fichier plat.], [Le `Flat File Source Editor` s'appuie sur le `Flat File Connection Manager` pour lire le fichier texte.])
#shot(25, [Capture 25 - Definition du gestionnaire de connexion fichier plat.], [Le fichier est declare en format delimite, avec les noms de colonnes en premiere ligne ; le chemin complet est partiellement tronque.])
#shot(26, [Capture 26 - Flux de donnees pilote par la variable strFileName.], [La propriete `FileNameColumnName = User::strFileName` montre que le fichier source sera choisi dynamiquement ; le flux reste en erreur a ce stade.])
#shot(27, [Capture 27 - Traitement par lot avec Foreach Loop Container.], [Le package integre un `Foreach Loop Container` qui encapsule un data flow, encore invalide dans cette capture.])
#shot(28, [Capture 28 - Propriete FileNameColumnName basee sur strFileName.], [La source fichier plat est liee a `strFileName`, ce qui lui permet de pointer vers le fichier courant de la boucle.])
#shot(29, [Capture 29 - Reglage du fichier plat et de son format de lecture.], [Le connecteur est configure en format delimite, avec `{CR}{LF}` comme fin de ligne d'en-tete et la premiere ligne comme noms de colonnes.])

= Verification SQL Server et finalisation

La derniere phase fiabilise et conclut le travail : reglage fin des proprietes, liaison des expressions a la variable, creation des schemas et execution finale du package complet.

#shot(30, [Capture 30 - Inspection du fichier Flat File Connection Manager.], [Le panneau de proprietes expose le chemin physique du gestionnaire de connexion depuis l'explorateur de solution.])
#shot(31, [Capture 31 - Editeur d'expressions de proprietes SSIS.], [La liste des proprietes est ouverte, `DefaultBufferMaxRows` selectionnee, avant la saisie d'une expression.])
#shot(32, [Capture 32 - Definition de la variable strFileName.], [Le panneau affiche la variable de type chaine dans `Package1`, destinee a porter le nom du fichier courant.])
#shot(33, [Capture 33 - Liaison du ConnectionString a strFileName avec erreur de portee.], [L'expression `@[USER::strFileName]` est saisie, mais SSIS signale que la variable n'est pas visible dans le scope courant : un probleme de portee a corriger.])
#shot(35, [Capture 35 - Execution reussie du package avec boucle Foreach.], [`Script Task`, `Execute SQL Task`, `Extract FromText File` et le conteneur Foreach se terminent tous en vert : le traitement dynamique fonctionne.])
#shot(36, [Capture 36 - Creation des schemas production et sales.], [SSMS execute un script creant les schemas BikeStores et la table `production.categories`, prealable aux chargements SSIS.])
#shot(37, [Capture 37 - Script d'initialisation des tables Store, Ville et etat.], [La tache `init store` purge les tables de reference et reinitialise leurs identites avec `DBCC CHECKIDENT`.])
#shot(38, [Capture 38 - Source OLE DB pour extraire les villes distinctes.], [La requete `alimentation ville` extrait les villes et rattache chacune a son etat depuis les tables BikeStores.])
#shot(39, [Capture 39 - Destination OLE DB pour charger Nomville et IDetat.], [Le mapping relie `city` a `Nomville` et `IDetat` a sa colonne cible : la dimension Ville est ainsi alimentee.])

= Conclusion

Ce TP a permis de mettre en pratique la chaine ETL complete avec SQL Server Integration Services. Les captures retracent les etapes essentielles d'un projet d'alimentation : creer un package, declarer et tester les connexions, configurer sources et destinations, mapper les colonnes, rendre un flux dynamique grace a une variable, puis verifier le resultat dans SQL Server. Au passage, les erreurs rencontrees, connexion injoignable ou variable hors scope, rappellent que le diagnostic fait partie integrante du metier. L'ensemble constitue une base solide pour construire des processus d'alimentation d'entrepot fiables et reutilisables.
