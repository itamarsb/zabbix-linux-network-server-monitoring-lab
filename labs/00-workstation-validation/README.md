# Lab 00 - Workstation Validation

[Back to the main README](../../README.md)

## Objective

Validate the local workstation before deploying the Zabbix platform.

The initial checks cover Windows, PowerShell, WSL, Docker, networking, storage, and repository state. Checking these prerequisites before deployment helps identify resource limits and conflicts with existing laboratory services.

## Operational Context

Before deploying a monitoring platform, an operations engineer should verify whether the target environment satisfies the implementation requirements.

Skipping this baseline can result in:

- insufficient CPU, memory, or disk capacity;
- unavailable TCP ports;
- inactive Docker services;
- incompatible WSL configuration;
- DNS or internet connectivity failures;
- conflicts with existing containers and networks;
- accidental modification of unrelated laboratory data;
- deployment failures incorrectly attributed to Zabbix.

> Validate the environment before deploying the service.

## Scope

The workstation validation covers:

- Windows version and architecture;
- processor and physical memory;
- available disk capacity;
- PowerShell version;
- WSL 2 and its active kernel;
- Docker client and server;
- Docker Compose;
- resources available to Docker;
- existing containers, networks, and volumes;
- required TCP ports;
- DNS resolution;
- outbound HTTPS connectivity;
- Git installation and repository state.

## Environment Baseline

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
| WSL kernel | 6.18.33.2-microsoft-standard-WSL2 |
| Default WSL distribution | Ubuntu 24.04 |
| WSL generation | WSL 2 |
| Docker Desktop | 4.85.0 |
| Docker Engine | 29.6.2 |
| Docker Compose | 5.3.1 |
| Docker CPU capacity | 8 logical processors |
| Docker memory capacity | 14.60 GB |
| Git | 2.55.0.windows.3 |

The baseline was collected on August 26, 2026. Available disk space and software versions may change during future executions.

## Planned Platform Allocation

| Component | Initial approach |
|---|---|
| PostgreSQL | Internal Docker service with persistent storage |
| Zabbix Server | Local workload with conservative resource usage |
| Zabbix Web | One frontend instance |
| Linux monitored host | Lightweight container |
| Nginx test service | Lightweight container |
| Expected total memory | Approximately 3-4 GB |
| Docker network | Project-specific bridge network |
| Database exposure | Internal Docker network only |

The workstation has sufficient capacity to run the planned stack while preserving resources for Windows, Docker Desktop, and normal workstation activities.

**Architecture evolution:** This table records the initial platform allocation planned during Stage 00. During Stage 02, the Linux monitoring target was implemented using Ubuntu 24.04 LTS under WSL 2 instead of the originally proposed lightweight Docker container. Zabbix Agent 2 runs on the WSL 2 host and communicates with the containerized Zabbix Server through the private Docker/WSL network. The implementation and its validation are documented in [Stage 02](../02-linux-host-monitoring/README.md).

## Required Ports

| Port | Protocol | Planned purpose | Baseline result | Verification method |
|:---:|:---:|---|:---:|---|
| 8080 | TCP | Zabbix web interface | Available | Local Windows listener check (`Get-NetTCPConnection`) |
| 8443 | TCP | Optional HTTPS interface | Available | Local Windows listener check (`Get-NetTCPConnection`) |
| 10050 | TCP | Zabbix Agent 2 | Available | Local Windows listener check (`Get-NetTCPConnection`) |
| 10051 | TCP | Zabbix Server | Available | Local Windows listener check (`Get-NetTCPConnection`) |
| 5432 | TCP | PostgreSQL internal service | Available; host publication not planned | Not checked as a local port by the tracked script |
| 80 | TCP | Optional HTTP test service | Available | Not checked as a local port by the tracked script |
| 443 | TCP | Outbound HTTPS and optional TLS service | Available | Outbound TCP `443` connectivity to documented remote targets; local availability not checked |

**Validation scope:** The Stage 00 script checks for existing Windows TCP listeners on ports `8080`, `8443`, `10050`, and `10051`. It also validates outbound TCP connectivity to port `443` on the documented remote targets. Local availability of ports `5432`, `80`, and `443` is not verified by the tracked script. The original baseline entries are retained as historical records, but they should not be interpreted as evidence of additional checks or guaranteed future port availability.

Port availability is time-sensitive. The validation script must be executed again before platform deployment.

## Existing Docker Resources

The workstation contained resources belonging to other projects:

- stopped container `grafana-lab-01`;
- network `01-grafana-dashboard-design-fundamentals_default`;
- Grafana laboratory storage volume;
- persistent volumes belonging to the hybrid observability project.

These resources were identified but not removed, renamed, or modified.

Preserving unrelated containers, networks, images, and volumes is part of safe operational practice.

## Validation Procedure

Run the validation script from the repository root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
    -File .\scripts\powershell\validate-workstation.ps1
```

The script performs read-only checks. It does not:

- install or update software;
- remove containers, images, networks, or volumes;
- change WSL settings;
- modify firewall rules;
- reserve or publish ports;
- start the Zabbix platform;
- modify the Git repository.

The script performs outbound DNS and TCP 443 tests only against the documented validation targets.

## Acceptance Criteria

| Requirement | Acceptance condition |
|---|---|
| Operating system | 64-bit Windows |
| Processor | At least 4 logical processors |
| Physical memory | At least 8 GB |
| Free disk space | At least 20 GB |
| WSL | WSL 2 kernel available |
| Docker | Client and Linux server respond successfully |
| Docker Compose | `docker compose` command available |
| Docker memory | At least 4 GB available |
| DNS | `github.com` and `zabbix.com` resolve successfully |
| HTTPS | TCP 443 connectivity succeeds |
| Web interface port | TCP 8080 available before deployment |
| Zabbix server port | TCP 10051 available before deployment |
| Git repository | Git repository context detected successfully |

An optional check may generate a warning without rejecting the workstation. For example, an occupied optional port can be safely remapped in the Compose configuration.

## Validation Results

| Validation area | Result |
|---|:---:|
| Windows architecture | Passed |
| Logical processors | Passed |
| Physical memory | Passed |
| Disk capacity | Passed |
| PowerShell | Passed |
| WSL 2 kernel | Passed |
| Docker CLI and server | Passed |
| Docker Compose | Passed |
| Docker CPU and memory | Passed |
| Local TCP listener checks (`8080`, `8443`, `10050`, `10051`) | Passed |
| DNS resolution | Passed |
| HTTPS connectivity | Passed |
| Git repository context | Passed |
| Conflicts with active stacks | None detected |
| Overall result | Approved |

Final script summary:

```text
Passed:   20
Warnings: 0
Failed:   0

RESULT: WORKSTATION APPROVED
```

## Findings

### Windows product name discrepancy

An initial legacy Windows query returned `Windows 10 Pro` while reporting build `26200.9168`.

A subsequent operating-system inventory correctly identified `Microsoft Windows 11 Pro`. The legacy product-name field did not affect PowerShell, WSL, Docker, or the Zabbix laboratory.

### PowerShell edition

The workstation uses Windows PowerShell 5.1. Scripts in this repository remain compatible with PowerShell 5.1 unless a later laboratory explicitly requires PowerShell 7.

### WSL validation

Parsing the localized output from `wsl --list --verbose` produced an initial false warning.

The validation was improved to query the active kernel directly:

```powershell
wsl.exe --exec uname -r
```

The returned kernel was:

```text
6.18.33.2-microsoft-standard-WSL2
```

This confirmed that the default distribution operates with WSL 2.

### WSL resource management

No custom `.wslconfig` file was found. WSL therefore uses its default dynamic resource management.

Docker reported access to 8 logical processors and 14.60 GB of memory, satisfying the planned laboratory requirements.

## Troubleshooting Reference

### Docker client responds but the server does not

1. Confirm that Docker Desktop is running.
2. Check the active Docker context:

```powershell
docker context show
docker context ls
```

3. Confirm that `desktop-linux` is active.
4. Restart Docker Desktop if its Linux backend remains unavailable.
5. Run `docker version` again and confirm that both Client and Server sections appear.

### WSL distribution is stopped

A stopped Ubuntu distribution is not necessarily an error. WSL starts distributions on demand.

Check the configured distributions:

```powershell
wsl --list --verbose
```

Validate the active kernel:

```powershell
wsl.exe --exec uname -r
```

The kernel output should identify Microsoft WSL 2.

### Required port is occupied

Identify the listening connection:

```powershell
Get-NetTCPConnection -LocalPort 8080 -State Listen
```

Use the returned process identifier to find its owner:

```powershell
Get-Process -Id <PROCESS_ID>
```

Do not terminate a process without confirming its purpose and ownership. Prefer a safe port remapping when the existing service belongs to another project.

### DNS resolution fails

Test the configured resolver:

```powershell
Resolve-DnsName zabbix.com
```

Validate outbound TCP connectivity:

```powershell
Test-NetConnection zabbix.com -Port 443
```

Review VPN, proxy, firewall, and local DNS settings before changing the workstation configuration.

## Evidence

The executed validation confirmed:

- workstation compute and storage capacity;
- Windows and PowerShell inventory;
- WSL 2 kernel availability;
- Docker client and server operation;
- Docker Compose availability;
- Docker CPU and memory capacity;
- absence of local Windows TCP listeners on ports `8080`, `8443`, `10050`, and `10051` at validation time;
- DNS resolution;
- outbound HTTPS connectivity;
- preservation of unrelated Docker resources;
- Git working-tree detection and current-branch query.

**Git validation scope:** The Stage 00 script confirms that the execution directory belongs to a Git working tree and queries the current branch. It does not verify working-tree cleanliness, uncommitted changes, or synchronization with a remote repository. These conditions require separate checks and must not be inferred from the recorded validation result.

The reusable script and documented results provide stronger technical evidence than a large collection of terminal screenshots.

If screenshots are added later, they must exclude credentials, personal information, unrelated applications, and unnecessary workstation content.

## Outcome

At the time of the Stage 00 assessment, all 20 recorded checks passed without warnings or failures, allowing work on the local Zabbix environment to proceed. This is a historical workstation baseline, not a fresh assessment of its present condition.

Stage 01 then deployed and validated PostgreSQL, Zabbix Server, and Zabbix Web.

Continue to [`Lab 01 — Zabbix Platform Deployment`](../01-zabbix-platform/README.md).

