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

## Déploiement sur Synology

L'application est un simple fichier `index.html` statique. Trois options :

### Option A — Web Station (recommandé)
1. Ouvrez le **Centre de paquets** et installez **Web Station** (+ un
   serveur web comme Apache ou Nginx si demandé).
2. Placez le contenu de ce dossier dans le partage **`web`** de votre NAS,
   par exemple dans `web/jeux-scores/`.
3. Accédez à l'application depuis votre réseau :
   `http://IP-DU-NAS/jeux-scores/`

### Option B — Sans Web Station
1. Copiez `index.html` dans n'importe quel dossier partagé du NAS.
2. Ouvrez le fichier directement dans un navigateur
   (double-clic depuis un partage réseau, ou `file:///...`).
   Tout fonctionne, y compris la sauvegarde locale.

### Option C — Docker (si vous préférez)
```sh
docker run -d --name jeux-scores -p 8088:80 \
  -v /volume1/docker/jeux-scores:/usr/share/nginx/html:ro \
  nginx:alpine
```
Puis copiez `index.html` dans `/volume1/docker/jeux-scores/` et ouvrez
`http://IP-DU-NAS:8088/`.

## Note sur les données

Les parties sont enregistrées **dans le navigateur utilisé** (localStorage).
Elles restent donc sur l'appareil/le navigateur avec lequel vous jouez.
Pour jouer à plusieurs sur le même écran (tablette, ordinateur portable),
utilisez toujours le même navigateur : la partie en cours sera retrouvée.
