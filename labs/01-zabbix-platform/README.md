# Lab 01 — Zabbix Platform Deployment

## Objective

Deploy and validate a reproducible Zabbix 7.0 LTS monitoring platform using Docker Compose.

This stage establishes the core monitoring services required for the subsequent Linux, Windows, network, service, and incident-response laboratories.

## Learning Outcomes

After completing this laboratory, the operator can:

- validate container image availability;
- manage local environment variables without publishing secrets;
- validate a Docker Compose model before deployment;
- deploy PostgreSQL, Zabbix Server, and Zabbix Web;
- verify container state, health, and restart counters;
- validate the Zabbix database schema;
- confirm application and frontend versions;
- test TCP and HTTP availability;
- replace default administrative credentials;
- identify and acknowledge a monitoring problem;
- distinguish acknowledgment from resolution;
- investigate an incorrectly applied monitoring template;
- reduce monitoring noise from unused optional components;
- confirm service recovery after corrective action.

## Platform Components

| Component | Image | Purpose |
|---|---|---|
| PostgreSQL | `postgres:16.15-alpine3.24` | Persistent Zabbix configuration and monitoring database |
| Zabbix Server | `zabbix/zabbix-server-pgsql:ubuntu-7.0.30` | Data collection, trigger evaluation, event processing, and monitoring logic |
| Zabbix Web | `zabbix/zabbix-web-nginx-pgsql:ubuntu-7.0.30` | Web administration and NOC operations interface |

## Network Design

The platform uses three Docker networks with different responsibilities.

| Network | Purpose |
|---|---|
| `backend` | Isolated communication between PostgreSQL, Zabbix Server, and Zabbix Web |
| `frontend` | Access to the Zabbix web interface |
| `monitoring` | Communication between Zabbix Server and future monitored services |

The `backend` network is configured as internal. PostgreSQL is not published to the Windows workstation.

Only the following ports are published:

| Workstation endpoint | Container endpoint | Purpose |
|---|---|---|
| `127.0.0.1:8080` | `zabbix-web:8080` | Local Zabbix web interface |
| `127.0.0.1:10051` | `zabbix-server:10051` | Zabbix Server communication |

Binding the ports to `127.0.0.1` prevents direct access from other devices on the local network during this stage.

## Persistent Data

The named volume `postgres-data` stores the PostgreSQL database.

The volume remains available when the containers are stopped or recreated without volume removal.

The following command stops the platform while preserving its data:

```powershell
docker compose --env-file .env down
