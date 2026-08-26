# Lab 00 — Workstation Validation

## Objective

Validate the local workstation before deploying the Zabbix platform.

This stage establishes a technical baseline for Docker, WSL, Windows, networking, storage, and repository state. The validation reduces deployment failures and prevents conflicts with other laboratory environments.

## Operational Context

Before deploying a monitoring platform, an operations engineer should verify whether the target environment satisfies the implementation requirements.

Skipping this baseline can result in:

- insufficient CPU, memory, or disk capacity;

- unavailable ports;

- inactive Docker services;

- incompatible WSL configuration;

- DNS or internet connectivity failures;

- conflicts with existing containers and networks;

- accidental modification of unrelated laboratory data;

- deployment failures incorrectly attributed to Zabbix.

This laboratory follows the operational principle:

> Validate the environment before deploying the service.

## Scope

The workstation validation covers:

- Windows version and architecture;

- processor and physical memory;

- available disk capacity;

- PowerShell version;

- WSL version and distributions;

- Docker client and server;

- Docker Compose;

- resources available to Docker;

- existing containers, networks, and volumes;

- required TCP ports;

- DNS resolution;

- outbound HTTPS connectivity;

- Git installation and repository status.

## Environment

| Component | Detected configuration |

|---|---|

| Workstation OS | Windows 11 Pro, 64-bit |

| Windows build | 26200.9168 |

| Processor | AMD Ryzen 5 3500U |

| CPU capacity | 4 physical cores, 8 logical processors |

| Physical memory | 29.94 GB |

| Free disk space during validation | 233.88 GB |

| PowerShell | Windows PowerShell 5.1.26100.9168 |

| WSL | 2.7.11 |

| Default WSL distribution | Ubuntu 24.04 |

| WSL generation | WSL 2 |

| Docker Desktop | 4.85.0 |

| Docker Engine | 29.6.2 |

| Docker Compose | 5.3.1 |

| Docker CPU capacity | 8 logical processors |

| Docker memory capacity | 14.60 GB |

| Git | 2.55.0.windows.3 |

The values above represent the baseline collected on August 26, 2026. Available disk space and software versions may change during future executions.

## Planned Platform Allocation

The initial Zabbix stack will use conservative resource limits suitable for the workstation:

| Component | Initial resource approach |

|---|---|

| PostgreSQL | Internal Docker service with persistent volume |

| Zabbix Server | Limited local laboratory workload |

| Zabbix Web | One frontend instance |

| Linux monitored host | Lightweight container |

| Nginx test service | Lightweight container |

| Total expected memory | Approximately 3–4 GB |

| Docker network | Project-specific bridge network |

| Database exposure | Internal network only |

The environment leaves sufficient resources available for Windows, Docker Desktop, and other workstation activities.

## Required Ports

| Port | Protocol | Planned purpose | Baseline result |

|---:|---|---|---|

| 8080 | TCP | Zabbix web interface | Available |

| 8443 | TCP | Optional HTTPS interface | Available |

| 10050 | TCP | Zabbix Agent 2 | Available |

| 10051 | TCP | Zabbix Server | Available |

| 5432 | TCP | PostgreSQL internal service | Available, not planned for host publication |

| 80 | TCP | Optional HTTP test service | Available |

| 443 | TCP | Outbound HTTPS and optional TLS service | Available |

A port being available during this stage does not guarantee that it will remain available. The validation script should be executed again before platform deployment.

## Existing Docker Resources

The workstation contained resources from other independent projects:

- stopped container `grafana-lab-01`;

- Docker network `01-grafana-dashboard-design-fundamentals_default`;

- Grafana laboratory volume;

- persistent volumes belonging to the hybrid observability project.

These resources were identified but not removed or modified.

Preserving unrelated containers, networks, images, and volumes is part of safe operational practice.

## Validation Procedure

Run the validation script from the repository root:

```powershell

powershell.exe -NoProfile -ExecutionPolicy Bypass `

   -File .\scripts\powershell\validate-workstation.ps1

```

The script must perform read-only checks. It must not:

- install or update software;

- remove containers, images, networks, or volumes;

- change WSL settings;

- modify firewall rules;

- reserve or publish ports;

- start the Zabbix platform;

- create external network connections other than validation tests.

## Acceptance Criteria

The workstation is approved when all mandatory requirements are satisfied:

| Requirement | Acceptance condition |

|---|---|

| Operating system | 64-bit Windows |

| Processor | At least 4 logical processors |

| Physical memory | At least 8 GB |

| Free disk space | At least 20 GB |

| WSL | WSL 2 available |

| Docker | Client and Linux server respond successfully |

| Docker Compose | `docker compose` command available |

| Docker memory | At least 4 GB available |

| DNS | `github.com` and `zabbix.com` resolve successfully |

| HTTPS | TCP 443 connectivity succeeds |

| Web interface port | TCP 8080 available before deployment |

| Zabbix server port | TCP 10051 available before deployment |

| Git repository | Valid repository with an identified branch |

Some optional checks may generate warnings without failing the workstation. For example, an occupied optional port can be remapped in the Compose configuration.

## Baseline Results

| Validation area | Result |

|---|---|

| Compute capacity | Passed |

| Physical memory | Passed |

| Disk capacity | Passed |

| WSL 2 | Passed |

| Docker Engine | Passed |

| Docker Compose | Passed |

| Docker resources | Passed |

| Required ports | Passed |

| DNS resolution | Passed |

| HTTPS connectivity | Passed |

| Repository integrity | Passed |

| Conflicts with active stacks | None detected |

| Overall result | Approved |

## Findings

### Windows product name discrepancy

A legacy Windows management query identified the product name as Windows 10 Pro while reporting build `26200.9168`.

The build and workstation configuration correspond to Windows 11. The legacy product-name field does not affect Docker, WSL, PowerShell, or the Zabbix laboratory.

### PowerShell edition

The workstation currently uses Windows PowerShell 5.1. Scripts in this repository should remain compatible with PowerShell 5.1 unless a later laboratory explicitly requires PowerShell 7.

### WSL resource management

No custom `.wslconfig` file was found. WSL therefore uses its default dynamic resource management.

Docker reported access to 8 logical processors and 14.60 GB of memory, which satisfies the planned laboratory requirements.

## Troubleshooting Reference

### Docker client responds but the server does not

1. Confirm that Docker Desktop is running.

2. Check the active Docker context:

```powershell

docker context show

docker context ls

```

3. Confirm that the `desktop-linux` context is active.

4. Restart Docker Desktop if the backend remains unavailable.

5. Run `docker version` again and confirm both Client and Server sections.

### WSL distribution is stopped

A stopped Ubuntu distribution is not necessarily an error. WSL starts distributions on demand.

Validate the configured generation:

```powershell

wsl --list --verbose

```

The distribution must report version `2`.

### Required port is occupied

Identify the listening process:

```powershell

Get-NetTCPConnection -LocalPort 8080 -State Listen

```

Then identify its owner:

```powershell

Get-Process -Id <PROCESS_ID>

```

Do not terminate the process without confirming its purpose. Prefer a safe port remapping when the existing service belongs to another project.

### DNS resolution fails

Test the configured DNS resolver:

```powershell

Resolve-DnsName zabbix.com

```

Then test basic connectivity and review VPN, proxy, or local DNS settings before changing the workstation configuration.

## Evidence

The terminal output collected during this stage confirms:

- workstation capacity;

- WSL 2 availability;

- Docker client and server operation;

- Docker Compose availability;

- required port availability;

- DNS resolution;

- outbound HTTPS connectivity;

- preservation of existing Docker resources;

- clean and synchronized Git repository state.

Terminal screenshots are optional because the reusable validation script and the documented result provide stronger technical evidence. If screenshots are added, they must exclude personal paths or unrelated workstation content where practical.

## Outcome

The workstation is approved for the deployment of the local Zabbix NOC laboratory.

The next stage will create and validate the reproducible platform composed of PostgreSQL, Zabbix Server, Zabbix Web, and the initial monitored Linux service.
