# LOG210 - Template DevContainer

Environnement de développement standardisé pour les travaux de groupe en LOG210. Tout le monde démarre sur la même base : même version de Node, même outillage, mêmes conventions de formatage.

## Prérequis

- [Docker](https://docs.docker.com/get-docker/) (Docker Desktop sur macOS/Windows, Docker Engine sur Linux)
- [Visual Studio Code](https://code.visualstudio.com/)
- Extension VSCode [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Démarrage

1. Sur GitHub, cliquer sur **Use this template** pour créer le repo de ton équipe.
2. Cloner le nouveau repo localement.
3. Ouvrir le dossier dans VSCode.
4. Accepter le prompt _"Reopen in Container"_, ou `Ctrl/Cmd+Shift+P` -> `Dev Containers: Reopen in Container`.
5. Attendre la fin du build (~3-5 min la première fois, instantané ensuite).

Une fois dans le conteneur :

```bash
bash .devcontainer/setup-git-personal.sh   # Configure ton identité Git (une fois)
npm install                                 # Installe les dépendances
npm test                                    # Vérifie que tout marche
````

## Stack technique

| Outil             | Version         | Rôle                         |
| ----------------- | --------------- | ---------------------------- |
| Node.js           | 24 LTS          | Runtime                      |
| TypeScript        | 5.7             | Langage principal            |
| Jest              | 29              | Tests unitaires              |
| ts-jest           | 29              | Transformer Jest pour TS     |
| ESLint            | 9 (flat config) | Linting                      |
| typescript-eslint | 8               | Règles ESLint spécifiques TS |
| Prettier          | 3               | Formatage automatique        |
| PlantUML          | 1.2026.2        | Diagrammes UML               |
| Graphviz          | 2.x             | Backend de rendu PlantUML    |

## Commandes courantes

| Commande                | Effet                                               |
| ----------------------- | --------------------------------------------------- |
| `npm test`              | Lance la suite Jest                                 |
| `npm run test:watch`    | Tests en mode watch                                 |
| `npm run test:coverage` | Tests + rapport de couverture (dossier `coverage/`) |
| `npm run lint`          | Vérifie le code avec ESLint                         |
| `npm run lint:fix`      | Corrige les erreurs ESLint auto-fixables            |
| `npm run format`        | Reformate tout le projet avec Prettier              |
| `npm run format:check`  | Vérifie sans réécrire                               |
| `npm run build`         | Compile TypeScript vers `dist/`                     |

## PlantUML

Place tes diagrammes dans `docs/diagrams/` avec l’extension `.puml`.

**Aperçu dans VSCode** : ouvre le fichier `.puml`, place le curseur **entre** `@startuml` et `@enduml`, puis `Alt+D`.

**Génération en ligne de commande** :

```bash
plantuml -tsvg docs/diagrams/mon-diagramme.puml   # SVG (recommandé)
plantuml -tpng docs/diagrams/mon-diagramme.puml   # PNG
plantuml -tpdf docs/diagrams/mon-diagramme.puml   # PDF
```

## Structure du projet

```sh
.
├── .devcontainer/
│   ├── devcontainer.json          # Config principale du conteneur
│   ├── setup-plantuml.sh          # Installe PlantUML + JRE + Graphviz (auto)
│   ├── setup-shell.sh             # Personnalise le prompt bash (auto)
│   └── setup-git-personal.sh      # Identité Git (manuel, une fois)
├── .vscode/
│   └── settings.json              # Paramètres VSCode appliqués au repo
├── docs/
│   └── diagrams/                  # Diagrammes PlantUML (.puml)
│       └── test.puml
├── .gitignore
├── .prettierrc                    # Config Prettier
├── package.json
└── README.md
```

## Conventions de code

Définies par `.prettierrc` et appliquées automatiquement à la sauvegarde (`formatOnSave`) :

- **Indentation** : 4 espaces (2 pour YAML et `package.json`, qui ont des contraintes externes)
- **Sans point-virgule** en fin de ligne (Prettier en ajoute défensivement quand nécessaire)
- **Guillemets simples** pour les strings
- **Virgules finales** partout (Prettier 3 par défaut)
- **Largeur** : 80 caractères
- **Fin de ligne** : LF (pas CRLF)

ESLint applique `typescript-eslint/recommended` : interdiction des `any` implicites, des variables inutilisées, etc.

## Configuration Git par utilisateur

Le script `setup-git-personal.sh` configure ton `user.name` et `user.email` au niveau global du conteneur. Il est **manuel** par design : on ne veut pas que l’identité d’un coéquipier se retrouve codée en dur dans le template.

VSCode Dev Containers propage normalement automatiquement le `~/.gitconfig` du host. Si c’est déjà le cas pour toi, le script détecte la configuration existante et te propose de la conserver.

## Dépannage

**Le build échoue avec "no space left on device"**
Docker manque d’espace. `docker system prune -a` (attention : supprime tous les conteneurs et images inutilisés).

**Le preview PlantUML affiche "No valid diagram found here!"**
Le curseur doit être entre `@startuml` et `@enduml`. C’est l’extension `jebbs.plantuml` qui regarde la position du curseur, pas un bug.

**Les tests Jest ne tournent pas dans VSCode**
Lance `npm install` une fois dans le terminal du conteneur. L’extension Jest a besoin des `node_modules` pour découvrir la config.

**Permissions denied sur les fichiers du workspace** (Linux uniquement)
Vérifie ton UID host : `id -u`. S’il n’est pas 1000, Dev Containers est supposé remapper automatiquement, mais si ça échoue : reconstruis le conteneur.

**TypeScript ne résout pas les types après `npm install`**
`Ctrl+Shift+P` -> `TypeScript: Restart TS Server`. Au premier démarrage, VSCode peut proposer de basculer sur le TS du workspace : accepter.

## Mises à jour du template

Les changements faits sur le template original ne se propagent pas automatiquement aux repos créés à partir du template. Si une mise à jour critique est annoncée (ex : bump de version Node, correctif de sécurité), copier manuellement les fichiers `.devcontainer/` et les configs concernées.
