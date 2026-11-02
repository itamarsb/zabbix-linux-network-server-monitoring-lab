# Zabbix NOC Operations Lab

[English](README.md) | **Português (Brasil)**

[![Zabbix](https://img.shields.io/badge/Zabbix-7.0%20LTS-D40000?logo=zabbix&logoColor=white)](https://www.zabbix.com/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Linux](https://img.shields.io/badge/Linux-Monitoring-FCC624?logo=linux&logoColor=black)](https://www.kernel.org/)
[![Windows](https://img.shields.io/badge/Windows-Monitoring-0078D4?logo=windows&logoColor=white)](https://www.microsoft.com/windows/)
[![Status](https://img.shields.io/badge/Status-Stage%2008%20Completed-brightgreen)](#roteiro-de-implementação)

Laboratório prático de Centro de Operações de Rede (NOC - *Network Operations Center*), voltado ao monitoramento de infraestrutura, à entrega de alertas, à triagem, ao diagnóstico e à resolução de problemas (*troubleshooting*), à resposta a incidentes, à recuperação de serviços, à coordenação de manutenções e à documentação operacional.

O Zabbix é a plataforma central de monitoramento. O projeto reproduz fluxos de trabalho comuns de um NOC envolvendo Linux, Windows, conectividade de rede, serviços HTTP, tratamento de incidentes, notificações aos operadores e manutenções planejadas.

## Objetivo do projeto

Este repositório demonstra um ciclo completo de monitoramento e tratamento de incidentes:

**Monitorar -> Detectar -> Notificar -> Validar -> Reconhecer -> Investigar -> Escalonar ou Restaurar -> Confirmar a recuperação -> Documentar**

O objetivo não se limita à instalação do Zabbix. Cada etapa contempla implementação, validação, simulação controlada de falhas, diagnóstico, recuperação e evidências técnicas selecionadas.

## Objetivos principais

- Implantar um ambiente reproduzível com Zabbix 7.0 LTS.
- Monitorar hosts Linux e Windows com Zabbix Agent 2.
- Monitorar disponibilidade de hosts, recursos de sistema, processos e serviços.
- Validar a disponibilidade por ICMP, DNS, portas TCP e HTTP.
- Configurar itens, *triggers*, eventos, problemas, severidades e ações.
- Enviar notificações automáticas de problemas e recuperação.
- Praticar reconhecimento, investigação, escalonamento e recuperação de incidentes.
- Simular incidentes de infraestrutura, rede e aplicações.
- Criar *runbooks* reutilizáveis de diagnóstico e resolução de problemas.
- Documentar incidentes, janelas de manutenção e atividades de turno.
- Introduzir o monitoramento SNMP em cenários orientados a redes.
- Adicionar o Grafana apenas como camada opcional de visualização, após a conclusão dos fluxos principais de trabalho no Zabbix.

## Visão geral da arquitetura

| Camada | Componente | Relação |
|:---:|:---:|:---:|
| Operações | Operador NOC | Utiliza a interface web do Zabbix e analisa as notificações capturadas |
| Apresentação | Zabbix Web | Disponibiliza as telas de configuração, monitoramento, incidentes e manutenção |
| Processamento | Zabbix Server | Coleta dados, avalia *triggers*, processa eventos e executa ações |
| Persistência | PostgreSQL | Armazena configurações, histórico, tendências e eventos do Zabbix |
| Alvos de monitoramento | Linux, Windows, serviços internos e um alvo SNMP controlado | Fornecem sinais de hosts, recursos, redes, TCP, DNS, HTTP, informações do sistema SNMP, interfaces e tráfego |
| Notificações | Mailpit | Captura localmente notificações SMTP de problemas e recuperação |

A plataforma é executada localmente com Docker Desktop e WSL 2.

O PostgreSQL permanece dentro da rede Docker. O Mailpit oferece captura SMTP isolada para validar notificações. Apenas as interfaces necessárias para administração, monitoramento e inspeção local de mensagens são expostas à estação de trabalho.

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

## Cenários de incidentes

O laboratório reproduz cenários comuns às equipes de NOC e infraestrutura:

- host monitorado indisponível;
- Zabbix Agent 2 indisponível;
- serviço HTTP interrompido;
- porta TCP inacessível;
- falha na resolução DNS;
- utilização elevada de CPU;
- pouco espaço disponível em disco;
- utilização anormal de memória;
- latência de rede ou perda de pacotes;
- serviço bloqueado por um firewall local;
- manutenção planejada gerando alertas desnecessários;
- *trigger* mal ajustada produzindo um falso positivo.

Cada cenário concluído deve conter evidências de detecção, etapas de diagnóstico, ação corretiva, validação da recuperação e registro operacional.

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

## Conteúdo atual do repositório

- [`labs/00-workstation-validation/`](labs/00-workstation-validation/README.pt-BR.md) - configuração inicial da estação de trabalho, critérios de aceitação, constatações e resultados;
- [`labs/01-zabbix-platform/`](labs/01-zabbix-platform/) - implantação reproduzível da plataforma Zabbix, validação, diagnóstico e evidências;
- [`labs/02-linux-host-monitoring/`](labs/02-linux-host-monitoring/) - monitoramento de host Linux com Zabbix Agent 2, validação controlada de recursos, testes do ciclo de vida e evidências;
- [`labs/03-windows-host-monitoring/`](labs/03-windows-host-monitoring/) - monitoramento de host Windows com Zabbix Agent 2, conectividade Docker baseada em DNS, descoberta de métricas, validação controlada de CPU e evidências;
- [`labs/04-network-service-monitoring/`](labs/04-network-service-monitoring/) - monitoramento de serviços ICMP, DNS, TCP e HTTP, falha controlada, validação da recuperação, diagnóstico e evidências;
- [`labs/05-triggers-alert-handling/`](labs/05-triggers-alert-handling/) - condições persistentes de *triggers*, classificação de severidade, incidentes HTTP e DNS, reconhecimento, recuperação, validação do histórico e evidências;
- [`labs/06-alert-delivery-notifications/`](labs/06-alert-delivery-notifications/) - captura SMTP com Mailpit, tipo de mídia do Zabbix, ação sensível à severidade, notificações de problema e recuperação, diagnóstico de falhas na entrega e evidências;
- [`labs/07-maintenance-operational-reporting/`](labs/07-maintenance-operational-reporting/) - manutenção planejada, coleta contínua de dados, supressão de problemas e notificações, recuperação controlada, encerramento da manutenção, relatórios operacionais e evidências;
- [`labs/08-snmp-grafana-integration/`](labs/08-snmp-grafana-integration/) - alvo SNMPv2c reproduzível, tratamento seguro da comunidade SNMP, descoberta de interfaces, monitoramento de tráfego, falha controlada de autenticação, recuperação, decisão sobre a visualização e evidências;
- [`snmp/`](snmp/) - configuração do alvo Net-SNMP controlado e script de inicialização do contêiner;
- [`scripts/powershell/validate-workstation.ps1`](scripts/powershell/validate-workstation.ps1) - validação reutilizável da estação de trabalho, somente leitura;
- [`compose.yaml`](compose.yaml) - PostgreSQL, Zabbix Server, Zabbix Web, alvos HTTP e SNMP dedicados, Mailpit, armazenamento persistente e redes isoladas;
- [`.env.example`](.env.example) - modelo versionado de variáveis de ambiente sem credenciais operacionais;
- [`docs/noc-alert-triage-checklist.md`](docs/noc-alert-triage-checklist.md) - guia rápido reutilizável para NOC, com validação de alertas, avaliação de severidade, diagnóstico, escalonamento, recuperação e passagem de turno;
- [`docs/screenshots/`](docs/screenshots/) - evidências técnicas selecionadas das etapas concluídas;
- [`.gitignore`](.gitignore) - proteção de segredos, dados de execução, logs, configurações locais e arquivos temporários.

Diretórios adicionais serão introduzidos apenas quando contiverem material implementado e validado.

## Roteiro de implementação

| Etapa | Escopo | Situação |
|:---:|---|:---:|
| 00 | Validação da estação de trabalho e configuração inicial do repositório | Concluída |
| 01 | Implantação da plataforma Zabbix e validação de integridade dos serviços | Concluída |
| 02 | Monitoramento de host Linux com Zabbix Agent 2 | Concluída |
| 03 | Monitoramento de host Windows com Zabbix Agent 2 | Concluída |
| 04 | Monitoramento de rede, DNS, TCP e serviços HTTP | Concluída |
| 05 | *Triggers*, severidades, eventos e tratamento de alertas | Concluída |
| 06 | Entrega de alertas, ações e notificações | Concluída |
| 07 | Janelas de manutenção e relatórios operacionais | Concluída |
| 08 | Monitoramento de rede via SNMP e decisão sobre o Grafana | Concluída |

Uma etapa somente é marcada como concluída após o registro no repositório de sua implementação, validação, observações de diagnóstico e evidências pertinentes.

## Etapas concluídas

### Etapa 00 - Validação da estação de trabalho

A etapa 00 estabeleceu e validou a configuração inicial da estação de trabalho local antes da implantação de qualquer serviço do Zabbix.

A validação abrangeu:

- Windows, PowerShell e arquitetura do sistema;
- processador, memória e capacidade disponível em disco;
- WSL 2 e seu kernel ativo;
- Docker Engine e Docker Compose;
- recursos disponíveis para o Docker;
- portas TCP necessárias;
- resolução DNS e conectividade HTTPS de saída;
- contêineres, redes e volumes existentes;
- estado do repositório Git.

Resultado da validação final:

| Resultado | Quantidade |
|:---:|:---:|
| Aprovados | `20` |
| Avisos | `0` |
| Falhas | `0` |
| Decisão final | Estação de trabalho aprovada |

Consulte a documentação completa em [`labs/00-workstation-validation/README.md`](labs/00-workstation-validation/README.pt-BR.md).

### Etapa 01 - Implantação da plataforma Zabbix

A etapa 01 disponibilizou uma plataforma reproduzível com Zabbix 7.0 LTS, composta por PostgreSQL, Zabbix Server e Zabbix Web.

A implementação incluiu:

- versões fixadas das imagens dos contêineres;
- rede interna para o banco de dados;
- armazenamento persistente do PostgreSQL;
- publicação de portas restrita à interface de loopback;
- validação de integridade do banco de dados;
- variáveis de ambiente controladas;
- validação de disponibilidade HTTP local;
- substituição das credenciais administrativas padrão;
- investigação e correção de uma associação inadequada de template;
- confirmação da recuperação da plataforma, sem problemas ativos naquele momento.

Consulte a documentação completa em [`labs/01-zabbix-platform/README.md`](labs/01-zabbix-platform/README.md).

### Etapa 02 - Monitoramento de host Linux

A etapa 02 introduziu o primeiro host Linux monitorado: Ubuntu 24.04 LTS executado no WSL 2 com Zabbix Agent 2.

A implementação incluiu:

- instalação a partir do repositório oficial do Zabbix 7.0;
- verificações passivas pelo Agent 2 na porta TCP `10050`;
- validação de conectividade e autorização entre Docker e WSL;
- verificações diretas com `zabbix_get` para disponibilidade, identidade do host e versão do agente;
- cadastro do host com o template `Linux by Zabbix agent`;
- coleta de dados de CPU, memória, swap, sistemas de arquivos, armazenamento, processos, sistema operacional e rede;
- investigação de itens temporariamente sem suporte durante a inicialização do template;
- atividades controladas de CPU, memória, sistemas de arquivos e rede;
- encerramento do WSL e validação da recuperação automática do Agent 2;
- evidências selecionadas do estado inicial, estado final, dashboard e teste de memória.

Todos os critérios de aceitação foram atendidos, e o host Linux monitorado permaneceu operacional após os testes de ciclo de vida e de recursos.

Consulte a documentação completa em [`labs/02-linux-host-monitoring/README.md`](labs/02-linux-host-monitoring/README.md).

### Etapa 03 - Monitoramento de host Windows

A etapa 03 introduziu o primeiro host Windows monitorado: uma estação de trabalho nativa com Windows 11 Pro e Zabbix Agent 2 executado como serviço do Windows.

A implementação incluiu:

- validação inicial do host Windows, interfaces de rede, serviços, firewall e portas TCP;
- conectividade Docker-Windows por meio de `host.docker.internal`;
- identificação e restrição do escopo de autorização necessário para a rede Docker;
- download e verificação do instalador MSI oficial do Zabbix Agent 2 `7.0.30`;
- validação SHA-256 e Authenticode antes da instalação;
- preservação da configuração original do Agent;
- verificações passivas do Agent pela porta TCP `10050`;
- regra de entrada restrita no Firewall do Windows;
- validação direta com `zabbix_get` a partir do contêiner Zabbix Server;
- criação do grupo de hosts `Windows servers`;
- cadastro do host com interface do Agent baseada em DNS;
- associação do template `Windows by Zabbix agent`;
- validação da disponibilidade do Agent e de `146` valores monitorados após a descoberta inicial;
- coleta de dados de CPU, memória, swap, tempo de atividade, processos, threads, discos, sistemas de arquivos, interfaces de rede e serviços;
- carga controlada de CPU durante dois minutos, utilizando seis dos oito processadores lógicos;
- observação do aumento da utilização de CPU para `89.5912%` e de sua recuperação para `36.6596%`;
- evidências selecionadas de disponibilidade do host, dados recentes, carga de trabalho e recuperação.

Todos os critérios de aceitação foram atendidos, e o caminho de monitoramento do Windows permaneceu disponível durante toda a atividade controlada e a validação da recuperação.

Consulte a documentação completa em [`labs/03-windows-host-monitoring/README.md`](labs/03-windows-host-monitoring/README.md).

### Etapa 04 - Monitoramento de rede, DNS, TCP e serviços HTTP

A etapa 04 ampliou o monitoramento de hosts com verificações nativas de disponibilidade da rede e de serviços.

A implementação incluiu:

- monitoramento de disponibilidade, perda de pacotes e tempo de resposta por ICMP para `1.1.1.1`;
- monitoramento de resolução DNS externa por meio do Zabbix Agent 2 e do DNS da Cloudflare;
- verificações de disponibilidade TCP interna para PostgreSQL e um alvo HTTP dedicado;
- serviço Nginx dedicado, isolado da plataforma Zabbix e do banco de dados;
- cenário web HTTP para validar conteúdo, código de resposta, tempo de resposta e velocidade de download;
- validação de DNS do Docker e conectividade entre redes;
- interrupção controlada apenas do serviço HTTP monitorado;
- observação da disponibilidade TCP mudando de `1` para `0` e retornando a `1`;
- observação da etapa com falha no cenário web mudando de `0` para `1` e retornando a `0`;
- preservação do PostgreSQL e da plataforma Zabbix durante toda a falha;
- revisão do histórico de erros e validação completa da recuperação do serviço;
- evidências selecionadas do estado normal, falha, erros e recuperação.

Todos os critérios de aceitação foram atendidos. A etapa confirmou que a plataforma de monitoramento poderia detectar a interrupção de um serviço isolado, preservar informações de diagnóstico e verificar a recuperação sem afetar os serviços essenciais do laboratório.

Consulte a documentação completa em [`labs/04-network-service-monitoring/README.md`](labs/04-network-service-monitoring/README.md).

### Etapa 05 - Triggers, severidades, eventos e tratamento de alertas

A etapa 05 transformou os sinais de monitoramento estabelecidos nas etapas anteriores em incidentes que exigem ação e ciclos operacionais completos.

A implementação incluiu:

- *trigger* de disponibilidade HTTP com condição persistente e severidade High;
- interrupção e restauração controladas do serviço dedicado `monitored-web`;
- geração do problema HTTP, reconhecimento, anotações da investigação e decisões de escalonamento;
- resolução automática do evento HTTP e preservação de todo o histórico do evento;
- *trigger* adicional de resolução DNS externa com severidade Average;
- validação e rejeição de uma tentativa inicial ineficaz de injeção de falha;
- falha DNS determinística por meio de uma alteração temporária e controlada do alvo;
- observação do valor DNS monitorado mudando de `1` para `0` e retornando a `1`;
- recuperação automática do incidente DNS e validação histórica;
- remoção de regras temporárias do Firewall do Windows utilizadas durante o diagnóstico;
- evidências selecionadas da detecção, reconhecimento, falha, recuperação e histórico de HTTP e DNS.

Todos os critérios de aceitação foram atendidos. A etapa demonstrou classificação de incidentes por severidade, responsabilização operacional do operador, diagnóstico controlado, recuperação automática e preservação completa do histórico de dois sinais distintos de monitoramento.

Consulte a documentação completa em [`labs/05-triggers-alert-handling/README.md`](labs/05-triggers-alert-handling/README.md).

### Etapa 06 - Entrega de alertas, ações e notificações

A etapa 06 transformou os eventos monitorados na etapa 05 em fluxos completos de notificação aos operadores.

A implementação incluiu:

- implantação do Mailpit como serviço local de captura SMTP;
- interface web do Mailpit acessível somente por loopback;
- criação do tipo de mídia `Mailpit Local SMTP` no Zabbix;
- atribuição do destinatário de laboratório `noc-operator@zabbix-lab.local`;
- ativação da entrega de notificações para as severidades Average, High e Disaster;
- criação da ação de *trigger* `NOC Lab - Mailpit problem notifications`;
- condições da ação restritas às *triggers* HTTP e DNS selecionadas;
- severidade mínima Average para a ação;
- modelos personalizados de mensagens de problema e recuperação;
- validação direta da entrega pelo tipo de mídia;
- ciclo controlado de falha e recuperação HTTP com severidade High;
- entrega bem-sucedida de e-mails de problema e recuperação HTTP;
- falha DNS de severidade Average gerada por alteração temporária e determinística do alvo;
- entrega bem-sucedida de e-mails de problema e recuperação DNS;
- validação da execução da ação e do status de entrega pelo log de ações do Zabbix;
- diagnóstico e correção de modelos de mensagem ausentes no tipo de mídia;
- restauração do serviço HTTP e da chave original do item DNS;
- evidências selecionadas da plataforma, mensagens, ações, problemas e recuperações.

Todos os critérios de aceitação foram atendidos. A etapa demonstrou o processamento de notificações conforme a severidade, o envio automático de avisos de problema e recuperação, a validação SMTP local, a análise do histórico de entrega e o diagnóstico sistemático de uma falha no caminho de notificação.

Consulte a documentação completa em [`labs/06-alert-delivery-notifications/README.md`](labs/06-alert-delivery-notifications/README.md).

### Etapa 07 - Janelas de manutenção e relatórios operacionais

A etapa 07 ampliou o fluxo de entrega de alertas com a coordenação de manutenções planejadas e a elaboração formal de relatórios operacionais.

A implementação incluiu:

- criação do período de manutenção `NOC Lab - Monitored Web Planned Maintenance`;
- associação de `Zabbix Lab Internal Services` à manutenção ativa;
- configuração da manutenção com coleta contínua de dados;
- validação da opção da ação de *trigger* para pausar operações em incidentes suprimidos;
- registro da contagem inicial de mensagens no Mailpit;
- interrupção controlada apenas do serviço `monitored-web`;
- observação da disponibilidade TCP mudando de `1` para `0`;
- observação da etapa com falha no cenário web HTTP mudando de `0` para `1`;
- geração do incidente `HTTP service unavailable on monitored-web` com severidade High;
- confirmação da supressão do incidente relacionado à manutenção;
- confirmação de que o Mailpit recebeu zero novas mensagens durante a falha;
- restauração do contêiner `monitored-web`;
- observação da disponibilidade TCP retornando a `1`;
- observação do código de resposta HTTP retornando a `200`;
- recuperação automática do incidente após `5m 56s`;
- encerramento formal da manutenção e confirmação do status `Expired`;
- remoção do indicador de manutenção do host;
- validação bem-sucedida de todos os serviços Docker após a manutenção;
- criação de um registro de manutenção planejada;
- criação de um relatório de passagem de turno;
- evidências selecionadas de manutenção, supressão, falha, recuperação e estado final.

Todos os critérios de aceitação foram atendidos. A etapa demonstrou que o Zabbix pode continuar coletando dados durante trabalhos planejados, preservar eventos de problema suprimidos para fins de auditoria, impedir operações de notificação desnecessárias, confirmar a recuperação do serviço e apoiar a documentação de mudanças e passagens de turno em NOC.

Documentação da etapa 07:

- [Visão geral da etapa 07](labs/07-maintenance-operational-reporting/README.md)
- [Registro de manutenção planejada](labs/07-maintenance-operational-reporting/maintenance-record.md)
- [Relatório de passagem de turno](labs/07-maintenance-operational-reporting/shift-handover-report.md)

### Etapa 08 - Monitoramento SNMP de rede e decisão sobre o Grafana

A etapa 08 ampliou o laboratório com um alvo de monitoramento orientado a redes e reproduzível, utilizando SNMPv2c.

A implementação incluiu:

- contêiner Alpine Linux dedicado à execução do Net-SNMP;
- injeção da comunidade SNMP por variáveis de ambiente, sem versionar o segredo operacional;
- validação da integridade do contêiner e integração com a rede Docker;
- diagnóstico e correção de finais de linha Windows CRLF no script de entrada do Linux;
- consultas SNMP diretas antes do cadastro do host no Zabbix;
- criação do host `SNMP Lab Target - Docker` com interface SNMP na porta UDP `161`;
- armazenamento da comunidade operacional em uma macro de host secreta no Zabbix;
- avaliação e substituição do template genérico inicial por `Linux by SNMP`;
- coleta por meio de `53` itens, `15` *triggers*, `8` gráficos e `5` regras de descoberta de baixo nível;
- descoberta da interface `eth0` e validação dos dados de tráfego de entrada e saída;
- gráficos nativos do Zabbix para monitoramento do sistema e da interface;
- falha controlada de autenticação SNMP por meio de uma comunidade temporariamente inválida;
- geração do problema `Linux: No SNMP data collection`;
- restauração da comunidade correta e recuperação automática do problema;
- rotação da comunidade SNMP operacional após a revisão das evidências;
- investigação de uma ação dedicada de notificação pelo Mailpit que não foi executada para o evento SNMP;
- desativação da ação SNMP não validada, preservando o fluxo Mailpit comprovado na etapa 06;
- avaliação e adiamento intencional do Grafana, pois a visualização nativa do Zabbix atendeu aos objetivos da etapa sem duplicar o escopo de observabilidade do portfólio;
- evidências selecionadas de disponibilidade, coleta, tráfego, problema e recuperação.

Todos os critérios principais de aceitação do SNMP foram atendidos. O alvo final está saudável, a comunidade rotacionada foi sincronizada com segurança e a ação de notificação não validada da etapa 08 permanece desativada.

Consulte a documentação completa em [`labs/08-snmp-grafana-integration/README.md`](labs/08-snmp-grafana-integration/README.md).

## Política de evidências

As evidências são selecionadas para demonstrar resultados técnicos significativos, em vez de registrar cada clique do mouse.

As evidências pertinentes podem incluir:

- disponibilidade da plataforma e dos hosts;
- telas reconhecíveis de hosts, estados e monitoramento no Zabbix;
- coleta de dados dos itens;
- gráficos de métricas demonstrando mudança controlada e recuperação;
- transição de *trigger* de `OK` para `PROBLEM`;
- incidente reconhecido, acompanhado de uma anotação operacional;
- notificação recebida pelo operador configurado;
- histórico bem-sucedido de ações de problema e recuperação;
- saída de comandos de diagnóstico;
- recuperação do serviço confirmada;
- transição da *trigger* de volta para `OK`;
- configuração do período de manutenção;
- registro de manutenção ou relatório de turno concluído;
- coleta de itens SNMP;
- visualização do tráfego de interfaces;
- falha controlada de autenticação SNMP e recuperação;

Capturas de tela contendo credenciais, tokens, informações pessoais ou conteúdo não relacionado da área de trabalho não devem ser incluídas nos commits.

## Práticas de segurança

- Segredos e credenciais são excluídos do controle de versão.
- O PostgreSQL não é exposto diretamente ao host Windows.
- O Mailpit é usado apenas como serviço controlado de captura SMTP local.
- As interfaces administrativas e de notificação são vinculadas ao loopback quando aplicável.
- Valores específicos do ambiente permanecem fora da configuração versionada.
- Arquivos de exemplo utilizam marcadores substitutos no lugar de senhas reais.
- Chaves privadas e certificados são ignorados pelo Git.
- As evidências de diagnóstico são revisadas antes da publicação.
- Recursos existentes de projetos não relacionados são preservados.
- Alterações temporárias de teste são removidas após a validação.
- Os períodos de manutenção são encerrados após as atividades operacionais controladas.
- As comunidades SNMP operacionais permanecem fora do controle de versão.
- As macros sensíveis do Zabbix são configuradas como texto secreto.
- Segredos do laboratório que tenham sido expostos são rotacionados e sincronizados antes do encerramento.

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
- Grafana avaliado e adiado

## Competências demonstradas

- monitoramento de infraestrutura e serviços;
- triagem de alertas em NOC;
- administração de Linux e Windows;
- validação de conectividade de rede;
- configuração de tipos de mídia e ações no Zabbix;
- entrega de alertas conforme a severidade;
- validação de notificações SMTP;
- elaboração de mensagens de problema e recuperação;
- diagnóstico de falhas em notificações;
- resposta a incidentes;
- metodologia de diagnóstico e resolução de problemas;
- restauração de serviços;
- escalonamento operacional;
- coordenação de manutenções planejadas;
- supressão de eventos e notificações;
- validação e encerramento de mudanças;
- preparação de relatórios de passagem de turno;
- documentação técnica;
- fundamentos de monitoramento como código (*monitoring as code*);
- gerenciamento de ambientes baseados em Docker;
- consultas SNMPv2c e validação de OIDs;
- descoberta de interfaces de baixo nível;
- monitoramento de tráfego de rede;
- rotação de segredos e sincronização de configurações;
- diagnóstico de diferenças entre finais de linha do Windows e do Linux;
- revisão de evidências e práticas de segurança.

## Estado do projeto

As etapas 00 a 08 estão concluídas, validadas e documentadas.

O repositório agora contempla fluxos de monitoramento de hosts, serviços, redes, incidentes, notificações, manutenção, relatórios e SNMP. O Grafana foi avaliado na etapa 08 e intencionalmente adiado porque a visualização nativa do Zabbix atendeu aos requisitos validados sem acrescentar escopo redundante ao portfólio.

---

Este repositório é um ambiente de laboratório controlado, destinado à prática técnica e à demonstração de competências em portfólio. Não se trata de um guia de implantação em produção.

---

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
