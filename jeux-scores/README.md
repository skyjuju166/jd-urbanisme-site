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

Deux méthodes : la **A** (dossier monté) est la plus simple et permet de
mettre à jour l'appli en remplaçant juste le fichier `index.html`.

### Méthode A — Image nginx + dossier monté (recommandée, aucune build)

1. **Créez le dossier** sur le NAS avec File Station, par ex.
   `docker/jeux-scores` (chemin complet : `/volume1/docker/jeux-scores`).
2. **Copiez-y `index.html`** (ce fichier, depuis ce dossier).
3. Ouvrez **Container Manager → Projet → Créer**.
   - Nom du projet : `jeux-scores`
   - Chemin : sélectionnez le dossier `docker/jeux-scores`
   - Source : **Créer docker-compose.yml** et collez le contenu du fichier
     `docker-compose.yml` fourni ici (vérifiez le chemin
     `/volume1/docker/jeux-scores` et le port `8088`).
4. Cliquez **Suivant → Terminé**. Container Manager télécharge l'image et
   démarre le conteneur.
5. Ouvrez l'application : **`http://IP-DU-NAS:8088`**
   (remplacez `IP-DU-NAS` par l'adresse de votre NAS, ex. `192.168.1.20`).

> Mise à jour ultérieure : il suffit de remplacer `index.html` dans le
> dossier, puis de rafraîchir la page dans le navigateur. Pas besoin de
> reconstruire le conteneur.

### Méthode B — Construire l'image depuis le Dockerfile

Si vous préférez une image autonome (le HTML est embarqué dedans) :

1. Copiez tout ce dossier (`Dockerfile` + `index.html`) sur le NAS, par ex.
   dans `/volume1/docker/jeux-scores-build`.
2. **Container Manager → Image → Ajouter → Ajouter depuis un dossier**,
   sélectionnez ce dossier, nommez l'image `jeux-scores:latest`.
3. **Container Manager → Conteneur → Créer**, choisissez l'image
   `jeux-scores:latest`, mappez le port local `8088` vers le port `80` du
   conteneur, activez le redémarrage automatique, puis démarrez.
4. Ouvrez **`http://IP-DU-NAS:8088`**.

### En ligne de commande (si SSH est activé)

```sh
# Méthode A, équivalent CLI :
sudo mkdir -p /volume1/docker/jeux-scores
# (copiez index.html dans ce dossier)
docker run -d --name jeux-scores --restart unless-stopped -p 8088:80 \
  -v /volume1/docker/jeux-scores:/usr/share/nginx/html:ro \
  nginx:alpine
```

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
