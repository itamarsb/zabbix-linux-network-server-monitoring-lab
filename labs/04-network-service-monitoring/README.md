# Stage 04 - Network, DNS, TCP, and HTTP Service Monitoring

## Objective

This stage introduces agentless network and service monitoring through the Zabbix Server.

The implementation will validate:

- ICMP reachability;
- ICMP response time and packet loss;
- DNS resolution;
- TCP service availability;
- HTTP service availability;
- HTTP response codes;
- HTTP response time;
- controlled service failure;
- monitoring-state changes during failure and recovery.

The stage extends the host-level monitoring completed in Stages 02 and 03 with service-oriented availability checks commonly performed by Network Operations Center teams.

## Current Status

Stage 04 is in progress.

The initial Windows-side and Docker-side connectivity baselines have been completed.

The baseline confirmed:

- local Zabbix Web availability on TCP port `8080`;
- local Zabbix Server availability on TCP port `10051`;
- local Windows Agent 2 availability on TCP port `10050`;
- successful HTTP response from the local Zabbix frontend;
- functional public DNS resolution;
- functional local and external ICMP connectivity;
- Docker DNS resolution from the Zabbix Server container;
- access to internal Docker services through stable service names;
- availability of the utilities required for complementary diagnostics.

Monitoring items, web scenarios, failure simulations, recovery validation, and final evidence remain to be implemented.

## Monitoring Architecture

```mermaid
flowchart TD
    Operator["NOC Operator"]
    Frontend["Zabbix Web"]
    Server["Zabbix Server"]
    Internal["Internal Docker Services"]
    Windows["Windows Host"]
    External["Selected External Targets"]

    Operator --> Frontend
    Frontend --> Server
    Server --> Internal
    Server --> Windows
    Server --> External
