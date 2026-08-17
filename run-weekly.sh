#!/bin/bash
# Wrapper hebdomadaire — lancé par cron chaque lundi
# Chemin absolu partout pour que cron (sans $HOME correct) fonctionne

INSTALL_DIR="/volume1/claude-tasks/jd-urbanisme"
LOG_DIR="$INSTALL_DIR/logs"
TODAY=$(date +"%Y-%m-%d")
LOG_FILE="$LOG_DIR/run-$TODAY.log"

mkdir -p "$LOG_DIR"

echo "=== Lancement JD Urbanisme — $TODAY ===" | tee -a "$LOG_FILE"

# Mettre à jour le dépôt avant de commencer
cd "$INSTALL_DIR"
git fetch origin main 2>&1 | tee -a "$LOG_FILE"
git reset --hard origin/main 2>&1 | tee -a "$LOG_FILE"

# Injecter la date du jour dans le prompt (remplace le placeholder)
PROMPT=$(sed "s/DATE_DU_JOUR/$TODAY/g" "$INSTALL_DIR/task-prompt.txt")

# Lancer Claude Code en mode non-interactif
# --dangerously-skip-permissions : autorise toutes les actions (git, fichiers, SMTP)
# sans demander confirmation — adapté à un cron autonome
claude \
  --dangerously-skip-permissions \
  -p "$PROMPT" \
  2>&1 | tee -a "$LOG_FILE"

EXIT_CODE=${PIPESTATUS[0]}

if [[ $EXIT_CODE -eq 0 ]]; then
  echo "=== Tâche terminée avec succès ($TODAY) ===" | tee -a "$LOG_FILE"
else
  echo "=== ERREUR — code $EXIT_CODE ($TODAY) ===" | tee -a "$LOG_FILE"
fi

# Garder seulement les 12 derniers logs (3 mois)
ls -t "$LOG_DIR"/run-*.log 2>/dev/null | tail -n +13 | xargs rm -f

exit $EXIT_CODE
