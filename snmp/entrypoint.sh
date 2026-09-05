#!/bin/sh

set -eu

required_variables="
SNMP_COMMUNITY
SNMP_ALLOWED_NETWORK
SNMP_SYSTEM_NAME
SNMP_SYSTEM_LOCATION
SNMP_SYSTEM_CONTACT
"

for variable_name in $required_variables; do
    variable_value="$(printenv "$variable_name" || true)"

    if [ -z "$variable_value" ]; then
        echo "ERROR: Required environment variable is not defined: $variable_name" >&2
        exit 1
    fi
done

umask 077

envsubst \
    '${SNMP_COMMUNITY} ${SNMP_ALLOWED_NETWORK} ${SNMP_SYSTEM_NAME} ${SNMP_SYSTEM_LOCATION} ${SNMP_SYSTEM_CONTACT}' \
    < /etc/snmp/snmpd.conf.template \
    > /tmp/snmpd.conf

mv /tmp/snmpd.conf /etc/snmp/snmpd.conf

echo "Starting the Stage 08 SNMP agent."

exec /usr/sbin/snmpd \
    -f \
    -Lo \
    -C \
    -c /etc/snmp/snmpd.conf
