#!/bin/bash
# Add a new peer/client to WireGuard
# Usage: ./scripts/add-peer.sh <peer-name>

set -e

PEER_NAME="${1:-client}"

if [ -z "$PEER_NAME" ]; then
    echo "Usage: $0 <peer-name>"
    exit 1
fi

echo "Adding peer: $PEER_NAME"

# Use the container's built-in script to add peer
docker exec wireguard /app/add-peer.sh "$PEER_NAME"

echo ""
echo "=== Config for $PEER_NAME ==="
docker exec wireguard cat "/config/peer_${PEER_NAME}/peer_${PEER_NAME}.conf"

# Also save locally
mkdir -p "./config/peer_${PEER_NAME}"
docker exec wireguard cat "/config/peer_${PEER_NAME}/peer_${PEER_NAME}.conf" > "./config/peer_${PEER_NAME}/peer_${PEER_NAME}.conf"

echo ""
echo "Saved to ./config/peer_${PEER_NAME}/peer_${PEER_NAME}.conf"
echo ""
echo "QR code for mobile:"
docker exec wireguard /app/show-peer "$PEER_NAME" | grep -A 50 "QR"