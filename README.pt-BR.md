# Zabbix NOC Operations Lab

[English](README.md) | **Português (Brasil)**

[![Zabbix](https://img.shields.io/badge/Zabbix-7.0%20LTS-D40000?logo=zabbix&logoColor=white)](https://www.zabbix.com/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Linux](https://img.shields.io/badge/Linux-Monitoring-FCC624?logo=linux&logoColor=black)](https://www.kernel.org/)
[![Windows](https://img.shields.io/badge/Windows-Monitoring-0078D4?logo=windows&logoColor=white)](https://www.microsoft.com/windows/)
[![Status](https://img.shields.io/badge/Status-Stage%2008%20Completed-brightgreen)](#roteiro-de-implementação)

Este repositório reúne uma série de laboratórios práticos de monitoramento com Zabbix 7.0 LTS, Docker, Linux e Windows.

O projeto acompanha a evolução de um ambiente de monitoramento, desde a implantação da plataforma até o acompanhamento de hosts e redes, a detecção de incidentes, o envio de notificações, a recuperação de serviços, as manutenções planejadas e o monitoramento SNMP.

Cada laboratório apresenta a configuração utilizada, os testes realizados, os resultados observados e as principais constatações operacionais. Capturas de tela e saídas de comandos complementam os procedimentos quando ajudam a compreender os resultados.

O ambiente destina-se ao aprendizado e à experimentação, não à implantação direta em produção.

## Como utilizar este repositório

Comece pela [Etapa 00](labs/00-workstation-validation/README.pt-BR.md) para conhecer os pré-requisitos da estação de trabalho e pela [Etapa 01](labs/01-zabbix-platform/README.pt-BR.md) para entender a plataforma Zabbix. As etapas 02–04 tratam do monitoramento de hosts Linux e Windows, da conectividade e dos serviços; as etapas 05–08 avançam para incidentes, notificações, manutenção e SNMP.

O [Roteiro de implementação](#roteiro-de-implementação) contém os links para cada etapa. Como referência para a rotina de atendimento, consulte o [checklist de triagem de alertas NOC](docs/noc-alert-triage-checklist.pt-BR.md).

A documentação distingue os resultados observados durante os experimentos originais dos comandos de referência para novas execuções. Eventuais limitações ou validações incompletas são descritas junto aos respectivos resultados.

## Visão geral da arquitetura

| Camada | Componente | Relação |
|:---:|:---:|:---:|
| Operações | Operador NOC | Utiliza a interface web do Zabbix e analisa as notificações capturadas |
| Apresentação | Zabbix Web | Disponibiliza as telas de configuração, monitoramento, incidentes e manutenção |
| Processamento | Zabbix Server | Coleta dados, avalia *triggers*, processa eventos e executa ações |
| Persistência | PostgreSQL | Armazena configurações, histórico, tendências e eventos do Zabbix |
| Alvos de monitoramento | Linux, Windows, serviços internos e um alvo SNMP controlado | Fornecem sinais de hosts, recursos, redes, TCP, DNS, HTTP, informações do sistema SNMP, interfaces e tráfego |
| Notificações | Mailpit | Captura localmente notificações SMTP de problemas e recuperação |

O laboratório é executado localmente com Docker Desktop e WSL 2. O Docker Compose separa o tráfego de backend e de monitoramento: a rede `backend` utiliza `internal: true`, enquanto `monitoring` é uma rede bridge comum do Docker. As portas publicadas para a estação de trabalho ficam vinculadas ao loopback quando assim definidas na configuração; isso, isoladamente, não restringe o tráfego entre contêineres na mesma rede. O PostgreSQL não possui porta publicada no host, e o Mailpit captura localmente as mensagens SMTP de teste.

## Escopo do monitoramento

| Área | Cobertura |
|:---:|:---:|
| Disponibilidade de hosts | Disponibilidade do agente, acessibilidade por ICMP e tempo de resposta |
| Linux | CPU, memória, disco, processos, serviços, logs e interfaces de rede |
| Windows | CPU, memória, disco, serviços, informações de eventos e Agent 2 |
| Rede | ICMP, perda de pacotes, latência, resolução DNS e conectividade TCP |
| Serviços HTTP | Disponibilidade, código de status, tempo de resposta e falha controlada do serviço |
| Operações no Zabbix | Hosts, templates, itens, *triggers*, eventos, problemas, ações e tipos de mídia |
| Entrega de alertas | Captura SMTP, notificações de problemas, notificações de recuperação e histórico de entrega |
| Tratamento de incidentes | Triagem, reconhecimento, anotações, severidade, escalonamento e recuperação |
| Manutenção | Indisponibilidade planejada, supressão de eventos, supressão de notificações e validação da recuperação |
| Relatórios | Registros de manutenção, checklists operacionais e relatórios de passagem de turno |
| Dispositivos de rede | Consultas SNMPv2c ao sistema, descoberta de interfaces, estado operacional e monitoramento de tráfego |
| Visualização | Painéis e gráficos nativos do Zabbix; Grafana avaliado e intencionalmente adiado |

## Roteiro de implementação

As etapas 00–08 estão documentadas como marcos concluídos do laboratório. A tabela destaca resultados representativos; os documentos de cada etapa apresentam detalhes de implementação, comandos, medições originais e evidências correspondentes.

| Etapa | Conteúdo | Resultado documentado |
|:---:|---|---|
| [00 — Ambiente](labs/00-workstation-validation/README.pt-BR.md) | Windows, WSL 2, Docker, portas e pré-requisitos | 20 verificações aprovadas, sem avisos ou falhas |
| [01 — Plataforma Zabbix](labs/01-zabbix-platform/README.pt-BR.md) | PostgreSQL, Zabbix Server e Zabbix Web | Plataforma local implantada e validada |
| [02 — Linux](labs/02-linux-host-monitoring/README.pt-BR.md) | Zabbix Agent 2, métricas e ciclo de vida do WSL | Coleta do agente, testes controlados de recursos e recuperação verificados |
| [03 — Windows](labs/03-windows-host-monitoring/README.pt-BR.md) | Agent 2, permissões de rede, serviços e CPU | 146 valores monitorados na descoberta inicial e resposta à carga de CPU observada |
| [04 — Redes e serviços](labs/04-network-service-monitoring/README.pt-BR.md) | Verificações ICMP, DNS, TCP e HTTP | Interrupção isolada do serviço HTTP e recuperação observadas |
| [05 — Incidentes](labs/05-triggers-alert-handling/README.pt-BR.md) | Triggers, severidade, reconhecimento e investigação | Eventos de problema e recuperação HTTP e DNS registrados |
| [06 — Notificações](labs/06-alert-delivery-notifications/README.pt-BR.md) | Ações do Zabbix, SMTP e Mailpit | Notificações de problema e recuperação HTTP e DNS entregues no laboratório |
| [07 — Manutenção](labs/07-maintenance-operational-reporting/README.pt-BR.md) | Manutenção planejada, supressão e passagem de turno | Incidente sob manutenção suprimido e serviço recuperado |
| [08 — SNMP](labs/08-snmp-grafana-integration/README.pt-BR.md) | Net-SNMP, OIDs, tráfego de interfaces e autenticação | Coleta SNMP e recuperação da autenticação verificadas; notificações opcionais não validadas |

**Limitações relevantes:** Na etapa 05, a tentativa inicial de bloqueio de DNS pelo firewall não produziu a falha esperada no monitoramento, e a remoção da primeira regra de teste específica para UDP não foi comprovada pelos registros preservados. Na etapa 08, nenhuma entrega de notificação SNMP foi observada no Mailpit, e a ação dedicada permaneceu desabilitada. Esses resultados estão descritos nas etapas correspondentes e não são apresentados como experimentos bem-sucedidos.

O Grafana foi avaliado na etapa 08, mas não foi acrescentado: os painéis e gráficos do Zabbix atenderam às necessidades de visualização daquele laboratório.

## Cenários de incidentes

O laboratório distingue experimentos de falhas controladas validados, variações monitoradas de recursos e cenários propostos para validação futura.

### Cenários controlados validados

- Interrupção do serviço HTTP, indisponibilidade TCP/HTTP, detecção do problema e recuperação (Stages 04–07).
- Falha controlada de resolução DNS, detecção do problema e recuperação (Stages 05–06).
- Manutenção planejada com continuidade da coleta de dados e supressão de notificações de incidentes (Stage 07).
- Falha controlada de autenticação SNMP, detecção do problema e recuperação (Stage 08).

### Monitoramento de recursos e rede validado

- Carga controlada de CPU e resposta do monitoramento (Stages 02–03).
- Alocação de memória, uso temporário do sistema de arquivos e variações de tráfego de rede (Stage 02).
- Monitoramento de disponibilidade ICMP, tempo de resposta e perda de pacotes nas condições observadas (Stage 04).

Essas atividades validam o comportamento do monitoramento, mas não demonstram necessariamente a geração de incidentes.

### Cenários candidatos à validação futura

- Indisponibilidade de host monitorado ou Zabbix Agent 2.
- Espaço disponível em disco criticamente baixo ou violações de limites de utilização de memória.
- Indução de latência de rede ou perda de pacotes.
- Bloqueio efetivo de serviço por firewall local.
- Incidente falso positivo causado por uma trigger configurada incorretamente.

Esses cenários não devem ser apresentados como experimentalmente validados até que os testes e suas evidências sejam documentados.

Cada cenário de incidente concluído deve incluir evidências de detecção, etapas de diagnóstico, ações corretivas quando aplicáveis, validação da recuperação e registro operacional.

## Método de diagnóstico e resolução de problemas

1. Identificar a origem do alerta e o recurso afetado.
2. Validar se o problema ainda está presente e pode ser reproduzido.
3. Determinar impacto, abrangência e severidade.
4. Verificar conectividade, recursos, serviços, portas e logs.
5. Comparar alterações recentes e eventos relacionados.
6. Verificar a execução de ações e a entrega de notificações, quando aplicável.
7. Aplicar o procedimento de recuperação documentado, quando autorizado.
8. Escalonar o problema quando ele exceder o acesso ou a responsabilidade do operador.
9. Confirmar a recuperação tanto pela perspectiva do sistema quanto pela do monitoramento.
10. Registrar ações, horários, constatações e recomendações de acompanhamento.

## Arquivos de apoio do repositório

Os READMEs das etapas apresentam os procedimentos completos. Os arquivos a seguir complementam a configuração, a operação e o registro dos experimentos:

- [`compose.yaml`](compose.yaml) — definições dos serviços, armazenamento, portas publicadas e redes Docker
- [`.env.example`](.env.example) — modelo de variáveis de ambiente sem segredos operacionais
- [`scripts/powershell/validate-workstation.ps1`](scripts/powershell/validate-workstation.ps1) — script de validação da estação de trabalho, somente de leitura
- [`snmp/`](snmp/) — imagem do alvo Net-SNMP, inicialização e configuração do agente
- [Checklist de triagem de alertas NOC](docs/noc-alert-triage-checklist.pt-BR.md) — referência reutilizável para diagnóstico e passagem de turno
- [Registro de manutenção planejada](labs/07-maintenance-operational-reporting/maintenance-record.pt-BR.md) e [relatório de passagem de turno](labs/07-maintenance-operational-reporting/shift-handover-report.pt-BR.md) — registros operacionais da etapa 07
- [`docs/screenshots/`](docs/screenshots/) — capturas selecionadas dos experimentos
- [`.gitignore`](.gitignore) — exclusões de segredos locais, dados de execução, logs e arquivos temporários

## Evidências e reprodução dos experimentos

Os documentos das etapas preservam as medições, os comandos, as linhas do tempo dos incidentes e as capturas selecionadas que ajudam a compreender cada teste. Entre os exemplos estão valores de itens e gráficos do Zabbix, transições `OK`/`PROBLEM`, histórico de ações, mensagens no Mailpit, recuperação dos serviços, registros de manutenção e tráfego de interfaces SNMP.

Os comandos de referência acrescentados para reproduções futuras são identificados separadamente das evidências de execução original. Os resultados históricos não descrevem, necessariamente, o estado de uma nova implantação. Capturas e logs devem excluir credenciais, segredos, dados pessoais e conteúdo da estação de trabalho sem relação com o projeto.

## Práticas de segurança

- Credenciais operacionais, comunidades SNMP, tokens, chaves privadas e valores específicos do ambiente ficam fora do controle de versão. Os arquivos de exemplo utilizam marcadores substitutos.
- O PostgreSQL não possui porta publicada no host. As interfaces de administração e dos serviços de teste são vinculadas ao loopback quando previsto no Compose; isso não equivale a isolar o tráfego entre contêineres Docker.
- O Mailpit é utilizado apenas em testes SMTP locais, não como servidor de e-mail de produção. As comunidades SNMPv2c não são criptografadas durante a transmissão.
- As macros sensíveis do Zabbix utilizam texto secreto, e uma comunidade de laboratório exposta foi rotacionada durante a etapa 08.
- Alterações temporárias de testes exigem limpeza e verificação. Quando os registros não confirmam o estado final, a respectiva etapa informa essa limitação.
- Os recursos de outros projetos não são modificados intencionalmente, e as evidências são verificadas para evitar a publicação de informações sensíveis.

## Tecnologias utilizadas

- Zabbix 7.0 LTS
- Zabbix Agent 2
- PostgreSQL
- Docker Desktop
- Docker Compose
- WSL 2
- Linux
- Windows PowerShell
- Nginx
- Mailpit
- SMTP
- SNMPv2c
- Net-SNMP
- Alpine Linux

## Assuntos abordados

Os laboratórios abrangem administração de Linux e Windows, operações com contêineres, conectividade de agentes e redes, itens e triggers do Zabbix, triagem de incidentes NOC, classificação de severidade, entrega de notificações, diagnóstico, recuperação de serviços, manutenção planejada, passagem de turno, consultas SNMP, descoberta de interfaces e documentação técnica.

A proposta é compreender os sinais monitorados, selecionar verificações adequadas e interpretar o que cada teste efetivamente demonstra.

## Estado do projeto

As etapas 00–08 foram implementadas e documentadas, com resultados e limitações apresentados nos respectivos READMEs. Isso não significa que todos os cenários opcionais ou procedimentos de referência tenham sido executados.

A ação de notificações SNMP da etapa 08 permanece sem validação e desabilitada; os fluxos de notificação HTTP e DNS foram validados separadamente na etapa 06. O Grafana foi adiado porque a visualização nativa do Zabbix atendeu às necessidades dos testes da etapa 08.

Este é um laboratório educacional, não uma instalação de produção nem uma garantia de que o ambiente registrado historicamente continue em execução no mesmo estado.

## Métricas do repositório

<p align="center">
  <a href="https://info.flagcounter.com/iBrN">
    <img
      src="https://s01.flagcounter.com/count/iBrN/bg_FFFFFF/txt_000000/border_CCCCCC/columns_8/maxflags_100/viewers_0/labels_1/pageviews_1/flags_0/percent_0/"
      alt="Flag Counter"
      width="900"
    />
  </a>
</p>
