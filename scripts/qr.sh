#!/bin/bash
# Show QR code for a peer (for mobile WireGuard app)
# Usage: ./scripts/qr.sh <peer-name>

set -e

PEER_NAME="${1}"

if [ -z "$PEER_NAME" ]; then
    echo "Usage: $0 <peer-name>"
    exit 1
fi

echo "QR code for $PEER_NAME:"
docker exec wireguard /app/show-peer "$PEER_NAME"