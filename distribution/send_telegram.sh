#!/usr/bin/env bash
# ==============================================================================
# Intelpress — Telegram Push Dispatcher
# Uso: ./scripts/send_telegram.sh <ruta_imagen> "Texto de acompañamiento"
# ==============================================================================

set -e

BOT_TOKEN="${INTELPRESS_TELEGRAM_TOKEN:-""}"
CHAT_ID="${INTELPRESS_TELEGRAM_CHAT_ID:-""}"

IMG_PATH="$1"
CAPTION="$2"

if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
    echo "⚠️  [Telegram] Variables INTELPRESS_TELEGRAM_TOKEN o CHAT_ID no configuradas."
    echo "    Define las variables de entorno para activar el despacho por Telegram."
    exit 0
fi

if [ ! -f "$IMG_PATH" ]; then
    echo "Error: No existe la imagen $IMG_PATH"
    exit 1
fi

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendPhoto" \
    -F chat_id="${CHAT_ID}" \
    -F photo="@${IMG_PATH}" \
    -F caption="${CAPTION}" \
    -F parse_mode="Markdown" > /dev/null

echo "-> Push enviado a Telegram exitosamente."
