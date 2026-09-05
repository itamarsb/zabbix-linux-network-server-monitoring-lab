FROM alpine:3.22

RUN apk add --no-cache \
        gettext-envsubst \
        net-snmp \
        net-snmp-tools

COPY snmp/snmpd.conf.template /etc/snmp/snmpd.conf.template
COPY snmp/entrypoint.sh /usr/local/bin/snmp-entrypoint.sh

RUN chmod 0755 /usr/local/bin/snmp-entrypoint.sh

EXPOSE 161/udp

ENTRYPOINT ["/usr/local/bin/snmp-entrypoint.sh"]
