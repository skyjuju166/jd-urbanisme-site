# 🎲 Scores — Application de comptage pour jeux de société

Application web autonome (une seule page) pour compter les points des joueurs
pendant vos parties de jeux de société.

**Sans rapport avec le site d'urbanisme** : c'est une page web indépendante,
qui vit dans son propre dossier `jeux-scores/`.

## Fonctionnalités

- **Créer une nouvelle partie** en un bouton
- Choix du **nombre de joueurs** (1 à 20)
- Saisie du **nom de chaque joueur**
- À chaque score saisi, il **s'additionne au total précédent** du joueur
- Points négatifs acceptés (pour se retirer des points)
- Classement automatique + couronne 👑 pour celui qui mène
- Historique des points par joueur (chaque point est supprimable)
- Plusieurs parties enregistrées en parallèle
- Renommer / supprimer une partie, réinitialiser les scores
- **100 % hors-ligne** : les données sont stockées dans le navigateur
  (localStorage). Aucun serveur, aucune base de données requise.

## Déploiement sur Synology avec Docker (Container Manager)

Sur DSM 7.2+, l'application Docker s'appelle **Container Manager**
(Centre de paquets → installer « Container Manager »).

Le projet est **prêt à l'emploi** : décompressez le dossier `jeux-scores`
n'importe où sur le NAS, puis créez le projet. Aucun chemin à modifier.

### Étapes (interface graphique)

1. Avec **File Station**, déposez le dossier `jeux-scores` dans le partage
   `docker` (chemin ex. `/volume1/docker/jeux-scores`). Il doit contenir
   `index.html`, `Dockerfile` et `docker-compose.yml`.
2. Ouvrez **Container Manager → Projet → Créer**.
   - **Nom du projet** : `jeux-scores`
   - **Chemin** : sélectionnez le dossier `docker/jeux-scores`
   - **Source** : « Utiliser un docker-compose.yml existant »
     (Container Manager détecte le fichier fourni). Ne modifiez rien.
3. **Suivant → Terminé**. Container Manager construit l'image puis démarre
   le conteneur (comptez une minute la première fois).
4. Ouvrez l'application : **`http://IP-DU-NAS:8088`**
   (remplacez `IP-DU-NAS` par l'adresse de votre NAS, ex. `192.168.1.20`).

> Si le port 8088 est déjà utilisé, changez `"8088:80"` en `"8090:80"`
> (ou un autre) dans `docker-compose.yml`, puis reconstruisez le projet.

### En ligne de commande (si SSH est activé)

```sh
cd /volume1/docker/jeux-scores
docker compose up -d      # ou : docker-compose up -d
# puis ouvrez http://IP-DU-NAS:8088
```

### Mettre à jour l'application plus tard

Remplacez `index.html` par la nouvelle version, puis dans Container Manager
ouvrez le projet et cliquez **Construire** (ou `docker compose up -d --build`
en SSH).

### Accès depuis l'extérieur (optionnel)

Par défaut l'appli n'est accessible que sur votre réseau local. Pour y
accéder à distance, utilisez de préférence le **VPN Synology** ou un
**reverse proxy DSM** (Panneau de configuration → Portail de connexion →
Proxy inversé) avec un certificat HTTPS, plutôt que d'ouvrir directement le
port 8088 sur Internet.

## Note sur les données

Les parties sont enregistrées **dans le navigateur utilisé** (localStorage).
Elles restent donc sur l'appareil/le navigateur avec lequel vous jouez.
Pour jouer à plusieurs sur le même écran (tablette, ordinateur portable),
utilisez toujours le même navigateur : la partie en cours sera retrouvée.
