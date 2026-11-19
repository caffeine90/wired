#!/bin/bash
# List all peers and show their configs

set -e

echo "=== WireGuard Peers ==="
docker exec wireguard wg show

echo ""
echo "=== Client Configs ==="

for dir in ./config/peer_*/; do
    if [ -d "$dir" ]; then
        peer_name=$(basename "$dir" | sed 's/peer_//')
        echo ""
        echo "--- $peer_name ---"
        cat "$dir/peer_${peer_name}.conf"
    fi
done

echo ""
echo "=== QR Codes (for mobile) ==="
for dir in ./config/peer_*/; do
    if [ -d "$dir" ]; then
        peer_name=$(basename "$dir" | sed 's/peer_//')
        echo ""
        echo "--- $peer_name ---"
        docker exec wireguard /app/show-peer "$peer_name" 2>/dev/null | grep -A 100 "QR" | head -20
    fi
done