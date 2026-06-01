# Image Metadata - TP SQL Server / SSIS Ahmed

This file maps stable package images to report-ready captions and context.

| File | Caption | Context | Status |
|---|---|---|---|
| `figures/capture_01.png` | Destination OLE DB pour alimenter la table Marque. | Mapping `brand_name` vers `marque` pour la dimension Marque dans `BikeStoresDW`. | Used |
| `figures/capture_02.png` | Destination OLE DB pour charger la table Produit. | Mapping `product_name`, `IDMarque` et `IDcategorie` vers la table Produit. | Used |
| `figures/capture_03.png` | Source OLE DB pour l'extraction des lignes de vente. | Requete preparant `product_id`, `IDStore`, `montant` et `quantite`. | Used |
| `figures/capture_04.png` | Execution reussie du workflow SSIS d'alimentation. | Taches d'initialisation et d'alimentation terminees en vert. | Used |
| `figures/capture_05.png` | Verification du contenu de la table Ventes dans SSMS. | `SELECT TOP (1000)` confirme les colonnes chargees. | Used |
| `figures/capture_06.png` | Flux CSV vers etape de traitement. | `Extract Data From Csv File` transmet les lignes a `Process data`. | Used |
| `figures/capture_07.png` | Controle de la table FIRST_TABLE_ETL. | Verification de `DepartmentID`, `Name`, `GroupName` et `ModifiedDate`. | Used |
| `figures/capture_08.png` | Enchainement entre Execute SQL Task et Extract FromText File. | La tache SQL s'execute avant l'extraction du fichier texte. | Used |
| `figures/capture_09.png` | Suivi d'execution du package en mode debogage. | Messages de validation et de fin d'execution du package. | Used |
| `figures/capture_10.png` | Message declenche par le Script Task. | Boite de dialogue `Mon premier prog ETL SSIS`. | Used |
| `figures/capture_11.png` | Creation de la variable strFileName pour la boucle Foreach. | Variable destinee a stocker le nom du fichier courant. | Used |
| `figures/capture_12.png` | Script d'initialisation des tables Produit, Marque et Categorie. | Suppression des donnees et remise a zero des identites. | Used |
| `figures/capture_13.png` | Installation de l'extension SQL Server Integration Services Projects. | Preparation de l'outillage Visual Studio pour SSIS. | Used |
| `figures/capture_14.png` | Connexion OLE DB vers gestion_livres. | Gestionnaire de connexion avec SQL Server Native Client et base `gestion_livres`. | Used |
| `figures/capture_15.png` | Verification de la table AUTEURS dans gestion_livres. | Requete SSMS sur `NUMERO_A`, `NOM` et `PRENOM`. | Used |
| `figures/capture_16.png` | Connexion OLE DB sur localhost,1443. | Connexion `sa` vers `gestion_livres`. | Used |
| `figures/capture_17.png` | Echec du test de connexion OLE DB. | Serveur inaccessible ou parametres de connexion incorrects. | Used |
| `figures/capture_18.png` | Destination OLE DB pour charger la table AUTEURS. | Mode `fast load`, verrou de table et controle des contraintes. | Used |
| `figures/capture_19.png` | Source Excel avant selection de la feuille. | Aucune table ou vue Excel n'est encore listee. | Used |
| `figures/capture_20.png` | Connexion Excel vers test.xls. | Fichier Excel 97-2003 avec en-tetes en premiere ligne. | Used |
| `figures/capture_21.png` | Connexion Excel vers test.xlsx. | Classeur Excel 2007-2010 avec en-tetes en premiere ligne. | Used |
| `figures/capture_22.png` | Package avant ajout des composants du flux. | Canevas SSIS vide avec connexions visibles. | Used |
| `figures/capture_23.png` | Flux fichier plat vers destination OLE DB avec erreur de validation. | `Flat File Source` vers `OLE DB Destination`, composant encore invalide. | Used |
| `figures/capture_24.png` | Configuration de la source fichier plat. | `Flat File Source Editor` utilisant `Flat File Connection Manager`. | Used |
| `figures/capture_25.png` | Definition du gestionnaire de connexion fichier plat. | Fichier delimite avec noms de colonnes en premiere ligne. | Used |
| `figures/capture_26.png` | Flux de donnees pilote par la variable strFileName. | `FileNameColumnName = User::strFileName`; flux encore en erreur. | Used |
| `figures/capture_27.png` | Traitement par lot avec Foreach Loop Container. | Boucle Foreach contenant un data flow interne encore invalide. | Used |
| `figures/capture_28.png` | Propriete FileNameColumnName basee sur strFileName. | La source fichier plat pointe vers le fichier courant de la boucle. | Used |
| `figures/capture_29.png` | Reglage du fichier plat et de son format de lecture. | Format delimite, `{CR}{LF}` et en-tetes. | Used |
| `figures/capture_30.png` | Inspection du fichier Flat File Connection Manager. | Proprietes du gestionnaire de connexion dans Visual Studio. | Used |
| `figures/capture_31.png` | Editeur d'expressions de proprietes SSIS. | Liste de proprietes avant saisie d'une expression. | Used |
| `figures/capture_32.png` | Definition de la variable strFileName. | Variable chaine dans `Package1`. | Used |
| `figures/capture_33.png` | Liaison du ConnectionString a strFileName avec erreur de portee. | Expression `@[USER::strFileName]` non trouvee dans le scope courant. | Used |
| `figures/capture_34.png` | Initialisation de la base MongoDB airbase. | Capture `mongosh` hors sujet pour le rapport SQL Server / SSIS. | Excluded from report |
| `figures/capture_35.png` | Execution reussie du package avec boucle Foreach. | Workflow et conteneur interne termines en vert. | Used |
| `figures/capture_36.png` | Creation des schemas production et sales. | Script SQL creant schemas BikeStores et table `production.categories`. | Used |
| `figures/capture_37.png` | Script d'initialisation des tables Store, Ville et etat. | Purge des dimensions et remise a zero des identites. | Used |
| `figures/capture_38.png` | Source OLE DB pour extraire les villes distinctes. | Extraction des villes et rattachement de l'etat correspondant. | Used |
| `figures/capture_39.png` | Destination OLE DB pour charger Nomville et IDetat. | Mapping `city` vers `Nomville` et `IDetat` vers la colonne cible. | Used |
