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
