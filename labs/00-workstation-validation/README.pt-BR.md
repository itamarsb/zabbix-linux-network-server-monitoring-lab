# Lab 00 - Validação da estação de trabalho

[English](README.md) | **Português (Brasil)**

[Voltar ao README principal](../../README.pt-BR.md)

## Objetivo

Validar a estação de trabalho local antes da implantação da plataforma Zabbix.

Esta etapa estabelece uma referência técnica inicial (*baseline*) para Windows, PowerShell, WSL, Docker, rede, armazenamento e estado do repositório. A validação reduz falhas de implantação e evita conflitos com ambientes de laboratório não relacionados.

## Contexto operacional

Antes de implantar uma plataforma de monitoramento, o profissional de operações deve verificar se o ambiente de destino atende aos requisitos de implementação.

Ignorar essa validação inicial pode resultar em:

- capacidade insuficiente de CPU, memória ou disco;
- portas TCP indisponíveis;
- serviços Docker inativos;
- configuração incompatível do WSL;
- falhas de DNS ou de conectividade com a internet;
- conflitos com contêineres e redes existentes;
- alteração acidental de dados de laboratórios não relacionados;
- falhas de implantação atribuídas incorretamente ao Zabbix.

> Valide o ambiente antes de implantar o serviço.

## Escopo

A validação da estação de trabalho abrange:

- versão e arquitetura do Windows;
- processador e memória física;
- espaço disponível em disco;
- versão do PowerShell;
- WSL 2 e seu kernel ativo;
- cliente e servidor Docker;
- Docker Compose;
- recursos disponíveis para o Docker;
- contêineres, redes e volumes existentes;
- portas TCP necessárias;
- resolução DNS;
- conectividade HTTPS de saída;
- instalação do Git e estado do repositório.

## Configuração inicial do ambiente

| Componente | Configuração detectada |
|:---:|:---:|
| Sistema operacional da estação | Windows 11 Pro, 64 bits |
| Build do Windows | 26200.9168 |
| Processador | AMD Ryzen 5 3500U |
| Capacidade da CPU | 4 núcleos físicos, 8 processadores lógicos |
| Memória física | 29.94 GB |
| Espaço livre em disco durante a validação | 233.88 GB |
| PowerShell | Windows PowerShell 5.1.26100.9168 |
| WSL | 2.7.11 |
| Kernel do WSL | 6.18.33.2-microsoft-standard-WSL2 |
| Distribuição padrão do WSL | Ubuntu 24.04 |
| Geração do WSL | WSL 2 |
| Docker Desktop | 4.85.0 |
| Docker Engine | 29.6.2 |
| Docker Compose | 5.3.1 |
| Capacidade de CPU do Docker | 8 processadores lógicos |
| Capacidade de memória do Docker | 14.60 GB |
| Git | 2.55.0.windows.3 |

A configuração inicial foi registrada em 26 de agosto de 2026. O espaço disponível em disco e as versões dos softwares podem mudar em execuções posteriores.

## Alocação planejada para a plataforma

| Componente | Abordagem inicial |
|:---:|:---:|
| PostgreSQL | Serviço Docker interno com armazenamento persistente |
| Zabbix Server | Carga de trabalho local com utilização conservadora de recursos |
| Zabbix Web | Uma instância de interface web (*frontend*) |
| Host Linux monitorado | Contêiner leve |
| Serviço Nginx de teste | Contêiner leve |
| Memória total esperada | Aproximadamente 3–4 GB |
| Rede Docker | Rede bridge específica do projeto |
| Exposição do banco de dados | Somente na rede interna do Docker |

A estação de trabalho possui capacidade suficiente para executar a plataforma planejada, preservando recursos para o Windows, o Docker Desktop e as atividades normais da estação.

**Evolução da arquitetura:** Esta tabela registra a alocação inicial da plataforma planejada durante o Stage 00. Durante o Stage 02, o alvo de monitoramento Linux foi implementado utilizando Ubuntu 24.04 LTS no WSL 2, em vez do contêiner Docker leve originalmente previsto. O Zabbix Agent 2 é executado no host WSL 2 e se comunica com o Zabbix Server em contêiner por meio da rede privada Docker/WSL. A implementação e sua validação estão documentadas no [Stage 02](../02-linux-host-monitoring/README.pt-BR.md).

## Portas necessárias

| Porta | Protocolo | Finalidade planejada | Resultado da validação inicial |
|:---:|:---:|:---:|:---:|
| 8080 | TCP | Interface web do Zabbix | Disponível |
| 8443 | TCP | Interface HTTPS opcional | Disponível |
| 10050 | TCP | Zabbix Agent 2 | Disponível |
| 10051 | TCP | Zabbix Server | Disponível |
| 5432 | TCP | Serviço interno do PostgreSQL | Disponível; publicação no host não planejada |
| 80 | TCP | Serviço HTTP de teste opcional | Disponível |
| 443 | TCP | HTTPS de saída e serviço TLS opcional | Disponível |

A disponibilidade das portas pode mudar ao longo do tempo. O script de validação deve ser executado novamente antes da implantação da plataforma.

## Recursos Docker existentes

A estação de trabalho continha recursos pertencentes a outros projetos:

- contêiner parado `grafana-lab-01`;
- rede `01-grafana-dashboard-design-fundamentals_default`;
- volume de armazenamento do laboratório Grafana;
- volumes persistentes pertencentes ao projeto de observabilidade híbrida.

Esses recursos foram identificados, mas não foram removidos, renomeados ou modificados.

Preservar contêineres, redes, imagens e volumes de outros projetos faz parte de uma prática operacional segura.

## Procedimento de validação

Execute o script de validação a partir da raiz do repositório:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
    -File .\scripts\powershell\validate-workstation.ps1
```

O script realiza verificações somente de leitura. Ele não:

- instala ou atualiza softwares;
- remove contêineres, imagens, redes ou volumes;
- altera configurações do WSL;
- modifica regras de firewall;
- reserva ou publica portas;
- inicia a plataforma Zabbix;
- modifica o repositório Git.

O script realiza testes de DNS de saída e de TCP 443 somente para os destinos de validação documentados.

## Critérios de aceitação

| Requisito | Condição de aceitação |
|:---:|:---:|
| Sistema operacional | Windows de 64 bits |
| Processador | Pelo menos 4 processadores lógicos |
| Memória física | Pelo menos 8 GB |
| Espaço livre em disco | Pelo menos 20 GB |
| WSL | Kernel WSL 2 disponível |
| Docker | Cliente e servidor Linux respondem com sucesso |
| Docker Compose | Comando `docker compose` disponível |
| Memória do Docker | Pelo menos 4 GB disponíveis |
| DNS | `github.com` e `zabbix.com` resolvem corretamente |
| HTTPS | Conectividade TCP 443 bem-sucedida |
| Porta da interface web | TCP 8080 disponível antes da implantação |
| Porta do servidor Zabbix | TCP 10051 disponível antes da implantação |
| Repositório Git | Repositório válido com uma branch identificada |

Uma verificação opcional pode gerar um aviso sem reprovar a estação de trabalho. Por exemplo, uma porta opcional ocupada pode ser remapeada com segurança na configuração do Compose.

## Resultados da validação

| Área de validação | Resultado |
|:---:|:---:|
| Arquitetura do Windows | Aprovado |
| Processadores lógicos | Aprovado |
| Memória física | Aprovado |
| Capacidade em disco | Aprovado |
| PowerShell | Aprovado |
| Kernel do WSL 2 | Aprovado |
| Cliente e servidor Docker | Aprovado |
| Docker Compose | Aprovado |
| CPU e memória do Docker | Aprovado |
| Portas necessárias | Aprovado |
| Resolução DNS | Aprovado |
| Conectividade HTTPS | Aprovado |
| Repositório Git | Aprovado |
| Conflitos com plataformas ativas | Nenhum detectado |
| Resultado geral | Aprovado |

Resumo final do script:

```text
Passed:   20
Warnings: 0
Failed:   0

RESULT: WORKSTATION APPROVED
```

## Constatações

### Divergência no nome do produto Windows

Uma consulta inicial ao Windows por um método legado retornou `Windows 10 Pro`, embora indicasse o build `26200.9168`.

Um inventário posterior do sistema operacional identificou corretamente `Microsoft Windows 11 Pro`. O campo legado de nome do produto não afetou o PowerShell, o WSL, o Docker ou o laboratório Zabbix.

### Edição do PowerShell

A estação de trabalho utiliza Windows PowerShell 5.1. Os scripts deste repositório permanecem compatíveis com o PowerShell 5.1, a menos que um laboratório posterior exija explicitamente o PowerShell 7.

### Validação do WSL

A interpretação da saída localizada do comando `wsl --list --verbose` produziu inicialmente um aviso falso.

A validação foi aprimorada para consultar diretamente o kernel ativo:

```powershell
wsl.exe --exec uname -r
```

O kernel retornado foi:

```text
6.18.33.2-microsoft-standard-WSL2
```

Isso confirmou que a distribuição padrão opera com WSL 2.

### Gerenciamento de recursos do WSL

Não foi encontrado um arquivo `.wslconfig` personalizado. Portanto, o WSL utiliza seu gerenciamento dinâmico de recursos padrão.

O Docker informou acesso a 8 processadores lógicos e 14.60 GB de memória, atendendo aos requisitos planejados para o laboratório.

## Referência para diagnóstico e resolução de problemas

### O cliente Docker responde, mas o servidor não

1. Confirme que o Docker Desktop está em execução.
2. Verifique o contexto Docker ativo:

```powershell
docker context show
docker context ls
```

3. Confirme que `desktop-linux` está ativo.
4. Reinicie o Docker Desktop se o backend Linux continuar indisponível.
5. Execute `docker version` novamente e confirme que as seções Client e Server aparecem.

### A distribuição WSL está parada

Uma distribuição Ubuntu parada não representa necessariamente um erro. O WSL inicia as distribuições sob demanda.

Verifique as distribuições configuradas:

```powershell
wsl --list --verbose
```

Valide o kernel ativo:

```powershell
wsl.exe --exec uname -r
```

A saída do kernel deve identificar o Microsoft WSL 2.

### Uma porta necessária está ocupada

Identifique a conexão em estado de escuta:

```powershell
Get-NetTCPConnection -LocalPort 8080 -State Listen
```

Utilize o identificador de processo retornado para descobrir o processo responsável:

```powershell
Get-Process -Id <PROCESS_ID>
```

Não encerre um processo sem confirmar sua finalidade e a quem ele pertence. Prefira um remapeamento seguro da porta quando o serviço existente pertencer a outro projeto.

### A resolução DNS falha

Teste o resolvedor configurado:

```powershell
Resolve-DnsName zabbix.com
```

Valide a conectividade TCP de saída:

```powershell
Test-NetConnection zabbix.com -Port 443
```

Revise as configurações de VPN, proxy, firewall e DNS local antes de alterar a configuração da estação de trabalho.

## Evidências

A validação executada confirmou:

- capacidade de processamento e armazenamento da estação de trabalho;
- inventário do Windows e do PowerShell;
- disponibilidade do kernel WSL 2;
- funcionamento do cliente e do servidor Docker;
- disponibilidade do Docker Compose;
- capacidade de CPU e memória do Docker;
- disponibilidade das portas TCP necessárias;
- resolução DNS;
- conectividade HTTPS de saída;
- preservação de recursos Docker não relacionados;
- estado limpo e sincronizado do repositório Git.

O script reutilizável e os resultados documentados fornecem evidências técnicas mais consistentes do que uma grande coleção de capturas de tela do terminal.

Caso sejam adicionadas capturas de tela futuramente, elas devem excluir credenciais, informações pessoais, aplicações não relacionadas e conteúdo desnecessário da estação de trabalho.

## Resultado

A estação de trabalho foi aprovada para a implantação do laboratório Zabbix NOC local.

A etapa 01 posteriormente criou e validou a plataforma reproduzível, composta por PostgreSQL, Zabbix Server e Zabbix Web.

Prossiga para [`Lab 01 — Implantação da plataforma Zabbix`](../01-zabbix-platform/README.md).
