# Stage 08 — Runbook de validação SNMP e recuperação

[README do Stage 08](README.pt-BR.md) | [English](snmp-validation-runbook.md)

## Objetivo e limites das evidências

Este é um **procedimento para reproduções futuras** de consultas SNMPv2c diretas e somente de leitura, além de um experimento opcional de divergência da macro do Zabbix, controlado pelo operador. **Os comandos de referência destinam-se a futuras execuções; não representam um registro de execução nem novos resultados dos testes originais do Stage 08.**

As evidências preservadas do Stage 08 já demonstram consultas diretas bem-sucedidas, alvo saudável, incidente por incompatibilidade de autenticação (`Linux: No SNMP data collection`) e recuperação. Uma nova execução exigirá evidências separadas.

## Pré-requisitos e segurança da comunidade

- Utilize apenas o laboratório Zabbix NOC autorizado. Execute os comandos no PowerShell do Windows, a partir da raiz do repositório, com o `.env` **operacional existente** e o projeto Compose correto; não substitua esse arquivo por `.env.example`.
- Confirme que `snmp-target` está em execução e, para o experimento opcional no Zabbix, que `zabbix-server` também está ativo.
- A comunidade real está no ambiente do contêiner do alvo e na macro `{$SNMP_COMMUNITY}` do host Zabbix, do tipo **Secret text**. Nunca imprima a comunidade, o `.env`, variáveis de ambiente completas, o `snmpd.conf` gerado ou capturas contendo credenciais.
- O SNMPv2c não criptografa a comunidade em trânsito. Não execute esses testes em sistemas produtivos ou redes externas.
- Mantenha a comunidade real do agente inalterada. Uma consulta isolada com comunidade falsa é somente de leitura; modificar a macro do Zabbix é uma **etapa opcional que exige autorização operacional separada**.

## A. Conferir os serviços existentes

```powershell
# Validar o Compose sem imprimir a configuração resolvida
docker compose --env-file .env -f compose.yaml config --quiet

# Conferir o alvo esperado e o Zabbix Server
docker compose --env-file .env -f compose.yaml ps snmp-target zabbix-server
```

Interrompa o procedimento se o projeto ou os serviços não corresponderem ao laboratório esperado. O healthcheck existente do alvo executa um SNMP GET autenticado ao OID `1.3.6.1.2.1.1.3.0` no endereço do próprio contêiner. Seu estado saudável **não comprova** que a macro independente do host no Zabbix esteja correta.

## B. OIDs de somente leitura e resultados esperados

A view Net-SNMP `zabbixLabView` permite os seguintes OIDs escalares numéricos.

| Sinal | OID numérico | Resultado esperado |
|---|---|---|
| Descrição do sistema (`sysDescr.0`) | `1.3.6.1.2.1.1.1.0` | Descrição Linux / Net-SNMP |
| Identificador do sistema (`sysObjectID.0`) | `1.3.6.1.2.1.1.2.0` | OID empresarial Net-SNMP |
| Tempo de atividade (`sysUpTime.0`) | `1.3.6.1.2.1.1.3.0` | `Timeticks`; muda com o tempo |
| Contato (`sysContact.0`) | `1.3.6.1.2.1.1.4.0` | `NOC Lab Administrator` na configuração de exemplo |
| Nome (`sysName.0`) | `1.3.6.1.2.1.1.5.0` | `zabbix-lab-snmp-target` na configuração de exemplo |
| Localização (`sysLocation.0`) | `1.3.6.1.2.1.1.6.0` | `Docker-based NOC Operations Lab` na configuração de exemplo |
| Quantidade de interfaces (`ifNumber.0`) | `1.3.6.1.2.1.2.1.0` | Inteiro; depende das interfaces atuais |

Nome, contato e localização podem diferir quando o `.env` operacional utiliza valores diferentes dos exemplos versionados. Não invente números fixos para o tempo de atividade ou para a quantidade de interfaces.

## C. Consulta autenticada sem passar a comunidade em argumento

A imagem já inclui `net-snmp-tools`. O comando abaixo executa dentro do contêiner `snmp-target`, usa o valor privado já disponível no ambiente para criar um `snmp.conf` temporário e consulta somente o endereço do próprio contêiner. Ele evita fornecer a **comunidade real** como argumento `snmpget -c`.

```powershell
# SNMP GET direto, somente de leitura, sem imprimir a comunidade
@'
set -eu
umask 077

test -n "$SNMP_COMMUNITY" || {
  echo "SNMP_COMMUNITY is not available" >&2
  exit 1
}
cfg_dir="$(mktemp -d)"
trap 'rm -rf "$cfg_dir"' EXIT

# Criar uma configuração privada e temporária do cliente Net-SNMP
printf 'defCommunity %s\n' "$SNMP_COMMUNITY" \
  > "$cfg_dir/snmp.conf"

target="$(hostname -i | awk '{print $1}')"

SNMPCONFPATH="$cfg_dir" snmpget \
  -v2c -On -t 2 -r 1 "$target" \
  1.3.6.1.2.1.1.1.0 \
  1.3.6.1.2.1.1.2.0 \
  1.3.6.1.2.1.1.3.0 \
  1.3.6.1.2.1.1.4.0 \
  1.3.6.1.2.1.1.5.0 \
  1.3.6.1.2.1.1.6.0 \
  1.3.6.1.2.1.2.1.0
'@ | docker compose --env-file .env -f compose.yaml `
  exec -T snmp-target sh

if ($LASTEXITCODE -ne 0) {
    throw "Direct SNMP validation failed."
}
```

`SNMPCONFPATH` seleciona o diretório de configuração do cliente; a diretiva `defCommunity` fornece a comunidade SNMPv2c sem utilizar `-c`. `umask 077` restringe o arquivo temporário, e o `trap` o remove ao encerrar o comando. Isso reduz a exposição acidental nos argumentos dos processos, mas **não** oferece criptografia para o SNMPv2c. Evite despejos de pacotes ou rastreamento detalhado do shell. Se a comunidade tiver caracteres incompatíveis com a sintaxe de `defCommunity`, investigue a configuração privadamente, sem imprimir o segredo.

**Controle positivo esperado:** todos os OIDs retornam valores apropriados do alvo controlado. Em caso de falha, verifique o agente local, a view de OIDs, a restrição de origem e a sintaxe; uma consulta malsucedida, isoladamente, não identifica a causa.

## D. Teste isolado com comunidade intencionalmente inválida

Esta verificação utiliza **somente um valor fictício e não secreto**. Não altera o Zabbix, a configuração do alvo ou a comunidade verdadeira.

```powershell
@'
set -eu
target="$(hostname -i | awk '{print $1}')"

if snmpget -v2c -On -t 2 -r 0 \
    -c 'invalid-lab-community-for-test' \
    "$target" 1.3.6.1.2.1.1.3.0; then
  echo "Unexpected success: inspect the laboratory configuration."
  exit 1
else
  echo "Expected failure for deliberately invalid test community."
fi
'@ | docker compose --env-file .env -f compose.yaml `
  exec -T snmp-target sh

if ($LASTEXITCODE -ne 0) {
    throw "Invalid-community check was inconclusive."
}
```

O timeout ou a falha do SNMP GET será um controle negativo útil **somente após o sucesso da etapa C no mesmo alvo**. Sem o controle positivo, uma falha de rede ou do agente produziria sintoma semelhante. Essa consulta isolada **não provoca** o evento de problema histórico do Zabbix.

## E. Experimento opcional de divergência da macro e recuperação

**Etapa manual que altera a configuração; não executada pelo runbook.** Prossiga apenas com autorização explícita do operador e com um meio seguro de restaurar o segredo atual.

1. Confirme que o host `zabbix-lab-snmp-target` utiliza `snmp-target:161`, o template `Linux by SNMP`, disponibilidade SNMP verde e itens atualizados.
2. Confirme que um operador autorizado consegue restaurar a **comunidade correta e rotacionada** do `.env` local e privado sem imprimi-la, colocá-la em anotações públicas ou capturá-la em imagens. Aborte se houver dúvida sobre a restauração.
3. No Zabbix, acesse **Data collection → Hosts → zabbix-lab-snmp-target → Macros**. Substitua temporariamente **somente** a macro `{$SNMP_COMMUNITY}` por `invalid-lab-community-for-test`. Mantenha o tipo **Secret text**; não edite a variável `SNMP_COMMUNITY` do agente nem reinicie contêineres.
4. Observe ciclos seguintes de coleta. Registre se os itens SNMP deixam de ser atualizados e se surge `Linux: No SNMP data collection`. O tempo dependerá da configuração do Zabbix; o evento não é garantido pela consulta inválida da etapa D.
5. Restaure **somente** a macro do host ao valor operacional correto, por interação privada na interface.
6. Confirme a disponibilidade SNMP verde, novos valores coletados e a recuperação de qualquer problema gerado. O healthcheck do Docker, isoladamente, não comprova a recuperação do monitoramento Zabbix.

Não substitua nem reinterprete as evidências originais do Stage 08. Uma eventual repetição deve gerar novas capturas e horários, separados dos históricos e sem revelar credenciais.

## Diagnóstico e critérios de aceitação

- **Alvo não saudável:** interrompa o procedimento e consulte apenas o estado e os logs sanitizados do serviço. Não reinicie toda a stack.
- **Consulta positiva falhou:** confira agente, CIDR autorizado, view dos OIDs e conectividade; nunca imprima a linha completa `rocommunity` do `snmpd.conf`.
- **Consulta negativa falhou:** interprete apenas como rejeição do valor fictício, desde que o controle positivo tenha passado.
- **Evento Zabbix não foi criado:** verifique macro, host, template, atualização dos itens e condições da trigger antes de afirmar que o incidente foi reproduzido.
- **Após a restauração:** confirme nova consulta bem-sucedida, disponibilidade SNMP no Zabbix e recuperação do evento, se gerado.

O runbook só deverá ser considerado **validado** após uma futura execução prática com resultados e evidências sanitizadas.

## Referências

- [README e evidências históricas do Stage 08](README.pt-BR.md)
- [Dockerfile e arquivos do agente SNMP](../../snmp/)
- [Healthcheck no Compose](../../compose.yaml)
- [Manual oficial do Net-SNMP snmp.conf](https://www.net-snmp.org/docs/man/snmp.conf.html)
- [Manual oficial do Net-SNMP snmpget](https://www.net-snmp.org/docs/man/snmpget.html)
