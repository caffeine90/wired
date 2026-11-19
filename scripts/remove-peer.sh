#!/bin/bash
# Remove a peer from WireGuard
# Usage: ./scripts/remove-peer.sh <peer-name>

set -e

PEER_NAME="${1}"

if [ -z "$PEER_NAME" ]; then
    echo "Usage: $0 <peer-name>"
    exit 1
fi

echo "Removing peer: $PEER_NAME"

# Use the container's built-in script to remove peer
docker exec wireguard /app/remove-peer.sh "$PEER_NAME"

# Remove local config
rm -rf "./config/peer_${PEER_NAME}"

echo "Peer $PEER_NAME removed"