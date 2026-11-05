# Checklist de triagem de alertas para NOC

[English](noc-alert-triage-checklist.md) | **Português (Brasil)**

[Voltar ao repositório](../README.pt-BR.md)

> **Finalidade:** checklist de consulta rápida para operadores de NOC que tratam alertas do Zabbix. Complementa os procedimentos validados nas etapas 05 a 08; este documento é um recurso operacional reutilizável, **não** uma evidência de execução de um novo teste de incidente.

**Fluxo de trabalho:** Detectar → Validar → Classificar → Reconhecer → Diagnosticar → Escalonar ou restaurar → Verificar → Documentar.

## 1. Recebimento e validação do alerta

- [ ] Abra **Monitoring → Problems** no Zabbix; registre o horário do evento, o ID do problema/evento, o host, a *trigger* e o estado atual.
- [ ] Identifique o serviço, o ativo e o sinal de monitoramento (item) afetados, além do primeiro sintoma observado.
- [ ] Verifique se o evento ainda está atual: compare **Latest data**, gráficos recentes, horários de coleta dos itens e histórico de problemas.
- [ ] Procure alertas relacionados e dependências compartilhadas; diferencie uma única verificação com falha de um incidente mais abrangente.
- [ ] Confira se o host ou o problema está sob **manutenção planejada ou supressão** antes de iniciar notificações.
- [ ] Confirme se alguma ação de notificação foi efetivamente executada. Um evento de problema **não** comprova, por si só, que uma mensagem foi enviada.
- [ ] Registre dados de monitoramento ausentes, atrasados ou não suportados, em vez de interpretá-los como um valor zero saudável.

**Registro inicial:** `ID do evento: ____ | Host/serviço: ____ | Início (data/hora/fuso): ____ | Estado atual: ____ | Operador: ____`

## 2. Avaliação da severidade e do impacto

- [ ] Consulte a severidade configurada no Zabbix; não presuma que ela seja equivalente à prioridade para o negócio.
- [ ] Avalie o impacto sobre usuários/clientes, os serviços afetados, o alcance, a duração, as dependências críticas e as alternativas disponíveis.
- [ ] Verifique se vários hosts ou locais foram afetados e se o impacto está aumentando.
- [ ] Priorize conforme a política de resposta da organização. Escalone rapidamente situações com impacto crítico no serviço, mesmo que a severidade da *trigger* seja inferior.

| Severidade da trigger no Zabbix | Ação inicial do operador |
|:---:|:---|
| **Disaster / High** | Priorizar validação e escalonamento imediatos conforme o impacto e a política de resposta. |
| **Average** | Investigar prontamente, avaliar o impacto no serviço e escalonar caso o incidente se amplie ou exceda a autoridade do operador. |
| **Warning** | Validar o sinal e sua tendência; avaliar se há degradação do serviço ou necessidade de ação preventiva. |
| **Information / Not classified** | Confirmar o contexto do evento e documentá-lo ou encaminhá-lo conforme apropriado. |

> Estas são orientações de triagem, **não** metas fixas de SLA. Severidades, prazos para acionamento e limites de escalonamento devem ser definidos por uma política operacional aprovada.

## 3. Diagnóstico inicial somente de leitura

- [ ] Compare as últimas medições com a referência anterior ao incidente e com outros sinais independentes.
- [ ] Verifique a disponibilidade do host/agente, alterações recentes de configuração ou implantação e eventos correlacionados.
- [ ] Selecione verificações pertinentes que sejam somente de leitura; registre os resultados e horários antes de qualquer intervenção.

| Sintoma | Primeiras verificações | Laboratório relacionado |
|:---:|:---|:---:|
| Falha HTTP ou TCP | Código de resposta, etapa com falha, acessibilidade da porta, estado do serviço/contêiner | [Stage 04](../labs/04-network-service-monitoring/README.pt-BR.md) |
| Falha DNS | Resolução de nomes, resolvedor, alvo, mudanças recentes; comparar o valor monitorado | [Stage 05](../labs/05-triggers-alert-handling/README.pt-BR.md) |
| Host ou agente indisponível | Estado do agente, caminho de rede, dados recentes, serviços dependentes | [Stages 02–03](../labs/02-linux-host-monitoring/README.pt-BR.md) |
| Falha na coleta SNMP | Atualidade dos itens, acessibilidade do alvo, estado da interface, credenciais/configuração **sem revelar segredos** | [Stage 08](../labs/08-snmp-grafana-integration/README.pt-BR.md) |
| Alerta sem e-mail | Tipo de mídia, condições da ação, severidades da mídia do usuário, registro de ações do Zabbix e Mailpit (somente no laboratório) | [Stage 06](../labs/06-alert-delivery-notifications/README.pt-BR.md) |
| Alerta durante manutenção | Escopo e período de manutenção, problema suprimido, comportamento esperado das notificações | [Stage 07](../labs/07-maintenance-operational-reporting/README.pt-BR.md) |

- [ ] Diferencie **fato observado**, **hipótese de trabalho** e **causa não verificada** nas anotações do incidente.
- [ ] Se o alerta for um falso positivo ou uma falha de monitoramento, documente as evidências; não desabilite verificações apenas para esvaziar a fila.

## 4. Reconhecimento, comunicação e escalonamento

- [ ] Reconheça o problema no Zabbix **quando a responsabilidade pela triagem tiver sido efetivamente assumida** e acrescente uma anotação do operador.
- [ ] Crie ou atualize o registro do incidente/chamado conforme o processo padrão da equipe.
- [ ] Escalone imediatamente em caso de impacto significativo, possível exposição de segurança, preocupação com segurança física, alcance incerto ou falta de autorização/acesso.
- [ ] Escalone à equipe adequada de NOC L2/L3, aplicações, infraestrutura, redes, cloud ou segurança quando necessário.
- [ ] Inclua na passagem de responsabilidade: ID do evento, host/serviço, horário de início, impacto, severidade, evidências de monitoramento, ações executadas, hipóteses e próximo responsável.
- [ ] Registre quem aceitou o escalonamento e quando. Mantenha as atualizações acordadas enquanto o incidente estiver ativo.

> **Não** reinicie serviços, altere configurações de produção, silencie alertas, rotacione credenciais nem execute comandos destrutivos sem a autorização exigida e um plano de rollback.

## 5. Mitigação e recuperação

- [ ] Confirme que a mitigação selecionada foi aprovada, tem escopo limitado e dispõe de opção de rollback.
- [ ] Registre cada ação, operador, horário, resultado esperado e resultado observado.
- [ ] Verifique o serviço pela **perspectiva do consumidor/sistema** (por exemplo, resposta HTTP ou porta acessível).
- [ ] Valide independentemente a **perspectiva do monitoramento**: valores recentes dos itens, transição da *trigger*, gráficos e estado do evento.
- [ ] Confirme a recuperação dos serviços dependentes e verifique se existem problemas relacionados ainda abertos.
- [ ] Verifique separadamente a execução das notificações e mensagens de recuperação, quando a ação estiver configurada e for aplicável.
- [ ] Não considere a recuperação concluída apenas porque um evento desapareceu ou foi encerrado manualmente.

## 6. Encerramento e passagem de turno

- [ ] Registre os horários de detecção, reconhecimento, escalonamento, mitigação e confirmação da recuperação (com fuso horário).
- [ ] Documente a causa raiz **somente se tiver sido estabelecida**; caso contrário, registre as constatações atuais e a investigação pendente.
- [ ] Preserve evidências sem dados sensíveis e documente riscos residuais ou atividades futuras.
- [ ] Confirme que alterações temporárias ou condições de teste foram revertidas e que janelas de manutenção foram encerradas, quando aplicável.
- [ ] Encerre o chamado apenas conforme os critérios de encerramento da equipe; identifique pendências e a próxima equipe responsável.
- [ ] Se o trabalho atravessar a troca de turno, prepare uma passagem com estado atual, ações realizadas, verificações pendentes e contatos de escalonamento.

**Registro de encerramento:** `Impacto: ____ | Evidências: ____ | Mitigação: ____ | Recuperação confirmada em: ____ | Ações pendentes/responsável: ____`

## Material validado relacionado

- [Stage 05 — Triggers, severidades e reconhecimento](../labs/05-triggers-alert-handling/README.pt-BR.md)
- [Stage 06 — Entrega de notificações e diagnóstico do registro de ações](../labs/06-alert-delivery-notifications/README.pt-BR.md)
- [Stage 07 — Manutenção planejada e relatórios operacionais](../labs/07-maintenance-operational-reporting/README.pt-BR.md)
- [Stage 07 — Exemplo de passagem de turno](../labs/07-maintenance-operational-reporting/shift-handover-report.pt-BR.md)
- [Stage 08 — Monitoramento SNMP e recuperação](../labs/08-snmp-grafana-integration/README.pt-BR.md)

**Nota de segurança:** nunca inclua em commits credenciais, comunidades SNMP, tokens de acesso, chaves privadas, conteúdo sensível de eventos ou capturas de tela sem ocultação dos dados. A ação opcional de notificações SNMP da etapa 08 não foi validada e permanece desabilitada; não presuma que todo incidente SNMP gere um e-mail.
