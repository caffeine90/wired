#!/bin/bash
# Start WireGuard server

set -e

echo "Starting WireGuard server..."
docker compose up -d

echo "Waiting for configs to generate..."
sleep 3

echo ""
echo "=== Client Configs ==="
docker compose logs wireguard 2>&1 | grep -A 20 "Peer.*config" | head -100

echo ""
echo "Configs also saved in ./config/peer_*/"
ls -la config/peer_*/ 2>/dev/null || echo "Configs not ready yet, check logs above"