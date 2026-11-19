# WireGuard VPN Server (Docker)

A ready-to-use WireGuard server with helper scripts for client management.

## Quick Start

```bash
# 1. Clone/navigate to this directory
cd /home/morteza/Projects/wireguard-server

# 2. (Optional) Customize settings
cp .env.example .env
# Edit .env with your values

# 3. Start the server
./scripts/start.sh

# 4. Get client configs
./scripts/show-peers.sh
```

## Prerequisites

- Docker & Docker Compose
- Linux host (for kernel module support)
- UDP port 51820 forwarded on router/firewall
- Root/sudo for kernel modules (handled by container)

## Directory Structure

```
wireguard-server/
├── docker-compose.yml          # Main service definition
├── .env.example                # Configuration template
├── config/                     # Generated client configs (gitignored)
│   └── peer_<name>/
│       └── peer_<name>.conf    # WireGuard config file
└── scripts/
    ├── start.sh                # Start server & show initial configs
    ├── add-peer.sh <name>      # Add new client
    ├── remove-peer.sh <name>   # Remove client
    ├── show-peers.sh           # List all clients & configs
    └── qr.sh <name>            # Show QR code for mobile
```

## Managing Clients

### Add a new client
```bash
./scripts/add-peer.sh john-phone
# Outputs config + saves to config/peer_john-phone/
```

### List all clients
```bash
./scripts/show-peers.sh
# Shows wg status + all configs + QR codes
```

### Get QR code for mobile
```bash
./scripts/qr.sh john-phone
# Scan with WireGuard mobile app
```

### Remove a client
```bash
./scripts/remove-peer.sh john-phone
```

## Client Setup

### Desktop (Linux/macOS/Windows)
```bash
# Install WireGuard, then:
sudo wg-quick up peer_john-phone.conf
```

### Mobile (iOS/Android)
1. Install **WireGuard** app
2. Tap **+** → **Create from QR code**
3. Run `./scripts/qr.sh john-phone` and scan

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `SERVERURL` | Public domain/IP (`auto` = detect) | `auto` |
| `SERVERPORT` | UDP listen port | `51820` |
| `PEERS` | Initial client count | `5` |
| `PEERDNS` | DNS for clients | `1.1.1.1,8.8.8.8` |
| `INTERNAL_SUBNET` | VPN subnet (avoid LAN conflicts) | `10.13.13` |
| `ALLOWEDIPS` | Client routing (`0.0.0.0/0` = full tunnel) | `0.0.0.0/0` |
| `PUID/PGID` | File ownership | `1000/1000` |

## Firewall / Port Forwarding

```bash
# Allow UDP 51820 on host firewall
sudo ufw allow 51820/udp

# Router: Forward UDP 51820 → server LAN IP
```

## Verify It's Working

```bash
# Check container status
docker compose ps

# View WireGuard interface
docker exec wireguard wg show

# Check logs
docker compose logs -f wireguard
```

## Troubleshooting

**No handshake / connection fails:**
- Verify UDP 51820 is forwarded on router
- Check `SERVERURL` matches public IP/domain
- Ensure `net.ipv4.ip_forward=1` on host

**Kernel module issues:**
```bash
# On host, ensure wireguard module loads
sudo modprobe wireguard
lsmod | grep wireguard
```

**Config not generating:**
```bash
# Check logs
docker compose logs wireguard | tail -50

# Restart clean
docker compose down -v && ./scripts/start.sh
```

## Security Notes

- Change `INTERNAL_SUBNET` if it conflicts with your LAN
- Use `ALLOWEDIPS=10.13.13.0/24` for split tunneling (VPN only)
- Rotate keys periodically: `docker compose down -v && ./scripts/start.sh`
- Monitor connections: `docker exec wireguard wg show`

## License

MIT - Use freely