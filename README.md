# zabbix-linux-network-server-monitoring-lab

Practical laboratory for monitoring networks, Linux servers, SNMP, Zabbix, Grafana, alerts and secure remote access.

# Network & Server Monitoring Lab

Practical laboratory for the study and implementation of professional monitoring of networks, Linux servers, SNMP devices and automated alerts using Zabbix, Grafana, Linux Server, SNMP, ZeroTier, Telegram and other tools.

## Objective

This project aims to build a monitoring environment similar to that used in companies, providers, infrastructure teams, NOCs, SREs, and Cloud Engineering.

## Technologies

- Linux Server (Ubuntu)
- Zabbix 7
- Zabbix Agent
- SNMP
- Grafana
- ZeroTier
- Telegram Bot
- WhatsApp Alerts
- Shell Script
- Backup
- Dashboards
- Alerts 24/7

## Architecture

- Monitored devices send metrics to the Zabbix Server via Agent or SNMP;

- Grafana is used for dashboard visualization;

- Critical alerts are sent to Telegram and/or WhatsApp;

- ZeroTier allows secure remote access to the lab.

## Roadmap

- [X] Install Linux Server;
- [ ] Install Zabbix Server;
- [ ] Add the first Linux host.;
- [ ] Configure SNMP;
- [ ] Creating dashboards in Grafana;
- [ ] Set up alerts on Telegram;
- [ ] Implement automated backup;
- [ ] Document complete architecture.

## Temas principais do repositório e o que o laboratório deve cobrir:

## Linux Server

Ubuntu Server ou Debian, SSH, usuários, firewall, serviços, logs, backup e hardening básico.

## Zabbix 7

Instalação, Zabbix Server, Zabbix Agent, templates, hosts, triggers, discovery, mapas e alertas.

## Grafana

Dashboards, visualização de métricas, integração com Zabbix ou Prometheus, painéis para servidores e rede.

## Redes e SNMP

Monitoramento de roteadores, switches, firewall, impressoras, nobreaks, OIDs, SNMP v2/v3 e descoberta automática.

## Alertas

Telegram Bot, WhatsApp via API ou gateway, notificações críticas, escalonamento e evidências.

## ZeroTier / VPN

Acesso remoto seguro a servidores e dispositivos atrás de CGNAT, filial remota ou laboratório doméstico.

## Hardware/Lab

Mini PC (hardware de baixo custo), roteador, switch, servidor Linux, dispositivos SNMP, notebook, VM local e ambiente de testes.

