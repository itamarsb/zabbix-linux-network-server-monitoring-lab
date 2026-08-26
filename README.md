# Zabbix NOC Operations Lab

[![Zabbix](https://img.shields.io/badge/Zabbix-7.0%20LTS-D40000?logo=zabbix&logoColor=white)](https://www.zabbix.com/)

[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)

[![Linux](https://img.shields.io/badge/Linux-Monitoring-FCC624?logo=linux&logoColor=black)](https://www.kernel.org/)

[![Windows](https://img.shields.io/badge/Windows-Monitoring-0078D4?logo=windows&logoColor=white)](https://www.microsoft.com/windows/)

[![Status](https://img.shields.io/badge/Status-Under%20Development-orange)](#implementation-roadmap)

A practical Network Operations Center laboratory focused on infrastructure monitoring, alert triage, troubleshooting, incident response, service restoration, and operational documentation.

The project uses Zabbix as its central monitoring platform and reproduces common NOC workflows across Linux, Windows, network connectivity, and HTTP services.

## Project Purpose

This repository demonstrates the operational cycle expected in monitoring and infrastructure support environments:

```text

Monitor â†’ Detect â†’ Validate â†’ Acknowledge â†’ Investigate

â†’ Escalate or Restore â†’ Confirm Recovery â†’ Document

```

The objective is not limited to installing Zabbix. Each implementation stage includes validation, failure simulation, troubleshooting, recovery, and evidence of the completed activity.

## Core Objectives

- Deploy a reproducible Zabbix 7.0 LTS environment.

- Monitor Linux and Windows hosts with Zabbix Agent 2.

- Monitor host availability, resources, processes, and services.

- Validate ICMP, DNS, TCP port, and HTTP availability.

- Configure items, triggers, events, problems, and actions.

- Classify alerts according to operational severity.

- Simulate infrastructure and application incidents.

- Practice acknowledgment, investigation, escalation, and recovery.

- Create reusable troubleshooting runbooks.

- Document incidents, maintenance windows, and shift activities.

- Introduce SNMP monitoring for network-oriented scenarios.

- Use Grafana only as an optional visualization layer after the core Zabbix workflows are complete.

## Architecture Overview

```mermaid

flowchart TD

&#x20;   Operator["NOC Operator"]

&#x20;   Web["Zabbix Web"]

&#x20;   Server["Zabbix Server"]

&#x20;   Database["PostgreSQL"]

&#x20;   Targets["Linux, Windows and Services"]

&#x20;   Operator --> Web

&#x20;   Web --> Server

&#x20;   Server --> Database

&#x20;   Server <--> Targets

```

The initial platform runs locally through Docker Desktop and WSL 2. PostgreSQL remains isolated inside the Docker network, while only the interfaces required for administration and monitoring are exposed to the workstation.

## Monitoring Scope

| Area | Planned coverage |

|---|---|

| Host availability | Agent availability, ICMP reachability and response time |

| Linux | CPU, memory, disk, processes, services, logs and network interfaces |

| Windows | CPU, memory, disk, services, event information and Agent 2 |

| Network | ICMP, packet loss, latency, DNS resolution and TCP connectivity |

| HTTP services | Availability, response status, response time and service failure |

| Zabbix operations | Hosts, templates, items, triggers, events, problems and actions |

| Incident handling | Triage, acknowledgment, notes, severity, escalation and recovery |

| Maintenance | Planned downtime, alert suppression and post-maintenance validation |

| Reporting | Incident tickets, operational checklists and shift reports |

| Network devices | Introductory SNMP monitoring |

| Visualization | Native Zabbix dashboards and optional Grafana integration |

## Incident Scenarios

The laboratory will reproduce scenarios commonly handled by NOC and infrastructure teams:

- monitored host unavailable;

- Zabbix Agent 2 unavailable;

- HTTP service stopped;

- TCP port inaccessible;

- DNS resolution failure;

- high CPU utilization;

- low available disk space;

- abnormal memory utilization;

- network latency or packet loss;

- service blocked by a local firewall;

- planned maintenance generating unnecessary alerts;

- poorly tuned trigger producing a false positive.

Each scenario must contain detection evidence, diagnostic steps, corrective action, recovery validation, and an operational record.

## Troubleshooting Method

The laboratories follow a consistent troubleshooting process:

1. Identify the alert source and affected asset.

2. Validate whether the problem is current and reproducible.

3. Determine the impact, scope, and severity.

4. Check connectivity, system resources, services, ports, and logs.

5. Compare recent changes and related events.

6. Apply the documented recovery procedure when authorized.

7. Escalate when the issue exceeds the operator's access or responsibility.

8. Confirm service recovery from both the system and monitoring perspectives.

9. Record actions, timestamps, findings, and follow-up recommendations.

## Repository Structure

```text

.

â”œâ”€â”€ config/                         # Version-controlled monitoring configuration

â”œâ”€â”€ docs/                           # Architecture and operational documentation

â”‚   â”œâ”€â”€ evidence/                   # Selected technical evidence

â”‚   â””â”€â”€ images/                     # Diagrams and repository images

â”œâ”€â”€ incidents/                      # Incident templates and executed scenarios

â”œâ”€â”€ labs/                           # Guided implementation and validation stages

â”‚   â””â”€â”€ 00-workstation-validation/

â”œâ”€â”€ runbooks/                       # Troubleshooting and recovery procedures

â”œâ”€â”€ scripts/

â”‚   â”œâ”€â”€ bash/                       # Linux validation and diagnostic scripts

â”‚   â””â”€â”€ powershell/                 # Windows validation and diagnostic scripts

â”œâ”€â”€ templates/                      # Tickets, reports and maintenance records

â”œâ”€â”€ .env.example                    # Safe environment variable template

â”œâ”€â”€ .gitignore

â”œâ”€â”€ compose.yaml                    # Reproducible Zabbix platform

â””â”€â”€ README.md

```

Directories are added only when they contain implemented and validated material. Empty folders are not retained merely to suggest future functionality.

## Implementation Roadmap

| Stage | Scope | Status |

|---:|---|---|

| 00 | Workstation validation and repository baseline | Completed |

| 01 | Zabbix platform deployment and health validation | Planned |

| 02 | Linux host monitoring with Zabbix Agent 2 | Planned |

| 03 | Windows host monitoring with Zabbix Agent 2 | Planned |

| 04 | Network, DNS, TCP, and HTTP service monitoring | Planned |

| 05 | Triggers, severities, events, and alert handling | Planned |

| 06 | Incident response and service recovery | Planned |

| 07 | Maintenance windows and operational reporting | Planned |

| 08 | Introductory SNMP and optional Grafana integration | Planned |

A stage is marked as completed only after its implementation, validation, troubleshooting notes, and relevant evidence are committed.

## Current Stage

The current stage validates the workstation before any service deployment. It verifies:

- Windows and PowerShell versions;

- processor, memory, and available disk space;

- WSL 2 status;

- Docker Engine and Docker Compose;

- Docker CPU and memory availability;

- required local ports;

- DNS resolution;

- HTTPS connectivity;

- existing containers, networks, and volumes;

- Git repository status.

This baseline reduces deployment errors and prevents accidental conflicts with other local laboratory environments.

## Operational Documentation

The project will include documentation used in real monitoring routines:

- workstation and platform validation records;

- network topology;

- operations checklist;

- severity and escalation matrix;

- incident ticket template;

- maintenance request template;

- shift report template;

- troubleshooting runbooks;

- completed incident scenarios.

Documentation is linked to activities that were actually executed. The repository avoids speculative procedures and excessive documentation without operational evidence.

## Evidence Policy

Evidence is selected to demonstrate meaningful technical results rather than every mouse click.

Acceptable evidence includes:

- Zabbix host and item availability;

- trigger transition from `OK` to `PROBLEM`;

- acknowledged incident with an operational note;

- diagnostic command output;

- confirmed service recovery;

- trigger transition back to `OK`;

- maintenance period configuration;

- completed incident or shift report.

Screenshots containing credentials, tokens, private addresses, personal information, or unrelated desktop content must not be committed.

## Security Practices

- Secrets and credentials are excluded from version control.

- PostgreSQL is not published directly to the Windows host.

- Environment-specific values are stored outside tracked files.

- Example configuration uses placeholders instead of real passwords.

- Private keys and certificates are ignored by Git.

- Monitoring access is restricted to the interfaces required by the lab.

- Diagnostic evidence is reviewed before publication.

## Technology Stack

- Zabbix 7.0 LTS

- Zabbix Agent 2

- PostgreSQL

- Docker Desktop

- Docker Compose

- WSL 2

- Linux

- Windows PowerShell

- Nginx

- SNMP

- Grafana â€” optional final-stage visualization

## Skills Demonstrated

- infrastructure and service monitoring;

- NOC alert triage;

- Linux and Windows administration;

- network connectivity validation;

- incident response;

- troubleshooting methodology;

- service restoration;

- operational escalation;

- maintenance coordination;

- technical documentation;

- monitoring-as-code fundamentals;

- Docker-based environment management.

## Project Status

The repository is under active development. Stage 00 established and validated the workstation baseline, repository structure, Docker capacity, required ports, DNS resolution, HTTPS connectivity, WSL 2, and Git state. Stage 01 will introduce the reproducible Zabbix platform.

---

This project is a controlled laboratory environment intended for learning, portfolio demonstration, and operational practice. It is not a production deployment guide.
