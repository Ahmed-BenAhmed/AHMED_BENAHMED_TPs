# Image Metadata - TP Power BI Ahmed

This file maps stable package images to report-ready captions and context.

| File | Caption | Context | Status |
|---|---|---|---|
| `figures/capture_01.png` | Evolution trimestrielle des ventes de 2012 a 2015. | Le graphique en colonnes affiche `Sum of Ventes by Year and Quarter` et sert de premier visuel temporel. | Used |
| `figures/capture_02.png` | Parametrage des interactions du graphique de ventes. | Le mode `Edit interactions` controle le comportement du visuel selectionne lors du survol et du drill-up. | Used |
| `figures/capture_03.png` | Ventes par annee et par trimestre. | Le graphique est regroupe par annee, avec les trimestres representes en couleurs. | Used |
| `figures/capture_04.png` | Repartition des ventes par Etat aux Etats-Unis. | La carte colore les Etats selon la somme des ventes pour reperer les zones les plus contributives. | Used |
| `figures/capture_05.png` | Vue d'ensemble des ventes americaines. | La page combine KPI, filtre de date, carte, graphique combine et anneau par segment. | Used |
| `figures/capture_06.png` | Chargement de la table de ventes dans Power Query. | Power Query affiche la table `sales` avec source, en-tetes et changement de types. | Used |
| `figures/capture_07.png` | Import d'un fichier CSV avec delimiteur virgule. | La boite CSV est configuree en mode Basic avec encodage Western European et separateur `Comma`. | Used |
| `figures/capture_08.png` | Import CSV en mode avance. | Le chemin du fichier est decoupe et les retours a la ligne entre guillemets sont ignores. | Used |
| `figures/capture_09.png` | Image Docker publiee dans un registre. | Depot `sijilpharma-ai`, tag `latest` et digests visibles. Capture hors sujet pour le rapport Power BI. | Excluded from report |
| `figures/capture_10.png` | Filtre de mois en selection multiple. | Le slicer affiche les mois disponibles et limite l'analyse a une ou plusieurs periodes. | Used |
| `figures/capture_11.png` | Repartition du stock par famille d'agregat. | Le diagramme en anneau compare les familles de stock. | Used |
| `figures/capture_12.png` | Tableau de bord des stocks par famille et par mois. | Cartes de stock global, stock viande, stock boisson, courbe mensuelle et repartition par famille. | Used |
| `figures/capture_13.png` | Table de dimension des acheteurs, regions et dates. | La feuille `Dim Tables` regroupe les champs metier pour les axes d'analyse. | Used |
| `figures/capture_14.png` | Table de faits des ventes. | La feuille `Fact Table` contient date, chaine, code postal, categorie, unites, prix de vente et cout. | Used |
| `figures/capture_15.png` | Extrait brut des ventes d'aout 2017. | L'onglet `Aug Data` sert a verifier des lignes de controle avant l'import. | Used |
| `figures/capture_16.png` | Parametrage du slicer Etat en liste verticale. | Le panneau `Slicer settings` montre le style `Vertical list` et les options du filtre d'Etat. | Used |
| `figures/capture_17.png` | Filtre d'Etat en tuiles. | Le slicer est presente sous forme de boutons horizontaux, avec QLD selectionne. | Used |
| `figures/capture_18.png` | Part des ventes par chaine. | Le diagramme en anneau compare Bellings et Ready Wear. | Used |
| `figures/capture_19.png` | Ajout des colonnes de chiffre d'affaires, de cout et de marge. | Power Query affiche `Total Sales`, `Total Cost` et `Gross Profit`. | Used |
| `figures/capture_20.png` | Page d'analyse par Etat et par chaine. | Page avec slicers `Chain` et `State`, KPI GF%, ventes, profit, graphique par Etat et courbe temporelle. | Used |
| `figures/capture_21.png` | Comparaison visuelle des Etats australiens. | Visuel custom avec lignes paralleles et reperes colores par Etat. Type exact incertain. | Used, uncertain visual type |
| `figures/capture_22.png` | Synthese des ventes par Etat et par chaine. | La page croise ventes par Etat, chaine dominante et evolution temporelle. | Used |
| `figures/capture_23.png` | Arborescence des tables du modele. | Le volet Data confirme `Buyers`, `Dates`, `Managers`, `Regions` et `Sales`. | Used |
| `figures/capture_24.png` | Modele en etoile du dataset. | `Sales` est reliee aux dimensions metier avec relations un-a-plusieurs. | Used |
| `figures/capture_25.png` | Relations actives de la table Sales. | `Manage relationships` valide les relations de `Sales` vers les dimensions. | Used |
| `figures/capture_26.png` | Localisation des points de vente en Australie. | Carte a bulles par chaine Bellings ou Ready Wear. | Used |
| `figures/capture_27.png` | Champs du visuel carte. | `Merged` sert de localisation, `Chain` de legende et une mesure de ventes est configuree dans le visuel. | Used |
| `figures/capture_28.png` | Synthese finale des ventes par Etat, manager et acheteur. | Page finale avec filtres, KPI, carte et comparaisons par manager et acheteur. | Used |
| `figures/capture_29.png` | Page de synthese finale du rapport Power BI. | Vue finale rassemblant indicateurs, repartitions geographiques et commerciales. | Used |
