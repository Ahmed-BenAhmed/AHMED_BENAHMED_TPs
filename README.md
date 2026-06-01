# Travaux Pratiques — Ahmed Benahmed

Recueil des travaux pratiques réalisés dans le cadre de la filière **Ingénierie des Systèmes d'Information et Big Data** à l'**École Nationale des Sciences Appliquées de Berrechid (ENSAB)** — Université Hassan 1er, Settat.

Chaque thème regroupe, lorsqu'ils existent, **les fichiers du projet** (code, exercices, fichiers source) et **le rapport** correspondant (source Typst, figures et PDF compilé).

| | Réalisé par | Encadré par | Année universitaire |
|---|---|---|---|
| | **Ahmed Benahmed** | Pr. Hrimech | 2025 / 2026 |

---

## Sommaire des TP

| # | Thème | Projet | Rapport (PDF) |
|---|-------|:------:|---------------|
| 01 | **Git & GitHub** — gestion de versions et collaboration | ✅ | [tp_git_github](01-git-github/rapport/build/tp_git_github_ahmed_report.pdf) |
| 02 | **Modélisation UML** — études de cas et diagrammes | — | [tp_uml](02-uml/rapport/build/tp_uml_ahmed_report.pdf) |
| 03 | **Power BI** — Business Intelligence et tableaux de bord | ✅ | [tp_power_bi](03-power-bi/rapport/build/tp_power_bi_ahmed_report.pdf) |
| 04 | **SQL Server / SSIS** — atelier ETL | — | [tp_sql_server_ssis](04-sql-server-ssis/rapport/build/tp_sql_server_ssis_ahmed_report.pdf) |
| 05 | **Unity 3D** — scène interactive (système solaire) | ✅ | [tp_unity](05-unity/rapport/build/tp_unity_ahmed_report.pdf) |

---

## Détail des travaux pratiques

### 01 — Git & GitHub
Manipulation complète du cycle de vie d'un dépôt : initialisation, suivi des fichiers (`add`, `commit`), travail sur branches, comparaison de versions, fusion et résolution de conflits.

- **`projet/git-exercices/`** — petit site web (HTML / CSS / JS) servant de support aux exercices de branches.
- **`projet/new-repo/`** — dépôt d'exercice illustrant un conflit de fusion (`conflit.txt`).
- **`rapport/`** — compte rendu illustré par 35 captures d'écran.

### 02 — Modélisation UML
Analyse de trois études de cas (plateforme e-commerce, gestion universitaire, réservation d'hôtel) à travers les diagrammes de cas d'utilisation, de classes, de séquence et d'activité.

- **`rapport/diagrams/`** — diagrammes au format **Mermaid** (`.mmd`), sources modifiables.
- **`rapport/figures/`** — diagrammes exportés en images.
- **`rapport/`** — compte rendu commenté.

### 03 — Power BI
Conception d'un tableau de bord interactif : importation et préparation des données (Power Query), modélisation en étoile, création de visuels, filtres (slicers) et pages de synthèse.

- **`projet/`** — fichiers Power BI Desktop `tp1.pbix` … `tp4.pbix`.
- **`rapport/`** — compte rendu illustré par 29 captures.

### 04 — SQL Server / SSIS
Atelier ETL avec SQL Server Integration Services : création d'un package, gestionnaires de connexion (OLE DB, Excel, fichiers plats), sources et destinations, mappings de colonnes, boucle Foreach et exécution.

- **`rapport/`** — compte rendu illustré par 39 captures, du Data Warehouse BikeStores aux chargements de fichiers.

### 05 — Unity 3D
Construction d'une scène 3D de type **système solaire** : organisation des assets, création d'objets, application des textures planétaires, caméra et test en mode Play (avec une phase de débogage de l'Input System).

- **`projet/My project (2)/`**, **`projet/tp_2_ar/`** — projets Unity.
- **`projet/TexturePlanetes/`** (+ archive `.rar`) — textures des planètes.
- **`rapport/`** — compte rendu illustré.

---

## Structure du dépôt

```
AHMED_BENAHMED_TPs/
├── 01-git-github/
│   ├── projet/        # git-exercices/, new-repo/
│   └── rapport/       # report.typ, figures/, media/, build/*.pdf
├── 02-uml/
│   └── rapport/       # report.typ, diagrams/ (.mmd), figures/, build/*.pdf
├── 03-power-bi/
│   ├── projet/        # tp1..tp4.pbix
│   └── rapport/
├── 04-sql-server-ssis/
│   └── rapport/
├── 05-unity/
│   ├── projet/        # projets Unity + textures
│   └── rapport/
├── .gitignore
└── README.md
```

---

## Les rapports (Typst)

Les comptes rendus sont rédigés avec **[Typst](https://typst.app/)**. Chaque dossier `rapport/` contient :

- `report.typ` — le code source du rapport ;
- `figures/` — les captures ou diagrammes intégrés ;
- `media/` — les logos de la page de garde ;
- `build/` — le **PDF** déjà compilé.

### Recompiler un rapport

Avec Typst installé (la police *Libertinus Serif* est fournie avec Typst) :

```bash
cd 03-power-bi/rapport
typst compile --root . report.typ build/tp_power_bi_ahmed_report.pdf
```

Adapter le chemin et le nom du PDF selon le TP.

---

## Ouvrir les projets

- **Git** — `git log`, `git branch -a` dans `01-git-github/projet/git-exercices/` (l'historique d'origine n'est pas inclus ; ce sont les fichiers de travail).
- **Power BI** — ouvrir les `.pbix` avec **Power BI Desktop**.
- **Unity** — ouvrir les dossiers de `05-unity/projet/` avec **Unity Hub** (les dossiers `Library/`, `Temp/`, `Logs/` sont régénérés automatiquement à l'ouverture et ne sont pas versionnés).

---

## Auteur

**Ahmed Benahmed** — ENSAB, Ingénierie des Systèmes d'Information et Big Data — 2025/2026.
