# TP UML - Ahmed Benahmed

Package Typst du rapport UML.

## Generer les diagrammes

```bash
nix shell nixpkgs#mermaid-cli -c mmdc -i diagrams/ecommerce_usecase.mmd -o figures/ecommerce_usecase.png
```

Repeter la commande pour chaque fichier `.mmd` dans `diagrams/`.

## Build

```bash
typst compile --root . report.typ build/tp_uml_ahmed_report.pdf
```

## Contenu

- `report.typ` : source Typst du rapport.
- `media/` : logos utilises par la page de garde.
- `diagrams/` : sources Mermaid des diagrammes UML.
- `figures/` : exports PNG des diagrammes.
- `build/` : PDF compile.
