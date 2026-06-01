# zabbix-linux-network-server-monitoring-lab

Laboratório prático de monitoramento de redes, servidores Linux, SNMP, Zabbix, Grafana, alertas e acesso remoto seguro.

# Network & Server Monitoring Lab

Laboratório prático para estudo e implementação de monitoramento profissional de redes, servidores Linux, dispositivos SNMP e alertas automatizados utilizando Zabbix, Grafana, Linux Server, SNMP, ZeroTier, Telegram e outras ferramentas.

## Objetivo

Este projeto tem como objetivo construir um ambiente de monitoramento semelhante ao utilizado em empresas, provedores, equipes de infraestrutura, NOC, SRE e Cloud Engineering.

## Tecnologias

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
- Alertas 24/7

## Arquitetura

Dispositivos monitorados enviam métricas para o Zabbix Server via Agent ou SNMP.  
O Grafana é utilizado para visualização dos dashboards.  
Alertas críticos são enviados para Telegram e/ou WhatsApp.  
O ZeroTier permite acesso remoto seguro ao laboratório.

## Roadmap

- [ ] Instalar servidor Linux
- [ ] Instalar Zabbix Server
- [ ] Adicionar primeiro host Linux
- [ ] Configurar SNMP
- [ ] Criar dashboards no Grafana
- [ ] Configurar alertas no Telegram
- [ ] Implementar backup automatizado
- [ ] Documentar arquitetura completa

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

