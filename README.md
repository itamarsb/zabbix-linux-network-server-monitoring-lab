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

## Main topics of the repository and what the lab should cover:

## Linux Server

Ubuntu Server or Debian, SSH, users, firewall, services, logs, backup, and basic hardening.

## Zabbix 7

Installation, Zabbix Server, Zabbix Agent, templates, hosts, triggers, discovery, maps, and alerts.

## Grafana

Dashboards, metrics visualization, integration with Zabbix or Prometheus, server and network panels.

## Networks and SNMP

Monitoring of routers, switches, firewalls, printers, UPS, OIDs, SNMP v2/v3, and automatic discovery.

## Alerts

Telegram Bot, WhatsApp via API or gateway, critical notifications, escalation, and evidence.

## ZeroTier / VPN

Secure remote access to servers and devices behind CGNAT, remote branch office, or home lab.

## Hardware/Lab

Mini PC (low-cost hardware), router, switch, Linux server, SNMP devices, notebook, local VM, and testing environment.

