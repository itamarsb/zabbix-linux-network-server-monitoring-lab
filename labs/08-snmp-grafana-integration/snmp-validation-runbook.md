# Stage 08 — SNMP Validation and Recovery Runbook

[Stage 08 README](README.md) | [Português (Brasil)](snmp-validation-runbook.pt-BR.md)

## Purpose and evidence boundary

This is a **future reproduction procedure** for direct, read-only SNMPv2c queries and an optional operator-controlled Zabbix macro-mismatch experiment. **These reference commands are intended for future runs; they are not an execution log or new results from the original Stage 08 tests.**

The preserved Stage 08 results already show direct polling, a healthy target, an authentication-mismatch incident (`Linux: No SNMP data collection`), and recovery. Any new execution requires separate evidence.

## Preconditions and credential handling

- Use the authorized laboratory only. Run Windows PowerShell from the repository root with the existing operational `.env` and correct Compose project; do not replace it with `.env.example`.
- Verify `snmp-target` is running and, for the optional Zabbix-side failure test, that `zabbix-server` is running too.
- The real community resides in the target container environment and in the Zabbix `{$SNMP_COMMUNITY}` host macro of type **Secret text**. Never print the community, `.env`, container environment dumps, the rendered `snmpd.conf` or published screenshots showing credentials.
- SNMPv2c community strings are not encrypted in transit. Do not perform these checks on production or external networks.
- Keep the actual Net-SNMP agent community unchanged. A deliberately bad standalone query is read-only; changing the Zabbix host macro is an **optional, separately authorized configuration change**.

## A. Check the existing services

```powershell
# Validate Compose without printing the resolved environment
docker compose --env-file .env -f compose.yaml config --quiet

# Confirm the expected target and Zabbix Server are running
docker compose --env-file .env -f compose.yaml ps snmp-target zabbix-server
```

Stop if the project or services do not match the expected lab. The target's existing Docker healthcheck issues an authenticated SNMP GET for `1.3.6.1.2.1.1.3.0` against its container address. Container health does **not** prove that the separate Zabbix host macro is correct.

## B. Read-only OIDs and expected outcomes

The Net-SNMP `zabbixLabView` permits the following numeric scalar OIDs.

| Signal | Numeric OID | Expected output |
|---|---|---|
| System description (`sysDescr.0`) | `1.3.6.1.2.1.1.1.0` | Net-SNMP/Linux description |
| System object ID (`sysObjectID.0`) | `1.3.6.1.2.1.1.2.0` | Net-SNMP enterprise OID |
| Uptime (`sysUpTime.0`) | `1.3.6.1.2.1.1.3.0` | `Timeticks`; changes over time |
| Contact (`sysContact.0`) | `1.3.6.1.2.1.1.4.0` | `NOC Lab Administrator` in example configuration |
| Name (`sysName.0`) | `1.3.6.1.2.1.1.5.0` | `zabbix-lab-snmp-target` in example configuration |
| Location (`sysLocation.0`) | `1.3.6.1.2.1.1.6.0` | `Docker-based NOC Operations Lab` in example configuration |
| Interfaces (`ifNumber.0`) | `1.3.6.1.2.1.2.1.0` | Integer; depends on runtime interfaces |

Names and locations can differ if the operational `.env` overrides the versioned examples. Do not invent fixed uptime values or interface counts.

## C. Successful authenticated polling without a secret command-line argument

The image already includes `net-snmp-tools`. This command runs inside `snmp-target`, uses its existing private environment value to create a temporary client `snmp.conf`, then queries only the container's own address. It avoids passing the **real** community as a `snmpget -c` process argument.

```powershell
# Direct, read-only SNMP GET; do not print the community.
@'
set -eu
umask 077

test -n "$SNMP_COMMUNITY" || {
  echo "SNMP_COMMUNITY is not available" >&2
  exit 1
}
cfg_dir="$(mktemp -d)"
trap 'rm -rf "$cfg_dir"' EXIT

# Create a private Net-SNMP client configuration.
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

`SNMPCONFPATH` selects a client configuration directory; `defCommunity` supplies the SNMPv2c community without a `-c` option. `umask 077` restricts the temporary file, and the shell trap removes it after the command ends. This does not provide encryption on the SNMP wire. Avoid SNMP packet dumps or shell tracing. If the secret contains special characters incompatible with a `defCommunity` token, diagnose privately rather than printing it.

**Positive-control expectation:** all OIDs return appropriate values from the controlled target. If a query fails, check the local agent, permitted OID view, source-address restriction and client syntax; a failed query alone does not identify its cause.

## D. Isolated test with an intentionally invalid community

This command uses **only a fictitious, nonsecret string**. It does not change Zabbix, the target configuration or the real community.

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

A timeout or failed SNMP GET is expected **only as a meaningful negative control after step C has succeeded against the same target**. Without that positive control, a network or agent failure could give the same symptom. This standalone query **does not cause** the historical Zabbix problem event.

## E. Optional Zabbix macro-mismatch/recovery exercise

**Manual and configuration-changing; not performed by this runbook.** Proceed only with explicit operator authorization and a safe way to restore the current secret.

1. Confirm the Stage 08 host `zabbix-lab-snmp-target` uses `snmp-target:161`, the `Linux by SNMP` template, green SNMP availability and fresh items.
2. Confirm an authorized operator can recover the **correct rotated** community from the local private `.env` without echoing, copying to public notes, or capturing it in screenshots. Abort if restoration is uncertain.
3. In Zabbix **Data collection → Hosts → zabbix-lab-snmp-target → Macros**, temporarily replace **only** `{$SNMP_COMMUNITY}` with `invalid-lab-community-for-test`. Keep the type **Secret text**; do not edit `SNMP_COMMUNITY` on the agent or restart containers.
4. Observe subsequent collection cycles. Record whether SNMP item updates cease and whether the `Linux: No SNMP data collection` event appears. Exact timing depends on the Zabbix configuration; an event is not guaranteed merely by the negative query in step D.
5. Restore **only** the host macro to the correct operational community through a private UI interaction.
6. Verify SNMP availability becomes green, fresh values appear, and any generated problem recovers. Docker health alone is not a sufficient recovery criterion.

Do not overwrite or reinterpret the original Stage 08 evidence. If the exercise is performed again, retain new screenshots and timestamps separately, without any credential value.

## Troubleshooting and acceptance

- **Target unhealthy:** stop and inspect only the relevant container status and sanitized logs; do not stop the stack.
- **Positive query fails:** inspect agent status, authorization CIDR, OID view and connection; never print the full `rocommunity` line of `snmpd.conf`.
- **Negative query fails:** treat this only as rejection of the bad string when the positive control passes.
- **Zabbix does not generate an event:** verify macro, host, template, item freshness and trigger conditions before claiming reproduction.
- **Restoration:** confirm a fresh successful poll, Zabbix SNMP availability and event recovery, if an event was generated.

Consider the runbook **validated** only after a future practical execution with outcomes and sanitized evidence.

## References

- [Stage 08 README and historical evidence](README.md)
- [SNMP Dockerfile and agent files](../../snmp/)
- [Compose healthcheck configuration](../../compose.yaml)
- [Official Net-SNMP snmp.conf manual](https://www.net-snmp.org/docs/man/snmp.conf.html)
- [Official Net-SNMP snmpget manual](https://www.net-snmp.org/docs/man/snmpget.html)
