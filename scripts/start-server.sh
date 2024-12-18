#!/bin/sh
set -eux

# Precheck: Ensure PORT is a number or undefined
if [ -n "${PORT:-}" ]; then
    if ! echo "$PORT" | grep -Eq '^[0-9]+$'; then
        echo "Error: PORT must be a valid number" >&2
        exit 1
    fi
fi

# Ensure the /etc/cups/ssl directory exists with proper permissions
CUPS_SERVERROOT="/etc/cups/ssl"
if [ ! -d "$CUPS_SERVERROOT" ]; then
    mkdir -p "$CUPS_SERVERROOT"
fi
chmod 755 "$CUPS_SERVERROOT"

# Ensure /var/lib/gutenprint-printer-app directory exists
STATE_DIR="/var/lib/gutenprint-printer-app"

if [ ! -d "$STATE_DIR" ]; then
    mkdir -p "$STATE_DIR"
fi
chmod 755 "$STATE_DIR"

# Ensure gutenprint-printer-app.state file exists
STATE_FILE="$STATE_DIR/gutenprint-printer-app.state"
if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
fi
chmod 755 "$STATE_FILE"

# Start the gutenprint-printer-app server
gutenprint-printer-app -o log-file=/gutenprint-printer-app.log ${PORT:+-o server-port=$PORT} server
